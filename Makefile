# Definindo as variáveis
CXX = g++
LEX = flex
LEX_FILE = lexer.l
LEX_OUTPUT = lexer.l.cpp
TARGET = pddl_lexical
SOURCE = main.cpp lexer.l.cpp
LFLAGS = -lfl

# A regra principal que vai compilar o projeto
all: $(TARGET)

$(TARGET): $(LEX_OUTPUT) $(SOURCE)
	$(CXX) -o $(TARGET) $(SOURCE) $(LFLAGS)

# Geração do arquivo lexer.l.cpp
$(LEX_OUTPUT): $(LEX_FILE)
	$(LEX) -o $(LEX_OUTPUT) $(LEX_FILE)

# Limpeza de arquivos temporários
clean:
	rm -f $(TARGET) $(LEX_OUTPUT)

test1:
	./pddl_lexical PDDL-Exemplo/dom.pddl PDDL-Exemplo/prob.pddl

test2:
	./pddl_lexical PDDL-Exemplo/dom2.pddl PDDL-Exemplo/prob2.pddl

test3:
	./pddl_lexical PDDL-Exemplo/dom3.pddl PDDL-Exemplo/prob3.pddl

unido:
	g++ -o pddl_lexical mainLexer.cpp -lfl

# Adicionando dependências
.PHONY: all clean
