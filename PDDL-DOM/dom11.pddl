(define (domain lights)
  (:requirements :strips :typing :negative-preconditions :equality :existential-preconditions :universal-preconditions :quantified-preconditions :conditiona-effects :fluents :numeric-fluents :adl :durative-actions :duration-inequalities :continuous-effects :derived-predicates :timed-inital-literals :preferences :constraints :action-costs)
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