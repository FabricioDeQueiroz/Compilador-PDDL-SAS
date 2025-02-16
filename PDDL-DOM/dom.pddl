(define (domain fliaswitch)
	(:requirements :strips)
	(:types vehicle car truck)  ;; Erro! :types requer :typing
	(:predicates (switch-is-on) (switch-is-off))
	(:action switch-on
		:parameters ()
		:precondition (and (>= (- (y ?b) 1) (min_y)))
		:effect (and (switch-is-on) (not (switch-is-off))))
	(:action switch-off
		:parameters ()
		:precondition (switch-is-on)
		:effect (and (switch-is-off) (not (switch-is-on)))))