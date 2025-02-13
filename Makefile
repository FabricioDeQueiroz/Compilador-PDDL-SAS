# Definindo as variáveis
CXX = g++
LEX = flex
LEX_FILE = lexer.l
LEX_OUTPUT = lexer.l.cpp
TARGET = pddl_sintax
SOURCE = main.cpp lexer.l.cpp
LFLAGS = -lfl

# A regra principal que vai compilar o projeto
all:
	bison -t -d -v sintax.y
	flex -o lexerWithMain.l.c lexerWithMain.l
	g++ -o pddl_sintax sintax.tab.c lexerWithMain.l.c -lfl
	clear

# Limpeza de arquivos
clean:
	rm -f $(TARGET) $(LEX_OUTPUT) lexerWithMain.l.cpp sintax.tab.cpp sintax.tab.hpp stack.hh sintax.output sintax.tab.c sintax.tab.h lexerWithMain.l.c
	clear
	
test1:
	./pddl_sintax PDDL-Exemplo/dom.pddl PDDL-Exemplo/prob.pddl

test2:
	./pddl_sintax PDDL-Exemplo/dom2.pddl PDDL-Exemplo/prob2.pddl

test3:
	./pddl_sintax PDDL-Exemplo/dom3.pddl PDDL-Exemplo/prob3.pddl

testpy:
	./pddl_sintax PDDL-Exemplo/teste.py

sintest1:
	./pddl_sintax PDDL-Exemplo/dom4.pddl PDDL-Exemplo/prob4.pddl

sintest2:
	./pddl_sintax PDDL-Exemplo/dom5.pddl PDDL-Exemplo/prob5.pddl

.PHONY: all clean