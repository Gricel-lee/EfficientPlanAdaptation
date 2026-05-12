(define (problem mrmh_planning_simple)
    (:domain mrmh_planning)
    (:objects
        worker1 robot - agent
        t1 t2 t3 - task)
    (:init
        (= (time) 0)
        (= (time_busy_agent worker1) 0)
        (= (time_busy_agent robot) 0)
        (agent_to_pick_action worker1)
        (agent_to_pick_action robot)
        ; worker1 handles type-1 tasks, robot handles type-2
        (= (p_success worker1 t1) 1.0)
        (= (p_success worker1 t2) 1.0)
        (= (p_success worker1 t3) 0.3)
        (= (p_success robot t1) 0.3)
        (= (p_success robot t2) 1.0)
        (= (p_success robot t3) 1.0)
        ; all tasks take 1 time unit for whichever agent does them
        (= (task_time t1 worker1) 10)
        (= (task_time t2 worker1) 1)
        (= (task_time t3 worker1) 1)
        (= (task_time t1 robot) 1)
        (= (task_time t2 robot) 1)
        (= (task_time t3 robot) 1))
    (:goal
        (and (task_done t1)
             (task_done t2)
             (task_done t3)
             (>= (time_busy_agent worker1) (time))
             (>= (time_busy_agent robot) (time))))
    (:metric minimize (time))
)
