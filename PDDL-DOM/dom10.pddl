(define (domain lights)
  (:requirements :totola)
  (:predicates (light-on) )

  (:action turn-on
    :parameters ()
    :precondition (not (light-on))
    :effect (light-on)
  )

  (:action turn-off
    :parameters ()
    :precondition (light-on)
    :effect (not (light-on))
  )
)