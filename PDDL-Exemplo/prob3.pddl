(define (problem exemplo-numeros-problema)
  (:domain exemplo-numeros)

  (:objects
    obj1 obj2 obj3 - objeto)

  (:init
    (disponivel obj1)
    (disponivel obj2)
    (disponivel obj3)
    
    (= (custo obj1) 10.0)   ; Número flutuante
    (= (custo obj2) 5.5)    ; Número flutuante
    (= (custo obj3) 2)      ; Número inteiro

    (= (peso obj1) 8)       ; Número inteiro
    (= (peso obj2) 4.3)     ; Número flutuante
    (= (peso obj3) 6))      ; Número inteiro

  (:goal 
    (and 
      (usado obj1)
      (usado obj2))))