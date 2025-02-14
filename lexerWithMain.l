%{
#include <stdlib.h>
#include "sintax.tab.hpp"
%}

%option noyywrap yylineno

IDENTIFIER      [a-zA-Z][a-zA-Z0-9_-]*
VARIABLE        \?{IDENTIFIER}
NUMBER          [0-9]+(\.[0-9]+)?
COMMENT         ;[^\n]*\n

%%

"define"                                               { printf("%s ", yytext); return DEFINE; }
"domain"                                               { printf("%s ", yytext); return DOMAIN; }
"requirements"                                         { printf("%s ", yytext); return REQUIREMENTS; }
"types"                                                { printf("%s ", yytext); return TYPES; }
"constants"                                            { printf("%s ", yytext); return CONSTANTS; }
"predicates"                                           { printf("%s ", yytext); return PREDICATES; }
"functions"                                            { printf("%s ", yytext); return FUNCTIONS; }
"constraints"                                          { printf("%s ", yytext); return CONSTRAINTS; }
"action"                                               { printf("%s ", yytext); return ACTION; }
"parameters"                                           { printf("%s ", yytext); return PARAMETERS; }
"precondition"                                         { printf("%s ", yytext); return PRECONDITION; }
"effect"                                               { printf("%s ", yytext); return EFFECT; }
"durative-action"                                      { printf("%s ", yytext); return DURATIVE_ACTION; }
"duration"                                             { printf("%s ", yytext); return DURATION; }
"condition"                                            { printf("%s ", yytext); return CONDITION; }
"derived"                                              { printf("%s ", yytext); return DERIVED; }
"problem"                                              { printf("%s ", yytext); return PROBLEM; }
"objects"                                              { printf("%s ", yytext); return OBJECTS; }
"init"                                                 { printf("%s ", yytext); return INIT; }
"goal"                                                 { printf("%s ", yytext); return GOAL; }
"metric"                                               { printf("%s ", yytext); return METRIC; }
"total-time"                                           { printf("%s ", yytext); return TOTAL_TIME; }
"length"                                               { printf("%s ", yytext); return LENGTH; }
"serial"                                               { printf("%s ", yytext); return SERIAL; }
"parallel"                                             { printf("%s ", yytext); return PARALLEL; }
"assign"                                               { printf("%s ", yytext); return ASSIGN; }
"scale-up"                                             { printf("%s ", yytext); return SCALE_UP; }
"scale-down"                                           { printf("%s ", yytext); return SCALE_DOWN; }
"increase"                                             { printf("%s ", yytext); return INCREASE; }
"decrease"                                             { printf("%s ", yytext); return DECREASE; }
"minimize"                                             { printf("%s ", yytext); return MINIMIZE; }
"maximize"                                             { printf("%s ", yytext); return MAXIMIZE; }
"and"                                                  { printf("%s ", yytext); return AND; }
"or"                                                   { printf("%s ", yytext); return OR; }
"not"                                                  { printf("%s ", yytext); return NOT; }
"imply"                                                { printf("%s ", yytext); return IMPLY; }                          
"forall"                                               { printf("%s ", yytext); return FORALL; }
"exists"                                               { printf("%s ", yytext); return EXISTS; }
"when"                                                 { printf("%s ", yytext); return WHEN; }
"at"                                                   { printf("%s ", yytext); return AT; }
"over"                                                 { printf("%s ", yytext); return OVER; }
"start"                                                { printf("%s ", yytext); return START; }
"end"                                                  { printf("%s ", yytext); return END; }
"+"                                                    { printf("%s ", yytext); return '+'; }
"-"                                                    { printf("%s ", yytext); return '-'; }
"*"                                                    { printf("%s ", yytext); return '*'; }
"/"                                                    { printf("%s ", yytext); return '/'; }
"<"                                                    { printf("%s ", yytext); return LT; }
">"                                                    { printf("%s ", yytext); return GT; }
"="                                                    { printf("%s ", yytext); return EQ; }
"<="                                                   { printf("%s ", yytext); return LEQ; }
">="                                                   { printf("%s ", yytext); return GEQ; }
"("                                                    { printf("%s ", yytext); return '('; }
")"                                                    { printf("%s ", yytext); return ')'; }
":"                                                    { printf("%s ", yytext); return ':'; }
{COMMENT}                                              { }
{NUMBER}                                               { yylval.number = atof(yytext); printf("%s ", yytext); return NUMBER; }
{VARIABLE}                                             { yylval.str = strdup(yytext); printf("%s ", yytext); return VARIABLE; }
{IDENTIFIER}                                           { yylval.str = strdup(yytext); printf("%s ", yytext); return IDENTIFIER; }
[[:space:]]+                                           ;
.                                                      { }

%%