import math

def bhaskara(a, b, c):
    """
    Calcula as raízes de uma equação do segundo grau utilizando a fórmula de Bhaskara.
  
    Args:
      a: Coeficiente do termo quadrático.
      b: Coeficiente do termo linear.
      c: Termo independente.
  
    Returns:
      Uma tupla contendo as duas raízes da equação, ou uma mensagem indicando que não existem raízes reais.
    """

    delta = b**2 - 4*a*c

    if delta < 0:
        return "A equação não possui raízes reais."
    else:
        x1 = (-b + math.sqrt(delta)) / (2*a)
        x2 = (-b - math.sqrt(delta)) / (2*a)
        return x1, x2

# Exemplo de uso
a = 1
b = -3
c = 2

resultado = bhaskara(a, b, c)

if isinstance(resultado, str):
    print(resultado)
else:
    x1, x2 = resultado
    print(f"As raízes da equação são: x1 = {x1}, x2 = {x2}")