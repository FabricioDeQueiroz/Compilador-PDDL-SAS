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
#all: $(TARGET)
#
#$(TARGET): $(LEX_OUTPUT) $(SOURCE)
#	$(CXX) -o $(TARGET) $(SOURCE) $(LFLAGS)
#
## Geração do arquivo lexer.l.cpp
#$(LEX_OUTPUT): $(LEX_FILE)
#	$(LEX) -o $(LEX_OUTPUT) $(LEX_FILE)

# Limpeza de arquivos temporários
clean:
	rm -f $(TARGET) $(LEX_OUTPUT) lexerWithMain.l.cpp

test1:
	./pddl_lexical PDDL-Exemplo/dom.pddl PDDL-Exemplo/prob.pddl

test2:
	./pddl_lexical PDDL-Exemplo/dom2.pddl PDDL-Exemplo/prob2.pddl

test3:
	./pddl_lexical PDDL-Exemplo/dom3.pddl PDDL-Exemplo/prob3.pddl

unido:
	g++ -o pddl_lexical mainLexer.cpp -lfl

flex:
	flex -o lexer.l.cpp lexer.l

# Adicionando dependências
.PHONY: all clean
