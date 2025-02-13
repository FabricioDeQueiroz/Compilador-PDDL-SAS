(define (domain fliaswitch)
	(:requirements :strips)
	(:predicates (switch-is-on) (switch-is-off))
	(:action switch-on
		:precondition (switch-is-off)
		:effect (and (switch-is-on) (not (switch-is-off))
	(:action switch-off
		:precondition (switch-is-on)
		:effect (and (switch-is-off) (not (switch-is-on)))
		:invalid-instruction (and))))