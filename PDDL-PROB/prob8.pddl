(define (problem simple_problem)
  (:domain simple_types)
  
  (:objects 
    robot1 - robot
    loc1 loc2 - location
  )

  (:init
    (at robot1 loc1)
    (connected loc1 loc2)
  )

  (:goal
    (at robot1 loc2)
  )
)