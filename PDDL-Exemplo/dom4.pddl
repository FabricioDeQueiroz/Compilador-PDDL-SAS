(define (domain delivery)
  (:requirements :strips :typing)
  (:types
    robot location package - object
  )
  ;; teste tal tal tal
  (:predicates
    (at ?r - robot ?l - location)
    (holding ?r - robot ?p - package)
    (delivered ?p - package)
    (clear ?l - location)
    (package-at ?p - package ?l - location)
  )
  ; testando
  ; testando 2
  (:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from) (clear ?to))
    :effect (and (not (at ?r ?from)) (at ?r ?to) (not (clear ?to)) (clear ?from))
  )

  (:action pick-up
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and (at ?r ?l) (package-at ?p ?l) (clear ?l))
    :effect (and (holding ?r ?p) (not (package-at ?p ?l)) (not (clear ?l)))
  )

  (:action deliver
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and (at ?r ?l) (holding ?r ?p))
    :effect (and (delivered ?p) (not (holding ?r ?p)))
  )
)