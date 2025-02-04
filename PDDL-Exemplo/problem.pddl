(define (problem conta10)
    (:domain contador)
    (:objects
        n0 n1 n2 n3 n4 n5 n6 n7 n8 n9
    )
    (:init
        (contador-em n0)
        (inc n0 n1)
        (inc n1 n2)
        (inc n2 n3)
        (inc n3 n4)
        (inc n4 n5)
        (inc n5 n6)
        (inc n6 n7)
        (inc n7 n8)
        (inc n8 n9)
    )
    ; comentário no problema
    (:goal
        (and
            (contador-em n9)
        )
    )
)