(define (domain mrmh_planning)
    (:requirements :strips :typing :negative-preconditions :numeric-fluents)
    (:types location task agent)
    (:predicates 
    (agent_at ?r - agent ?l - location) 
    (path ?l_from - location ?l_to - location) 
    (empty ?l - location) 
    (task_loc ?t - task ?l - location) 
    (task_done ?t - task))
    (:functions (p_success ?a - agent ?t - task) (travel_dist)) 
    (:action move
        :parameters ( ?r - agent ?l_from - location ?l_to - location)
        :precondition 
            (and (path ?l_from ?l_to) (agent_at ?r ?l_from) (empty ?l_to) )
        :effect 
            (and (not (agent_at ?r ?l_from)) (agent_at ?r ?l_to) (empty ?l_from) (not (empty ?l_to)) 
            (increase (travel_dist) 1)))
    (:action dotask
        :parameters ( ?a - agent ?t - task ?l - location)
        :precondition 
            (and (agent_at ?a ?l) (task_loc ?t ?l) (not (task_done ?t)) 
            (<= 0.5 (p_success ?a ?t)) )
        :effect 
            (and (task_done ?t)))
    )
    