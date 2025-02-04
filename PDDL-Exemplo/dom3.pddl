(define (domain exemplo-numeros)
  (:requirements :fluents :numeric-fluents)  ; Permite números e operações numéricas

  (:types objeto)

  (:predicates 
    (disponivel ?o - objeto) 
    (usado ?o - objeto))

  (:functions
    (custo ?o - objeto)  ; Função numérica para armazenar custo
    (peso ?o - objeto))  ; Função numérica para armazenar peso

  (:action usar-objeto
    :parameters (?o - objeto)
    :precondition (disponivel ?o)
    :effect 
      (and
        (not (disponivel ?o))
        (usado ?o)
        (increase (custo ?o) 1.5)   ; Aumenta o custo em um número flutuante
        (decrease (peso ?o) 2)))    ; Diminui o peso em um número inteiro
)