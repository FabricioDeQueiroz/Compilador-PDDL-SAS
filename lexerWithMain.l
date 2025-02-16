%{
#include <stdlib.h>
#include "sintax.tab.h"
%}

%option noyywrap yylineno

IDENTIFIER      [a-zA-Z][a-zA-Z0-9_-]*
VARIABLE        \?{IDENTIFIER}
NUMBER          [0-9]+(\.[0-9]+)?
COMMENT         ;[^\n]*

%%

"define"                                               { return DEFINE; }
"domain"                                               { return DOMAIN; }
"requirements"                                         { return REQUIREMENTS; }
"types"                                                { return TYPES; }
"constants"                                            { return CONSTANTS; }
"predicates"                                           { return PREDICATES; }
"functions"                                            { return FUNCTIONS; }
"action"                                               { return ACTION; }
"parameters"                                           { return PARAMETERS; }
"precondition"                                         { return PRECONDITION; }
"effect"                                               { return EFFECT; }
"durative-action"                                      { return DURATIVE_ACTION; }
"duration"                                             { return DURATION; }
"condition"                                            { return CONDITION; }
"derived"                                              { return DERIVED; }
"problem"                                              { return PROBLEM; }
"objects"                                              { return OBJECTS; }
"init"                                                 { return INIT; }
"goal"                                                 { return GOAL; }
"metric"                                               { return METRIC; }
"total-time"                                           { return TOTAL_TIME; }
"assign"                                               { return ASSIGN; }
"scale-up"                                             { return SCALE_UP; }
"scale-down"                                           { return SCALE_DOWN; }
"increase"                                             { return INCREASE; }
"decrease"                                             { return DECREASE; }
"minimize"                                             { return MINIMIZE; }
"maximize"                                             { return MAXIMIZE; }
"and"                                                  { return AND; }
"or"                                                   { return OR; }
"not"                                                  { return NOT; }
"imply"                                                { return IMPLY; }                          
"forall"                                               { return FORALL; }
"exists"                                               { return EXISTS; }
"when"                                                 { return WHEN; }
"at"                                                   { return AT; }
"over"                                                 { return OVER; }
"start"                                                { return START; }
"end"                                                  { return END; }
"either"                                               { return EITHER; }
"all"                                                  { return ALL; }
"strips"                                               { return STRIPS; }   
"typing"                                               { return TYPING; }
"negative-preconditions"                               { return NEGATIVE_PRECONDITIONS; }
"disjunctive-preconditions"                            { return DISJUNCTIVE_PRECONDITIONS; }
"equality"                                             { return EQUALITY; }
"existential-preconditions"                            { return EXISTENTIAL_PRECONDITIONS; }
"universal-preconditions"                              { return UNIVERSAL_PRECONDITIONS; }
"quantified-preconditions"                             { return QUANTIFIED_PRECONDITIONS; }
"conditional-effects"                                  { return CONDITIONAL_EFFECTS; }
"fluents"                                              { return FLUENTS; }
"object-fluents"                                       { return OBJECT_FLUENTS; }
"numeric-fluents"                                      { return NUMERIC_FLUENTS; }
"adl"                                                  { return ADL; }
"durative-actions"                                     { return DURATIVE_ACTIONS; }
"derived-predicates"                                   { return DERIVED_PREDICATES; }
"timed-initial-literals"                               { return TIMED_INITIAL_LITERALS; }
"duration-inequalities"                                { return DURATION_INEQUALITIES; }
"continuous-effects"                                   { return CONTINUOUS_EFFECTS; }
"preferences"                                          { return PREFERENCES; }
"constraints"                                          { return CONSTRAINTS; }
"action-costs"                                         { return ACTION_COSTS; }
"+"                                                    { return '+'; }
"-"                                                    { return '-'; }
"*"                                                    { return '*'; }
"/"                                                    { return '/'; }
"<"                                                    { return LT; }
">"                                                    { return GT; }
"="                                                    { return EQ; }
"<="                                                   { return LEQ; }
">="                                                   { return GEQ; }
"("                                                    { return '('; }
")"                                                    { return ')'; }
":"                                                    { return ':'; }
{COMMENT}                                              { }
{NUMBER}                                               { yylval.number = atof(yytext); return NUMBER; }
{VARIABLE}                                             { yylval.str = strdup(yytext); return VARIABLE; }
{IDENTIFIER}                                           { yylval.str = strdup(yytext); return IDENTIFIER; }
[[:space:]]+                                           ;
.                                                      { }

%%