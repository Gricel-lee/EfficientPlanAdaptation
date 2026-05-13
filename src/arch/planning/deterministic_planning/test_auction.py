# test_auction.py
# Auction-based task allocation for agricultural multi-agent pick-and-deliver.
#
# Scenario (from diagram):
#   Locations : l1/l2 (row 1), l3/l4 (row 2), l5 (collection point),
#               l6 (handover point / drone base), l8 (final destination)
#   Agents    : human, tractor, drone
#   Goal      : pick grapes from both rows and deliver to l8
#
# Usage: python3 src/arch/planning/deterministic_planning/test_auction.py

from __future__ import annotations
from dataclasses import dataclass, field
from typing import Optional
import math


# ── Location ──────────────────────────────────────────────────────────────────
@dataclass
class Location:
    name: str
    x: float
    y: float

    def distance_to(self, other: Location) -> float:
        return math.sqrt((self.x - other.x) ** 2 + (self.y - other.y) ** 2)

    def travel_time_to(self, other: Location, speed: float = 1.0) -> float:
        if self is other or self.name == other.name:
            return 0.0
        return self.distance_to(other) / speed

    def __repr__(self) -> str:
        return self.name


# ── Task ─────────────────────────────────────────────────────────────────────
@dataclass
class Task:
    id: str
    description: str
    loc_start: Location      # agent must arrive here to begin
    loc_end: Location        # agent is here after completion
    capability: str          # required agent capability
    work_time: float         # hours doing the actual work
    depends_on: list[str] = field(default_factory=list)
    deadline: Optional[float] = None  # hard latest-finish (hours)
    # filled in after auction
    assigned_to: Optional[str] = None
    start_time: float = 0.0
    end_time: float = 0.0
    done: bool = False


# ── Agent ─────────────────────────────────────────────────────────────────────
@dataclass
class Agent:
    name: str
    capabilities: list[str]
    start_location: Location
    speed: float                             # locations / hour
    fatigue_rate: float = 0.0               # fatigue gained per hour of work
    fatigue_threshold: float = float('inf') # incapacitated above this
    # runtime state (set in __post_init__)
    current_location: Location = field(init=False)
    fatigue: float = field(init=False, default=0.0)
    current_time: float = field(init=False, default=0.0)
    schedule: list[Task] = field(init=False, default_factory=list)

    def __post_init__(self):
        self.current_location = self.start_location

    def effective_speed(self) -> float:
        """Speed degrades linearly with fatigue past 50% of threshold."""
        half = self.fatigue_threshold / 2.0
        if self.fatigue > half and self.fatigue_threshold < float('inf'):
            penalty = min((self.fatigue - half) / half, 1.0)
            return max(self.speed * (1.0 - 0.5 * penalty), self.speed * 0.3)
        return self.speed

    def bid(self, task: Task, ready_time: float) -> Optional[float]:
        """Return bid cost or None if agent cannot take this task."""
        if task.capability not in self.capabilities:
            return None
        if self.fatigue >= self.fatigue_threshold:
            return None  # incapacitated

        earliest_start = max(self.current_time, ready_time)
        travel = self.current_location.travel_time_to(task.loc_start,
                                                      self.effective_speed())
        finish = earliest_start + travel + task.work_time

        if task.deadline and finish > task.deadline:
            return None  # cannot meet deadline

        surcharge = self.fatigue * 1.5  # tired agents bid higher
        return finish + surcharge

    def execute(self, task: Task, ready_time: float):
        """Accept a won task and update internal state."""
        earliest_start = max(self.current_time, ready_time)
        travel = self.current_location.travel_time_to(task.loc_start,
                                                      self.effective_speed())
        task.start_time  = earliest_start + travel
        task.end_time    = task.start_time + task.work_time
        task.assigned_to = self.name
        task.done        = True

        self.current_time     = task.end_time
        self.current_location = task.loc_end
        self.fatigue         += self.fatigue_rate * task.work_time
        self.schedule.append(task)

        if self.fatigue_threshold < float('inf'):
            f_str = f"fatigue {self.fatigue:.2f}/{self.fatigue_threshold:.1f}"
        else:
            f_str = "no fatigue"

        print(f"  [WIN] {self.name:8s} | {task.description:<42s} "
              f"t={task.start_time:.1f}→{task.end_time:.1f}h  {f_str}")


# ── Auction engine ─────────────────────────────────────────────────────────────
def _ready_time(task: Task, done: dict[str, Task]) -> Optional[float]:
    """Earliest start time based on dependencies, or None if not all done."""
    t = 0.0
    for dep_id in task.depends_on:
        dep = done.get(dep_id)
        if dep is None or not dep.done:
            return None
        t = max(t, dep.end_time)
    return t


def _print_bids(task: Task, bids: list[tuple[float, Agent]]):
    print(f"\n  Task: {task.description}")
    for cost, agent in bids:
        print(f"    {agent.name:8s}  bid={cost:.2f}")


def run_auction(tasks: list[Task], agents: list[Agent]):
    done: dict[str, Task] = {}
    pending = list(tasks)

    print("=== Contract-Net Auction  (lowest bid wins) ===\n")

    for _ in range(len(tasks) ** 2):
        if not pending:
            break
        progress = False
        remaining = []
        for task in pending:
            rt = _ready_time(task, done)
            if rt is None:
                remaining.append(task)
                continue

            bids: list[tuple[float, Agent]] = [
                (b, agent)
                for agent in agents
                if (b := agent.bid(task, rt)) is not None
            ]

            if not bids:
                print(f"  [FAIL] No agent can handle: {task.description}")
                remaining.append(task)
                continue

            bids.sort(key=lambda x: x[0])
            _print_bids(task, bids)
            _, winner = bids[0]
            winner.execute(task, rt)
            done[task.id] = task
            progress = True

        pending = remaining
        if not progress:
            break

    if pending:
        print(f"\n  [WARN] Unresolved tasks: {[t.id for t in pending]}")


# ── Scenario ──────────────────────────────────────────────────────────────────
def build_scenario() -> tuple[list[Location], list[Task], list[Agent]]:
    """
    Pick-And-Deliver-Grapes scenario (human + drone + tractor).

    Define your locations, agents, and tasks here.
    Reuse this function as a template for other scenarios.
    """

    # -- Locations (x, y in abstract vineyard units) --------------------------
    l1 = Location('l1', 0.0, 0.0)   # row 1 start  (human default start)
    l2 = Location('l2', 0.0, 1.0)   # row 1 end
    l3 = Location('l3', 1.0, 0.0)   # row 2 start
    l4 = Location('l4', 1.0, 1.0)   # row 2 end
    l5 = Location('l5', 0.5, 2.0)   # collection point (tractor base)
    l6 = Location('l6', 0.5, 3.0)   # handover point   (drone base)
    l8 = Location('l8', 2.5, 2.0)   # final destination

    locations = [l1, l2, l3, l4, l5, l6, l8]

    # -- Agents ---------------------------------------------------------------
    human = Agent(
        name='human',
        capabilities=['pick', 'carry'],
        start_location=l1,
        speed=1.0,
        fatigue_rate=0.5,        # 0.5 fatigue units per hour of work
        fatigue_threshold=3.0,   # incapacitated above 3.0
    )
    tractor = Agent(
        name='tractor',
        capabilities=['transport'],
        start_location=l5,
        speed=1.8,
    )
    drone = Agent(
        name='drone',
        capabilities=['carry'],
        start_location=l6,
        speed=3.0,
    )

    agents = [human, tractor, drone]

    # -- Tasks ----------------------------------------------------------------
    tasks = [
        # Row 1
        Task('pick_r1',
             'Pick grapes Row 1',
             loc_start=l1, loc_end=l1,
             capability='pick', work_time=2.0),

        Task('carry_r1_handover',
             'Carry Row 1 → Handover',
             loc_start=l1, loc_end=l6,
             capability='carry', work_time=0.5,
             depends_on=['pick_r1']),

        Task('drone_carry_r1',
             'Drone: Row 1 Handover → Collection',
             loc_start=l6, loc_end=l5,
             capability='carry', work_time=0.3,
             depends_on=['carry_r1_handover']),

        # Row 2
        Task('pick_r2',
             'Pick grapes Row 2',
             loc_start=l3, loc_end=l3,
             capability='pick', work_time=2.0),

        Task('carry_r2_handover',
             'Carry Row 2 → Handover',
             loc_start=l3, loc_end=l6,
             capability='carry', work_time=0.5,
             depends_on=['pick_r2']),

        Task('drone_carry_r2',
             'Drone: Row 2 Handover → Collection',
             loc_start=l6, loc_end=l5,
             capability='carry', work_time=0.3,
             depends_on=['carry_r2_handover']),

        # Final delivery
        Task('final_delivery',
             'Tractor: Collection → Final destination',
             loc_start=l5, loc_end=l8,
             capability='transport', work_time=1.0,
             depends_on=['drone_carry_r1', 'drone_carry_r2'],
             deadline=12.0),
    ]

    return locations, tasks, agents


# ── Summary ───────────────────────────────────────────────────────────────────
def print_summary(agents: list[Agent], tasks: list[Task]):
    print("\n=== Final Schedule ===\n")
    for agent in agents:
        if not agent.schedule:
            continue
        label = f"{agent.name.upper()}  (done at {agent.current_time:.1f}h"
        if agent.fatigue_threshold < float('inf'):
            pct = agent.fatigue / agent.fatigue_threshold * 100
            label += f", fatigue {agent.fatigue:.2f}/{agent.fatigue_threshold:.1f} = {pct:.0f}%"
        label += ")"
        print(label)
        for t in agent.schedule:
            print(f"  {t.start_time:4.1f}→{t.end_time:4.1f}h  {t.description}")
        print()

    done_tasks = [t for t in tasks if t.done]
    if done_tasks:
        print(f"Makespan: {max(t.end_time for t in done_tasks):.1f}h")


# ── Entry point ───────────────────────────────────────────────────────────────
def main():
    _, tasks, agents = build_scenario()
    run_auction(tasks, agents)
    print_summary(agents, tasks)


if __name__ == '__main__':
    main()
