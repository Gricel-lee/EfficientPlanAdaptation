(define (domain mrmh_planning)
    (:requirements :strips :typing :negative-preconditions :numeric-fluents :conditional-effects)
    (:types location task agent)
    (:predicates
        (agent_at ?r - agent ?l - location)
        (path ?l_from - location ?l_to - location)
        (empty ?l - location)
        (task_loci ?t - task ?l - location)
        (task_locf ?t - task ?l - location)
        (task_done ?t - task)
        (task_assigned ?t - task)
        (agent_has_turn ?a - agent)
        (next_turn ?a ?b - agent)
        (last_agent ?a - agent))
    (:functions
        (p_success ?a - agent ?t - task)
        (time)
        (X)
        (counter ?a - agent)
        (turn)
        (total_time))
    (:action move
        :parameters (?r - agent ?l_from - location ?l_to - location)
        :precondition
            (and (path ?l_from ?l_to) (agent_at ?r ?l_from) (empty ?l_to)
                 (agent_has_turn ?r))
        :effect
            (and (not (agent_at ?r ?l_from)) (agent_at ?r ?l_to) (empty ?l_from) (not (empty ?l_to))
                 (increase (time) (X)) (increase (counter ?r) 1)
                 (not (agent_has_turn ?r))
                 (forall (?b - agent) (when (next_turn ?r ?b) (agent_has_turn ?b)))
                 (when (last_agent ?r)
                     (and (assign (turn) 1) (increase (total_time) 1)))
                 (when (not (last_agent ?r)) (increase (turn) 1))))
    (:action dotask
        :parameters (?a - agent ?t - task ?li - location ?lf - location)
        :precondition
            (and (agent_at ?a ?li) (task_loci ?t ?li) (task_locf ?t ?lf) (not (task_done ?t))
                 (<= 0.5 (p_success ?a ?t))
                 (agent_has_turn ?a))
        :effect
            (and (task_done ?t) (increase (time) 1) (increase (counter ?a) 1)
                 (not (agent_has_turn ?a))
                 (forall (?b - agent) (when (next_turn ?a ?b) (agent_has_turn ?b)))
                 (when (last_agent ?a)
                     (and (assign (turn) 1) (increase (total_time) 1)))
                 (when (not (last_agent ?a)) (increase (turn) 1))))
    (:action idle
        :parameters (?a - agent)
        :precondition
            (agent_has_turn ?a)
        :effect
            (and (increase (counter ?a) 1)
                 (not (agent_has_turn ?a))
                 (forall (?b - agent) (when (next_turn ?a ?b) (agent_has_turn ?b)))
                 (when (last_agent ?a)
                     (and (assign (turn) 1) (increase (total_time) 1)))
                 (when (not (last_agent ?a)) (increase (turn) 1))))
    )
