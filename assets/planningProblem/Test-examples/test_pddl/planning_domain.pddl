(define (domain mrmh_planning)
    (:requirements :strips :typing :negative-preconditions :numeric-fluents :equality)
    (:types task agent)
    (:predicates
        (task_done ?t - task)
        (agent_to_pick_action ?a - agent))

    (:functions
        (p_success ?a - agent ?t - task)
        (task_time ?t - task ?a - agent)
        (time)
        (time_busy_agent ?a - agent))

    ; ---- Actions that the agents can take ----
    (:action do_task
        :parameters (?a - agent ?t - task)
        :precondition
            (and (>= (p_success ?a ?t) 0.5)
                 (agent_to_pick_action ?a)
                 (>= (time_busy_agent ?a) (time)) ; agent workload >= current time = has capacity
                 (not (task_done ?t)))
        :effect
            (and (task_done ?t)
                 (assign (time_busy_agent ?a) (+ (time_busy_agent ?a) (task_time ?t ?a)))
                 (not (agent_to_pick_action ?a))))

    ; if agent workload < time = agent fell behind, consume turn without doing new work
    (:action remain_busy
        :parameters (?a - agent)
        :precondition (and
            (< (time_busy_agent ?a) (time))
            (agent_to_pick_action ?a))
        :effect (not (agent_to_pick_action ?a)))

    ; ------- Actions to manage agent turns and time -------
    ; NOTE: requires one parameter per agent declared in the problem
    (:action reset_all_agents_to_pick_action
        :parameters (?a1 - agent ?a2 - agent)
        :precondition (and
            (not (= ?a1 ?a2))
            (not (agent_to_pick_action ?a1))
            (not (agent_to_pick_action ?a2)))
        :effect
            (and
                (increase (time) 1)
                (agent_to_pick_action ?a1)
                (agent_to_pick_action ?a2)))
)
