#include <iostream>
#include <map>
#include <string>
#include <vector>

std::map<std::string, int> tokenCount;

std::vector<std::string> tokenOrder = {
    "KEYWORD", "IDENTIFIER", "VARIABLES", "NUMBER", "ARITHMETIC_OPERATOR", 
    "LOGICAL_OPERATOR", "QUANTIFIER_OPERATOR", "CONDITIONAL_OPERATOR", 
    "MODIFIER_OPERATOR", "TEMPORAL_OPERATOR", "OPTIMIZATION_OPERATOR", 
    "DELIMITER", "COMMENTS", "UNKNOWN"
};

extern int yylex();
extern FILE *yyin;

void processarArquivo(const char *filename) {
    yyin = fopen(filename, "r");
    if (!yyin) {
        std::cerr << "Erro ao abrir o arquivo: " << filename << std::endl;
        exit(1);
    }
    while (yylex()) {}
    fclose(yyin);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        std::cerr << "Uso incorreto! Exemplo de uso: " << argv[0] 
                  << " <dominio.pddl> <problema.pddl>\n";
        return 1;
    }

    processarArquivo(argv[1]);
    processarArquivo(argv[2]);

    std::cout.flush();
    for (const auto &token : tokenOrder) {
        int count = tokenCount[token]; 
        std::cout << token << ": " << count << "\n";
    }

    return 0;
}