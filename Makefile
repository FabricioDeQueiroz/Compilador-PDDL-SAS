# Definindo as variáveis
CXX = g++
LEX = flex
LEX_FILE = lexer.l
LEX_OUTPUT = lexer.l.cpp
TARGET = pddl_lexical
SOURCE = main.cpp lexer.l.cpp
LFLAGS = -lfl

# A regra principal que vai compilar o projeto
all:
	flex -o lexerWithMain.l.cpp lexerWithMain.l
	g++ -o pddl_lexical lexerWithMain.l.cpp -lfl

# Limpeza de arquivos temporários
clean:
	rm -f $(TARGET) $(LEX_OUTPUT) lexerWithMain.l.cpp

test1:
	./pddl_lexical PDDL-Exemplo/dom.pddl PDDL-Exemplo/prob.pddl

test2:
	./pddl_lexical PDDL-Exemplo/dom2.pddl PDDL-Exemplo/prob2.pddl

test3:
	./pddl_lexical PDDL-Exemplo/dom3.pddl PDDL-Exemplo/prob3.pddl

testpy:
	./pddl_lexical PDDL-Exemplo/teste.py

# Adicionando dependências
.PHONY: all clean
