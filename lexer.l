%{
#include <map>
#include <string>

extern std::map<std::string, int> tokenCount;
extern int yylex();
%}

%option noyywrap

IDENTIFIER      [a-zA-Z_][a-zA-Z0-9_-]*[a-zA-Z0-9]?
VARIABLE        \?{IDENTIFIER}
NUMBER          [0-9]+(\.[0-9]+)?
COMMENT         ";"[^\n]*\n
WHITESPACE		[ \s\t\n]

%%

"define"|"domain"|"requirements"|"types"|"constants"|"predicates"|"functions"|"constraints"|"action"|"parameters"|"precondition"|"effect"|"durative-action"|"duration"|"condition"|"derived"|"problem"|"objects"|"init"|"goal"|"metric"|"total-time"|"lenght"|"serial"|"parallel"   { tokenCount["KEYWORD"]++; }
"and"|"or"|"not"|"imply"                               { tokenCount["LOGICAL_OPERATOR"]++; }
"forall"|"exists"                                      { tokenCount["QUANTIFIER_OPERATOR"]++; }
"when"                                                 { tokenCount["CONDITIONAL_OPERATOR"]++; }
"assign"|"scale-up"|"scale-down"|"increase"|"decrease" { tokenCount["MODIFIER_OPERATOR"]++; }
"at"|"over"|"start"|"end"                              { tokenCount["TEMPORAL_OPERATOR"]++; }
"minimize"|"maximize"                                  { tokenCount["OPTIMIZATION_OPERATOR"]++; }
"+"|"-"|"*"|"/"|"<"|">"|"="|"<="|">="                  { tokenCount["ARITHMETIC_OPERATOR"]++; }
"("|")"|":"                                            { tokenCount["DELIMITER"]++; }
{COMMENT}                                              { tokenCount["COMMENTS"]++; }
{VARIABLE}                                             { tokenCount["VARIABLES"]++; }
{IDENTIFIER}                                           { tokenCount["IDENTIFIER"]++; }
{NUMBER}                                               { tokenCount["NUMBER"]++; }
{WHITESPACE}                                           { /* Dá match com espaços em branco */ }
.                                                      { tokenCount["UNKNOWN"]++; }

%%