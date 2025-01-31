(define (domain contador)
    (:requirements :strips)
    (:types
        contador
    ) ;; opcional
    ;; teste comentário
    (:predicates
        (inc ?f ?s)(contador-em ?p)
    )
    (:action SOMA
        :parameters (?x ?y)
        :precondition (and (inc ?x ?y) (contador-em ?x))
        :effect (and (not (contador-em ?x)) (contador-em ?y))
    )
)