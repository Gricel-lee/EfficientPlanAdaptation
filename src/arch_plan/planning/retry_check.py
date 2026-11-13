"""Check the mission constraints of a plan when task retries are added to it.

A Pareto-optimal solution gives a maximum number of retries per task, but the plan
of the task planner does not include them. This module:

1. injects retries into a plan (a retry takes the same time as the original task,
   so n retries add n copies of the task right after it, for the same agent),
2. writes the plan as a constraint programming problem in CPMpy, and
3. reports which mission constraints are violated, and draws the Gantt charts.

Mission constraints checked
---------------------------
  ordering   : a task starts after its dependencies in the "task_graph" of the
               problem are complete (AND: all of them, OR: at least one). A task
               is complete when its last attempt (original or retry) ends.
  deadline   : every action ends by "max_duration" (in "constraints").
  completion : every task in "tasks_to_be_completed" (in "constraints") is in the plan.

Assumptions of the constraint programming model
-----------------------------------------------
  - Each agent keeps the order of its actions, and does one action at a time.
  - Durations are the ones of the original plan.
  - Actions can be delayed, but never start earlier than in the original plan.
  - The solver first minimises the number of violated constraints, and then starts
    every action as early as possible.
"""

from dataclasses import dataclass, field, replace
from typing import Optional, Union

import cpmpy as cp
import matplotlib
from matplotlib.axes import Axes
from matplotlib.figure import Figure
from matplotlib.lines import Line2D
from matplotlib.patches import Patch

from arch_plan.restapi.timeline import parse_plan

# A condition is either already decided (bool) or a CPMpy expression over the start times
Condition = Union[bool, cp.expressions.core.Expression]

# ---- Colours of the Gantt charts ----
COLOR_SURFACE: str = "#fcfcfb"
COLOR_TEXT: str = "#0b0b0b"
COLOR_TEXT_MUTED: str = "#898781"
COLOR_TASK: str = "#2a78d6"
COLOR_RETRY: str = "#eb6834"
COLOR_MOVE: str = "#c3c2b7"
COLOR_VIOLATION: str = "#d03b3b"


# ---------------------------------------------------------------------------
# Data classes
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Action:
    """One action of a plan: an agent moving, or an agent doing a task (or retrying it).

    Attributes:
        agent: Id of the agent doing the action.
        name: "move" or "dotask".
        start: Start time of the action.
        end: End time of the action.
        from_loc: Location where the action starts.
        to_loc: Location where the action ends.
        task_id: Id of the task for a "dotask" action, None for a "move" action.
        attempt: 0 for the original action, n for the n-th retry of a task.
        earliest_start: Earliest time at which the action is allowed to start.
    """
    agent: str
    name: str
    start: int
    end: int
    from_loc: str
    to_loc: str
    task_id: Optional[str] = None
    attempt: int = 0
    earliest_start: int = 0

    @property
    def duration(self) -> int:
        """Return the duration of the action."""
        return self.end - self.start

    @property
    def is_task(self) -> bool:
        """Return True if the action does (or retries) a task."""
        return self.name == "dotask"

    @property
    def is_retry(self) -> bool:
        """Return True if the action is a retry of a task."""
        return self.attempt > 0


@dataclass(frozen=True)
class Violation:
    """A mission constraint that does not hold in a plan.

    Attributes:
        kind: "ordering", "deadline" or "completion".
        subject: Id of the task that violates the constraint, or "mission" for the deadline.
        message: Explanation of the violation.
    """
    kind: str
    subject: str
    message: str


@dataclass
class CheckResult:
    """Result of checking the mission constraints of a plan.

    Attributes:
        actions: Actions of the plan, with the start and end times of the checked schedule.
        violations: Mission constraints that are violated.
        num_constraints: Number of mission constraints that were checked.
        makespan: Time at which the last action ends.
        max_duration: Deadline of the mission, None if the problem does not define one.
    """
    actions: list[Action]
    violations: list[Violation] = field(default_factory=list)
    num_constraints: int = 0
    makespan: int = 0
    max_duration: Optional[int] = None


# ---------------------------------------------------------------------------
# Reading the plan and the retries
# ---------------------------------------------------------------------------

def load_plan(plan_file: str) -> list[Action]:
    """Read a plan.txt file into a list of actions.

    Args:
        plan_file: Path of the plan.txt file written by the task planner.

    Returns:
        Actions of the plan, in the order of the file (grouped per agent, in time order).
    """
    actions: list[Action] = []
    for parsed in parse_plan(plan_file):
        params: list[str] = parsed["params"]
        is_task: bool = parsed["name"] == "dotask"
        actions.append(Action(
            agent=parsed["agent"],
            name=parsed["name"],
            start=parsed["start"],
            end=parsed["end"],
            from_loc=params[1] if is_task else params[0],
            to_loc=params[2] if is_task else params[1],
            task_id=params[0] if is_task else None,
            earliest_start=parsed["start"],
        ))
    return actions


def get_agents(actions: list[Action]) -> list[str]:
    """Return the ids of the agents of a plan, in order of first appearance.

    Args:
        actions: Actions of the plan.

    Returns:
        Agent ids, without duplicates.
    """
    return list(dict.fromkeys(action.agent for action in actions))


def get_agent_retries(pareto_solution: dict, actions: list[Action], agent: str) -> dict[str, int]:
    """Return the maximum number of retries of each task of an agent in a Pareto solution.

    The Pareto solution lists the retries of an agent in the same order as its tasks in
    the plan, with task names that may be shortened (e.g. "Row3" for "Harvest_Row3").
    The retries are therefore matched to the tasks of the plan by position.

    Args:
        pareto_solution: One entry of "pareto" in output_plan_results.json.
        actions: Actions of the original plan.
        agent: Id of the agent.

    Returns:
        Dictionary {task id in the plan: maximum number of retries}.

    Raises:
        ValueError: If the retries of the Pareto solution do not match the tasks of the agent.
    """
    plan_tasks: list[str] = [a.task_id for a in actions if a.agent == agent and a.is_task]
    entries: list[dict] = [e for e in pareto_solution["tasksRetries"] if e["agent"] == agent]
    if len(entries) != len(plan_tasks):
        raise ValueError(f"Agent {agent} has {len(plan_tasks)} tasks in the plan but "
                         f"{len(entries)} retry entries in the Pareto solution")
    retries: dict[str, int] = {}
    for task_id, entry in zip(plan_tasks, entries):
        if not task_id.endswith(str(entry["task"])):
            raise ValueError(f"Retry entry {entry['task']!r} does not match plan task {task_id!r} of agent {agent}")
        retries[task_id] = int(entry["maxRetry"])
    return retries


def inject_retries(actions: list[Action], retries: dict[str, int]) -> list[Action]:
    """Add the retries of each task to a plan.

    A retry takes the same time as the original task, so n retries add n copies of the
    task right after it, for the same agent. The copies keep the times of the original
    task: the schedule with retries is computed afterwards by check_plan.

    Args:
        actions: Actions of the original plan.
        retries: Dictionary {task id: number of retries to add}.

    Returns:
        New list of actions, including the retries.
    """
    with_retries: list[Action] = []
    for action in actions:
        with_retries.append(action)
        for attempt in range(1, retries.get(action.task_id, 0) + 1 if action.is_task else 1):
            with_retries.append(replace(action, attempt=attempt))
    return with_retries


# ---------------------------------------------------------------------------
# Mission constraints
# ---------------------------------------------------------------------------

def _all(conditions: list[Condition]) -> Condition:
    """Return the conjunction of conditions, simplifying the ones already decided.

    Args:
        conditions: Conditions (booleans or CPMpy expressions).

    Returns:
        False if any condition is False, True if all are True, a CPMpy expression otherwise.
    """
    if any(c is False for c in conditions):
        return False
    open_conditions: list = [c for c in conditions if c is not True]
    return cp.all(open_conditions) if open_conditions else True


def _any(conditions: list[Condition]) -> Condition:
    """Return the disjunction of conditions, simplifying the ones already decided.

    Args:
        conditions: Conditions (booleans or CPMpy expressions).

    Returns:
        True if any condition is True, False if all are False, a CPMpy expression otherwise.
    """
    if any(c is True for c in conditions):
        return True
    open_conditions: list = [c for c in conditions if c is not False]
    return cp.any(open_conditions) if open_conditions else False


def _decided(condition: Condition) -> Condition:
    """Convert a condition over plain numbers (e.g. a numpy boolean) to a Python bool.

    Args:
        condition: Result of a comparison, over numbers or over CPMpy variables.

    Returns:
        A Python bool if the comparison was over numbers, the CPMpy expression otherwise.
    """
    return condition if isinstance(condition, cp.expressions.core.Expression) else bool(condition)


def get_concrete_tasks(problem: dict) -> set[str]:
    """Return the ids of the tasks that agents can do (the other task_graph nodes are virtual).

    Args:
        problem: Planning problem (parsed JSON).

    Returns:
        Set of task ids.
    """
    return {task["id"] for agent in problem.get("agents", []) for task in agent.get("tasks", []) if "id" in task}


def get_completion_times(actions: list[Action], ends: list) -> dict[str, object]:
    """Return when each task of the plan is complete: the end of its last attempt.

    Args:
        actions: Actions of the plan (including retries).
        ends: End time of each action (numbers or CPMpy expressions), aligned with actions.

    Returns:
        Dictionary {task id: end of its last attempt}.
    """
    completion: dict[str, object] = {}
    for action, end in zip(actions, ends):
        if action.is_task:
            completion[action.task_id] = end  # later attempts overwrite earlier ones
    return completion


def is_after(start: object, node: str, problem: dict, completion: dict[str, object],
             visiting: frozenset = frozenset()) -> Condition:
    """Return the condition "an action starting at `start` comes after `node` is complete".

    A task of the plan is complete when its last attempt ends. A task that agents can do
    but that is not in the plan is never complete. A virtual node of the task graph is
    complete when its own dependencies are (AND: all of them, OR: at least one).

    Args:
        start: Start time of the action (a number or a CPMpy expression).
        node: Id of the task_graph node the action depends on.
        problem: Planning problem (parsed JSON).
        completion: Dictionary {task id: completion time}, see get_completion_times.
        visiting: Nodes being expanded, to stop on circular dependencies.

    Returns:
        A boolean if the condition is already decided, a CPMpy expression otherwise.
    """
    if node in completion:
        return _decided(start >= completion[node])
    if node in get_concrete_tasks(problem) or node in visiting:
        return False
    graph_node: dict = problem.get("task_graph", {}).get(node, {})
    conditions: list[Condition] = [
        is_after(start, dep, problem, completion, visiting | {node})
        for dep in graph_node.get("depends_on", [])
    ]
    if graph_node.get("dependency_type", "AND") == "OR":
        return _any(conditions) if conditions else True
    return _all(conditions)


def get_ordering_condition(action: Action, start: object, problem: dict,
                           completion: dict[str, object]) -> Condition:
    """Return the ordering constraint of a task: it starts after its dependencies are complete.

    Args:
        action: First attempt of a task in the plan.
        start: Start time of the action (a number or a CPMpy expression).
        problem: Planning problem (parsed JSON).
        completion: Dictionary {task id: completion time}, see get_completion_times.

    Returns:
        A boolean if the constraint is already decided, a CPMpy expression otherwise.
    """
    graph_node: dict = problem.get("task_graph", {}).get(action.task_id, {})
    conditions: list[Condition] = [is_after(start, dep, problem, completion)
                                   for dep in graph_node.get("depends_on", [])]
    if graph_node.get("dependency_type", "AND") == "OR":
        return _any(conditions) if conditions else True
    return _all(conditions)


def get_mission_constraints(actions: list[Action], starts: list, problem: dict) -> dict[tuple[str, str], Condition]:
    """Return the mission constraints of a plan, over the given start times.

    Args:
        actions: Actions of the plan (including retries).
        starts: Start time of each action (numbers or CPMpy expressions), aligned with actions.
        problem: Planning problem (parsed JSON).

    Returns:
        Dictionary {(kind, subject): condition}, where kind is "ordering", "deadline" or
        "completion", and the condition is a boolean or a CPMpy expression.
    """
    ends: list = [start + action.duration for action, start in zip(actions, starts)]
    completion: dict[str, object] = get_completion_times(actions, ends)
    mission: dict = problem.get("constraints", {})
    constraints: dict[tuple[str, str], Condition] = {}

    for action, start in zip(actions, starts):
        if action.is_task and not action.is_retry and action.task_id in problem.get("task_graph", {}):
            constraints[("ordering", action.task_id)] = get_ordering_condition(action, start, problem, completion)

    if "max_duration" in mission:
        constraints[("deadline", "mission")] = _all([_decided(end <= int(mission["max_duration"])) for end in ends])

    for task_id in mission.get("tasks_to_be_completed", []):
        constraints[("completion", task_id)] = task_id in completion

    return constraints


# ---------------------------------------------------------------------------
# Constraint programming model
# ---------------------------------------------------------------------------

def get_horizon(actions: list[Action]) -> int:
    """Return an upper bound of the time needed by any schedule of the plan.

    Args:
        actions: Actions of the plan (including retries).

    Returns:
        Latest earliest start plus the sum of all the durations.
    """
    return max((a.earliest_start for a in actions), default=0) + sum(a.duration for a in actions)


def get_agent_sequence_constraints(actions: list[Action], starts: list) -> list:
    """Return the constraints that keep the order of the actions of each agent.

    Each action of an agent starts after the previous action of the same agent ends, so
    an agent does one action at a time, in the order of the plan.

    Args:
        actions: Actions of the plan (including retries), in time order per agent.
        starts: CPMpy start time variable of each action, aligned with actions.

    Returns:
        List of CPMpy constraints.
    """
    constraints: list = []
    previous: dict[str, int] = {}
    for index, action in enumerate(actions):
        if action.agent in previous:
            before: int = previous[action.agent]
            constraints.append(starts[index] >= starts[before] + actions[before].duration)
        previous[action.agent] = index
    return constraints


def build_model(actions: list[Action], problem: dict, keep_times: bool = False) -> tuple[cp.Model, list, dict]:
    """Write the plan as a constraint programming problem in CPMpy.

    Decision variables: the start time of each action. Hard constraints: each agent keeps
    the order of its actions, and no action starts earlier than in the original plan.
    Each mission constraint is linked to a Boolean variable that tells if it holds.
    Objective: minimise the number of violated mission constraints first, and then the
    start times.

    Args:
        actions: Actions of the plan (including retries).
        problem: Planning problem (parsed JSON).
        keep_times: If True, every action is fixed to the times it has in `actions`, so the
            plan is checked exactly as given. Defaults to False (actions can be delayed).

    Returns:
        Tuple (model, starts, satisfied) where starts is the list of start time variables
        and satisfied is {(kind, subject): Boolean variable or bool} per mission constraint.
    """
    horizon: int = get_horizon(actions)
    starts: list = [cp.intvar(a.earliest_start, horizon, name=f"start_{i}") for i, a in enumerate(actions)]
    model: cp.Model = cp.Model()

    if keep_times:
        model += [start == action.start for start, action in zip(starts, actions)]
    else:
        model += get_agent_sequence_constraints(actions, starts)

    satisfied: dict = {}
    for key, condition in get_mission_constraints(actions, starts, problem).items():
        if isinstance(condition, bool):
            satisfied[key] = condition
        else:
            satisfied[key] = cp.boolvar(name=f"{key[0]}_{key[1]}")
            model += satisfied[key] == condition

    num_violated = sum(1 - holds for holds in satisfied.values() if not isinstance(holds, bool))
    weight: int = horizon * len(actions) + 1  # one violation costs more than any delay
    model.minimize(weight * num_violated + cp.sum(starts))
    return model, starts, satisfied


def explain_violation(kind: str, subject: str, actions: list[Action], problem: dict) -> str:
    """Explain why a mission constraint does not hold in a schedule.

    Args:
        kind: "ordering", "deadline" or "completion".
        subject: Id of the task that violates the constraint, or "mission" for the deadline.
        actions: Actions of the plan, with the times of the checked schedule.
        problem: Planning problem (parsed JSON).

    Returns:
        Explanation of the violation.
    """
    mission: dict = problem.get("constraints", {})
    if kind == "completion":
        return f"{subject} must be completed but is not in the plan"
    if kind == "deadline":
        late: list[Action] = [a for a in actions if a.end > int(mission["max_duration"])]
        makespan: int = max(a.end for a in actions)
        return (f"the plan ends at {makespan}, after the maximum duration {mission['max_duration']} "
                f"({len(late)} actions end late)")

    completion: dict[str, object] = get_completion_times(actions, [a.end for a in actions])
    first_attempt: Action = next(a for a in actions if a.task_id == subject and not a.is_retry)
    graph_node: dict = problem["task_graph"][subject]
    unmet: list[str] = []
    for dep in graph_node.get("depends_on", []):
        if is_after(first_attempt.start, dep, problem, completion) is not True:
            in_plan: bool = dep in completion
            is_missing_task: bool = dep in get_concrete_tasks(problem) and not in_plan
            reason: str = "not in the plan" if is_missing_task else (
                f"complete at {completion[dep]}" if in_plan else "not complete")
            unmet.append(f"{dep} ({reason})")
    joiner: str = " or " if graph_node.get("dependency_type", "AND") == "OR" else " and "
    return f"{subject} starts at {first_attempt.start}, but must start after {joiner.join(unmet)}"


def check_plan(actions: list[Action], problem: dict, keep_times: bool = False) -> CheckResult:
    """Check the mission constraints of a plan with CPMpy.

    Args:
        actions: Actions of the plan (including retries, if any).
        problem: Planning problem (parsed JSON).
        keep_times: If True, the plan is checked exactly with the times it has. If False
            (default), actions are re-timed: each agent keeps the order of its actions,
            and the solver delays actions to violate as few mission constraints as possible.

    Returns:
        The checked schedule and its violations.

    Raises:
        RuntimeError: If the solver finds no schedule (the hard constraints cannot be met).
    """
    model, starts, satisfied = build_model(actions, problem, keep_times)
    if not model.solve():
        raise RuntimeError("No schedule found for the plan: " + str(model.status()))

    scheduled: list[Action] = [replace(action, start=int(start.value()), end=int(start.value()) + action.duration)
                               for action, start in zip(actions, starts)]
    violations: list[Violation] = [
        Violation(kind, subject, explain_violation(kind, subject, scheduled, problem))
        for (kind, subject), holds in satisfied.items()
        if not (holds if isinstance(holds, bool) else bool(holds.value()))
    ]
    mission: dict = problem.get("constraints", {})
    return CheckResult(
        actions=scheduled,
        violations=violations,
        num_constraints=len(satisfied),
        makespan=max((a.end for a in scheduled), default=0),
        max_duration=int(mission["max_duration"]) if "max_duration" in mission else None,
    )


# ---------------------------------------------------------------------------
# Violations summary
# ---------------------------------------------------------------------------

def format_result(title: str, result: CheckResult) -> str:
    """Format the violations of one checked plan as text.

    Args:
        title: Name of the plan (e.g. "Original plan").
        result: Result of check_plan.

    Returns:
        Multi-line text with the makespan, the number of violations and each violation.
    """
    deadline: str = f" (maximum duration {result.max_duration})" if result.max_duration is not None else ""
    lines: list[str] = [
        f"{title}: ends at {result.makespan}{deadline}",
        f"  {len(result.violations)} of {result.num_constraints} mission constraints violated",
    ]
    lines += [f"  - [{v.kind}] {v.message}" for v in result.violations]
    return "\n".join(lines)


def format_violations_summary(original: CheckResult, with_retries: CheckResult) -> str:
    """Format the violations of the original plan and of the plan with retries as text.

    Args:
        original: Result of check_plan for the original plan.
        with_retries: Result of check_plan for the plan with retries.

    Returns:
        Multi-line text with both results, and the violations caused by the retries.
    """
    before: set[tuple[str, str]] = {(v.kind, v.subject) for v in original.violations}
    new: list[Violation] = [v for v in with_retries.violations if (v.kind, v.subject) not in before]
    lines: list[str] = [
        format_result("Original plan", original),
        "",
        format_result("Plan with retries", with_retries),
        "",
        f"Violations caused by the retries: {len(new)}",
    ]
    lines += [f"  - [{v.kind}] {v.message}" for v in new]
    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Saving the rescheduled plan
# ---------------------------------------------------------------------------

def format_action(action: Action) -> str:
    """Format one action as a line of a plan.txt file.

    Args:
        action: Action to format.

    Returns:
        "move(agent, from, to) [start, end]" or "dotask(agent, task, from, to) [start, end]".
    """
    params: list[str] = [action.agent] + ([action.task_id] if action.is_task else []) + [action.from_loc, action.to_loc]
    return f"{action.name}({', '.join(params)}) [{action.start:02d}, {action.end:02d}]"


def format_plan(actions: list[Action]) -> str:
    """Format a plan in the same text format as the plan.txt file of the task planner.

    A retry is written as a repeated "dotask" line of the same task, right after it.

    Args:
        actions: Actions of the plan, with their start and end times.

    Returns:
        Text of the plan, starting with "SequentialPlan:" and one action per line.
    """
    return "SequentialPlan:\n" + "".join(f"    {format_action(action)}\n" for action in actions)


def save_plan(actions: list[Action], file_path: str) -> str:
    """Save a plan in the same text format as the plan.txt file of the task planner.

    Args:
        actions: Actions of the plan, with their start and end times.
        file_path: Path of the file to write.

    Returns:
        The path of the written file.
    """
    with open(file_path, "w") as file:
        file.write(format_plan(actions))
    return file_path


# ---------------------------------------------------------------------------
# Gantt charts
# ---------------------------------------------------------------------------

def get_violating_tasks(result: CheckResult) -> set[str]:
    """Return the ids of the tasks that violate an ordering constraint.

    Args:
        result: Result of check_plan.

    Returns:
        Set of task ids.
    """
    return {v.subject for v in result.violations if v.kind == "ordering"}


def draw_action(ax: Axes, action: Action, row: int, violated: bool) -> None:
    """Draw one action as a bar of a Gantt chart.

    Tasks, retries and moves have their own colour; moves are drawn thinner. A task that
    violates an ordering constraint gets a red cross above it.

    Args:
        ax: Axes of the Gantt chart.
        action: Action to draw.
        row: Row (agent) of the action.
        violated: True if the action is the first attempt of a task that violates a constraint.

    Returns:
        None.
    """
    color: str = COLOR_MOVE if not action.is_task else (COLOR_RETRY if action.is_retry else COLOR_TASK)
    height: float = 0.5 if action.is_task else 0.22
    ax.barh(row, action.duration, left=action.start, height=height, color=color,
            edgecolor=COLOR_SURFACE, linewidth=1.0, zorder=2)
    if violated:
        ax.plot(action.start + action.duration / 2, row - 0.42, marker="x", color=COLOR_VIOLATION,
                markersize=6, markeredgewidth=1.8, zorder=4)


def draw_deadline(ax: Axes, max_duration: int, num_rows: int) -> None:
    """Draw the deadline of the mission as a labelled vertical line.

    Args:
        ax: Axes of the Gantt chart.
        max_duration: Maximum duration of the mission.
        num_rows: Number of rows (agents) of the chart.

    Returns:
        None.
    """
    ax.axvline(max_duration, color=COLOR_VIOLATION, linestyle="--", linewidth=1.2, zorder=1)
    ax.text(max_duration, num_rows - 0.45, f" max duration {max_duration}", color=COLOR_TEXT,
            fontsize=8, va="center", ha="left")


def style_gantt_axes(ax: Axes, agents: list[str], title: str) -> None:
    """Set the title, the agent rows and the recessive grid of a Gantt chart.

    Args:
        ax: Axes of the Gantt chart.
        agents: Agent ids, one row each (first agent at the top).
        title: Title of the chart.

    Returns:
        None.
    """
    ax.set_facecolor(COLOR_SURFACE)
    ax.set_title(title, loc="left", fontsize=11, color=COLOR_TEXT)
    ax.set_yticks(range(len(agents)), labels=agents, color=COLOR_TEXT)
    ax.set_ylim(len(agents) - 0.25, -0.75)
    ax.tick_params(axis="both", length=0, labelsize=9, labelcolor=COLOR_TEXT)
    ax.grid(axis="x", color=COLOR_MOVE, linewidth=0.5, alpha=0.6, zorder=0)
    ax.set_axisbelow(True)
    for side in ("top", "right", "left"):
        ax.spines[side].set_visible(False)
    ax.spines["bottom"].set_color(COLOR_TEXT_MUTED)


def draw_gantt(ax: Axes, result: CheckResult, title: str, agents: Optional[list[str]] = None) -> None:
    """Draw the Gantt chart of a checked plan: one row per agent.

    Args:
        ax: Axes where the chart is drawn.
        result: Result of check_plan.
        title: Title of the chart.
        agents: Agent ids, one row each. Defaults to the agents of the plan.

    Returns:
        None.
    """
    agents = agents or get_agents(result.actions)
    violating: set[str] = get_violating_tasks(result)
    for action in result.actions:
        violated: bool = action.is_task and not action.is_retry and action.task_id in violating
        draw_action(ax, action, agents.index(action.agent), violated)
    if result.max_duration is not None:
        draw_deadline(ax, result.max_duration, len(agents))
    style_gantt_axes(ax, agents, title)


def get_gantt_legend() -> list:
    """Return the legend entries of the Gantt charts.

    Returns:
        List of matplotlib legend handles.
    """
    return [
        Patch(facecolor=COLOR_TASK, edgecolor=COLOR_SURFACE, label="Task"),
        Patch(facecolor=COLOR_RETRY, edgecolor=COLOR_SURFACE, label="Retry"),
        Patch(facecolor=COLOR_MOVE, edgecolor=COLOR_SURFACE, label="Move"),
        Line2D([], [], marker="x", color=COLOR_VIOLATION, linestyle="none", markersize=6,
               markeredgewidth=1.8, label="Ordering constraint violated"),
        Line2D([], [], color=COLOR_VIOLATION, linestyle="--", linewidth=1.2, label="Maximum duration"),
    ]


def plot_gantt_comparison(original: CheckResult, with_retries: CheckResult) -> Figure:
    """Draw the Gantt chart of the original plan above the one of the plan with retries.

    Both charts share the time axis, so the delay caused by the retries is visible.

    Args:
        original: Result of check_plan for the original plan.
        with_retries: Result of check_plan for the plan with retries.

    Returns:
        The matplotlib figure (not shown; use save_figure or display it).
    """
    agents: list[str] = get_agents(original.actions)
    figure: Figure = Figure(figsize=(11, 1.6 + 1.1 * len(agents)), facecolor=COLOR_SURFACE, layout="constrained")
    top, bottom = figure.subplots(2, 1, sharex=True)
    draw_gantt(top, original, f"Original plan: {len(original.violations)} violations", agents)
    draw_gantt(bottom, with_retries, f"Plan with retries: {len(with_retries.violations)} violations", agents)
    bottom.set_xlabel("Time", color=COLOR_TEXT, fontsize=9)
    figure.legend(handles=get_gantt_legend(), loc="outside lower center", ncols=5, frameon=False, fontsize=9)
    return figure


def save_figure(figure: Figure, file_path: str) -> str:
    """Save a figure as an image file.

    Args:
        figure: Matplotlib figure.
        file_path: Path of the image file to write (e.g. ending in .png).

    Returns:
        The path of the written file.
    """
    figure.savefig(file_path, dpi=150, facecolor=figure.get_facecolor())
    return file_path
