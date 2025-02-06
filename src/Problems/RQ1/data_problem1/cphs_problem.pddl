(define (problem mrmh_planning)
    (:domain mrmh_planning)
    (:objects l1  l2  l3  l4  l5  l6  - location
     worker1  r1  - agent
     t3l3  t3l5  - task)
    (:init
        (= (travel_dist) 0)
        (path l1 l2) (path l2 l1)
        (path l1 l3) (path l3 l1)
        (path l2 l4) (path l4 l2)
        (path l3 l4) (path l4 l3)
        (path l3 l5) (path l5 l3)
        (path l4 l6) (path l6 l4)
        (path l5 l6) (path l6 l5)
  (empty l1) (empty l2) (empty l3) (empty l4) (empty l5) (empty l6)   (task_loc t3l3 l3)
  (task_loc t3l5 l6)
        (agent_at worker1  l1 ) (agent_at r1  l1 )
  (= (p_success worker1 t3l3) 0.99)
  (= (p_success worker1 t3l5) 0.99)
  (= (p_success r1 t3l3) 0.97)
  (= (p_success r1 t3l5) 0.97)
 
    )
    (:goal (and 
      (task_done t3l3)
  (task_done t3l5)
))
    (:metric minimize (travel_dist))
)