%{
#include <iostream>
#include <fstream>
#include <map>
#include <string>
using namespace std;

map<string, int> tokenCount;

%}

%option noyywrap

IDENTIFIER      [a-zA-Z][a-zA-Z0-9_-]*
VARIABLE        \?{IDENTIFIER}
NUMBER          [0-9]+(\.[0-9]+)?
COMMENT         ;[^\n]*\n

%%

"define"|"domain"|"requirements"|"types"|"constants"|"predicates"|"functions"|"constraints"|"action"|"parameters"|"precondition"|"effect"|"durative-action"|"duration"|"condition"|"derived"|"problem"|"objects"|"init"|"goal"|"metric"|"total-time"|"length"|"serial"|"parallel"   { tokenCount["KEYWORD"]++; }
"assign"|"scale-up"|"scale-down"|"increase"|"decrease" { tokenCount["MODIFIER_OPERATOR"]++; }
"minimize"|"maximize"                                  { tokenCount["OPTIMIZATION_OPERATOR"]++; }
"and"|"or"|"not"|"imply"                               { tokenCount["LOGICAL_OPERATOR"]++; }
"forall"|"exists"                                      { tokenCount["QUANTIFIER_OPERATOR"]++; }
"when"                                                 { tokenCount["CONDITIONAL_OPERATOR"]++; }
"at"|"over"|"start"|"end"                              { tokenCount["TEMPORAL_OPERATOR"]++; }
"+"|"-"|"*"|"/"|"<"|">"|"="|"<="|">="                  { tokenCount["ARITHMETIC_OPERATOR"]++; }
"("|")"|":"                                            { tokenCount["DELIMITER"]++; }
{COMMENT}                                              { tokenCount["COMMENTS"]++; }
{NUMBER}                                               { tokenCount["NUMBER"]++; }
{VARIABLE}                                             { tokenCount["VARIABLES"]++; }
{IDENTIFIER}                                           { tokenCount["IDENTIFIER"]++; }
[[:space:]]+                                           ;
.                                                      { tokenCount["UNKNOWN"]++; }

%%

void printTokenCounts() {
    cout << "KEYWORD: " << tokenCount["KEYWORD"] << endl;
    cout << "IDENTIFIER: " << tokenCount["IDENTIFIER"] << endl;
    cout << "VARIABLES: " << tokenCount["VARIABLES"] << endl;
    cout << "NUMBER: " << tokenCount["NUMBER"] << endl;
    cout << "ARITHMETIC_OPERATOR: " << tokenCount["ARITHMETIC_OPERATOR"] << endl;
    cout << "LOGICAL_OPERATOR: " << tokenCount["LOGICAL_OPERATOR"] << endl;
    cout << "QUANTIFIER_OPERATOR: " << tokenCount["QUANTIFIER_OPERATOR"] << endl;
    cout << "CONDITIONAL_OPERATOR: " << tokenCount["CONDITIONAL_OPERATOR"] << endl;
    cout << "MODIFIER_OPERATOR: " << tokenCount["MODIFIER_OPERATOR"] << endl;
    cout << "TEMPORAL_OPERATOR: " << tokenCount["TEMPORAL_OPERATOR"] << endl;
    cout << "OPTIMIZATION_OPERATOR: " << tokenCount["OPTIMIZATION_OPERATOR"] << endl;
    cout << "DELIMITER: " << tokenCount["DELIMITER"] << endl;
    cout << "COMMENTS: " << tokenCount["COMMENTS"] << endl;
    cout << "UNKNOWN: " << tokenCount["UNKNOWN"] << endl;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        cerr << "Uso: " << argv[0] << " [<arquivo1>...<arquivoN>]" << endl;
        return 1;
    }

    for (int i = 1; i < argc; ++i) {
        ifstream file(argv[i]);
        if (!file) {
            cerr << "Erro ao abrir arquivo: " << argv[i] << endl;
            continue;
        }
        
        yyin = fopen(argv[i], "r");
        if (!yyin) {
            cerr << "Erro ao abrir arquivo para leitura: " << argv[i] << endl;
            continue;
        }
        
        yylex();
        fclose(yyin);
    }

    printTokenCounts();
    
    return 0;
}