(define (problem delivery-problem)
  (:domain delivery)
  (:objects
    robot1 - robot
    loc1 loc2 loc3 - location
    pkg1 pkg2 - package
  )
  (:init
    (at robot1 loc1)
    (clear loc1)
    (clear loc2)
    (clear loc3)
    (package-at pkg1 loc1)
    (package-at pkg2 loc2)
  )
  (:goal (and
    (delivered pkg1)
    (delivered pkg2)
  ))
)