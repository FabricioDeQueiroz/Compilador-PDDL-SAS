// main.cpp
#include <iostream>
#include <fstream>
#include <map>
#include <string>
#include <vector>

std::map<std::string, int> tokenCount; // Definindo a variável tokenCount

// Ordem dos tokens que você deseja
std::vector<std::string> tokenOrder = {
    "KEYWORD", "IDENTIFIER", "VARIABLES", "NUMBER", "ARITHMETIC_OPERATOR", 
    "LOGICAL_OPERATOR", "QUANTIFIER_OPERATOR", "CONDITIONAL_OPERATOR", 
    "MODIFIER_OPERATOR", "TEMPORAL_OPERATOR", "OPTIMIZATION_OPERATOR", 
    "DELIMITER", "COMMENTS", "UNKNOWN"
};

extern int yylex();
extern FILE *yyin;

// Função para processar o arquivo
void processarArquivo(const char *filename) {
    yyin = fopen(filename, "r");
    if (!yyin) {
        std::cerr << "Erro ao abrir o arquivo: " << filename << std::endl;
        exit(1);
    }
    while (yylex()) {} // Continua processando os tokens
    fclose(yyin);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        std::cerr << "Uso incorreto! Exemplo de uso: " << argv[0] 
                  << " <dominio.pddl> <problema.pddl>\n";
        return 1;
    }

    // Processa os arquivos passados
    processarArquivo(argv[1]);
    processarArquivo(argv[2]);

    std::cout.flush();
    for (const auto &token : tokenOrder) {
        int count = tokenCount[token]; 
        std::cout << token << ": " << count << "\n";
    }

    return 0;
}
