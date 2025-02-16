%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;

extern int yylineno;

int yylex(void);
int yyparse(void);

void yyerror(const char *s);

extern char *yytext;  // TODO apagar: String do token atual no Flex

#define MAX_REQ_KEYS 50
#define MAX_KEY_LENGTH 50

char reqKeys[MAX_REQ_KEYS][MAX_KEY_LENGTH];
int reqCount = 0;
const char* current_filename;

void addReqKey(const char* key) {
    for (int i = 0; i < reqCount; i++) {
        if (strcmp(reqKeys[i], key) == 0) {
            return;
        }
    }

    if (reqCount < MAX_REQ_KEYS) {
        strncpy(reqKeys[reqCount], key, MAX_KEY_LENGTH - 1);
        reqKeys[reqCount][MAX_KEY_LENGTH - 1] = '\0';
        reqCount++;
    }
}

int hasReqKey(const char* key) {
    for (int i = 0; i < reqCount; i++) {
        if (strcmp(reqKeys[i], key) == 0) {
            return 1;
        }
    }
    return 0;
}

void checkRequirement(const char* key) {
    if (!hasReqKey(key)) {
        printf("Rejected: %s at line %d\n", current_filename, yylineno);
        exit(0);
    }
}
%}

%union {
    char* str;
    double number;
}

%token <str> IDENTIFIER
%token <str> VARIABLE
%token <number> NUMBER

%token DEFINE DOMAIN REQUIREMENTS TYPES CONSTANTS PREDICATES FUNCTIONS ACTION PARAMETERS PRECONDITION EFFECT DURATIVE_ACTION DURATION CONDITION DERIVED PROBLEM OBJECTS INIT GOAL METRIC TOTAL_TIME ASSIGN SCALE_UP SCALE_DOWN INCREASE DECREASE MINIMIZE MAXIMIZE AND OR NOT IMPLY FORALL EXISTS WHEN AT OVER START END LT GT EQ LEQ GEQ ALL EITHER

%token STRIPS TYPING NEGATIVE_PRECONDITIONS DISJUNCTIVE_PRECONDITIONS EQUALITY EXISTENTIAL_PRECONDITIONS UNIVERSAL_PRECONDITIONS QUANTIFIED_PRECONDITIONS CONDITIONAL_EFFECTS FLUENTS ADL DURATIVE_ACTIONS DERIVED_PREDICATES TIMED_INITIAL_LITERALS DURATION_INEQUALITIES CONTINUOUS_EFFECTS PREFERENCES CONSTRAINTS ACTION_COSTS NUMERIC_FLUENTS OBJECT_FLUENTS

%start argFile

%%

argFile:
        domain
    |   problem
    ;

domain:
        '(' DEFINE '(' DOMAIN IDENTIFIER ')' definitions ')'
    ;

definitions:
        definitions definition
    |   /* vazio */
    ;

definition:
        reqDef
    |   typeDef             //{ checkRequirement("typing"); }
    |   constDef
    |   predDef
    |   funcDef             //{ checkRequirement("fluents"); }
    |   structDef
    ;

reqDef: 
        '(' ':' REQUIREMENTS reqKey_List ')'
    ;

reqKey_List:
        reqKey_List reqKey
    |   reqKey
    ;

reqKey:
        ':' STRIPS { addReqKey("strips"); }
    |   ':' TYPING { addReqKey("typing"); }
    |   ':' NEGATIVE_PRECONDITIONS { addReqKey("negative-preconditions"); }
    |   ':' DISJUNCTIVE_PRECONDITIONS { addReqKey("disjunctive-preconditions"); }
    |   ':' EQUALITY { addReqKey("equality"); }
    |   quantifiedReqs
    |   ':' CONDITIONAL_EFFECTS { addReqKey("conditional-effects"); }
    |   ':' FLUENTS { addReqKey("fluents"); }
    |   ':' OBJECT_FLUENTS { addReqKey("object-fluents"); }
    |   ':' NUMERIC_FLUENTS { addReqKey("numeric-fluents"); }
    |   ':' ADL { addReqKey("adl"); }
    |   ':' DURATIVE_ACTIONS { addReqKey("durative-actions"); }
    |   ':' DERIVED_PREDICATES { addReqKey("derived-predicates"); }
    |   ':' TIMED_INITIAL_LITERALS { addReqKey("timed-initial-literals"); }
    |   ':' DURATION_INEQUALITIES { addReqKey("duration-inequalities"); }
    |   ':' CONTINUOUS_EFFECTS { addReqKey("continuous-effects"); }
    |   ':' PREFERENCES { addReqKey("preferences"); }
    |   ':' CONSTRAINTS { addReqKey("constraints"); }
    |   ':' ACTION_COSTS { addReqKey("action-costs"); }
    ;

quantifiedReqs:
        ':' QUANTIFIED_PRECONDITIONS
    |   existentialUniversalReqs
    ;

existentialUniversalReqs:
        ':' EXISTENTIAL_PRECONDITIONS
    |   ':' UNIVERSAL_PRECONDITIONS
    |   existentialUniversalReqs ':' EXISTENTIAL_PRECONDITIONS
    |   existentialUniversalReqs ':' UNIVERSAL_PRECONDITIONS
    ;

typeDef:
        '(' ':' TYPES typedListName ')'
    ;

typedListName:
        /* vazio */
    |   typedNameItems
    ;

typedNameItems:
        typedNameItems typedNameItem
    |   typedNameItem
    ;

typedNameItem:
        IDENTIFIER
    |   typedGroup
    ;

typedGroup:
        NameList '-' typeType               //{ checkRequirement("typing"); }// { if (!hasReqKey("typing")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

NameList:
        NameList IDENTIFIER
    |   IDENTIFIER
    ;
    
typeType:
        '(' EITHER primitiveTypeList ')'
    |   IDENTIFIER
    ;

primitiveTypeList:
        IDENTIFIER
    |   primitiveTypeList IDENTIFIER
    ;

constDef:
        '(' ':' CONSTANTS typedListName ')'
    ;

predDef:
        '(' ':' PREDICATES atomicFormulaSkeletonList ')'
    ;

atomicFormulaSkeletonList:
        atomicFormulaSkeleton
    |   atomicFormulaSkeletonList atomicFormulaSkeleton
    ;

predicate:
        IDENTIFIER
    |   AT
    ;

atomicFormulaSkeleton:
        '(' predicate typedListVar ')'
    ;

typedListVar:
        /* vazio */
    |   typedVarItems
    ;

typedVarItems:
        typedVarItems typedVarItem
    |   typedVarItem
    ;

typedVarItem:
        VARIABLE
    |   typedVarGroup
    ;

typedVarGroup:
        VarList '-' typeType            //{ checkRequirement("typing"); }// { if (!hasReqKey("typing")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

VarList:
        VarList VARIABLE
    |   VARIABLE
    ;

funcDef:
        '(' ':' FUNCTIONS functionTypedList ')'         //{ checkRequirement("fluents"); }// { if (!hasReqKey("fluents")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

functionTypedList:
        /* vazio */
    |   typedFunctionItems
    ;

typedFunctionItems:
        typedFunctionItems typedFunctionItem
    |   typedFunctionItem
    ;

typedFunctionItem:
        atomicFormulaSkeleton
    |   typedFunctionGroup
    ;

typedFunctionGroup:
        atomicFunctionList '-' identNumber               //{ checkRequirement("typing"); }// { if (!hasReqKey("typing")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

identNumber:
        IDENTIFIER
    |   NUMBER
    ;

atomicFunctionList:
        atomicFormulaSkeletonList atomicFormulaSkeleton
    |   atomicFormulaSkeleton
    ;

structDef:
        actionDef
    |   durativeActionDef           //{ checkRequirement("durative-actions"); }// { if (!hasReqKey("durative-actions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   derivedDef                  //{ checkRequirement("derived-predicates"); }// { if (!hasReqKey("derived-predicates")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

actionDef:
        '(' ':' ACTION IDENTIFIER ':' PARAMETERS '(' typedListVar ')' actionDefsBody ')'
    ;

actionDefsBody:
        actionDefsBody actionDefBody
    |   /* vazio */

actionDefBody:
        ':' PRECONDITION goalDef
    |   ':' EFFECT effect
    ;

goalDef:
        '(' ')'
    |   atomicFormulaTerm
    |   '(' AND goalDef_NList ')'   
    |   '(' OR goalDef_NList ')'                            //{ checkRequirement("disjunctive-preconditions"); }// { if (!hasReqKey("disjunctive-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' NOT goalDef ')'                                 //{ checkRequirement("disjunctive-preconditions"); }// { if (!hasReqKey("disjunctive-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' IMPLY goalDef goalDef ')'                       //{ checkRequirement("disjunctive-preconditions"); }// { if (!hasReqKey("disjunctive-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' EXISTS '(' typedListVar ')' goalDef ')'         //{ checkRequirement("existential-preconditions"); }// { if (!hasReqKey("existential-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' FORALL '(' typedListVar ')' goalDef ')'         //{ checkRequirement("universal-preconditions"); }// { if (!hasReqKey("universal-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   fComp                                               //{ checkRequirement("fluents"); }// { if (!hasReqKey("fluents")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

atomicFormulaTerm:
        '(' predicate term_NList ')'
    ;

term_NList:
        term_NList term
    |   /* vazio */
    ;

term:
        VARIABLE
    |   IDENTIFIER
    ;

goalDef_NList:
        goalDef_NList goalDef
    |   /* vazio */
    ;

fComp:
        '(' binaryComp fExp fExp ')'
    ;

binaryComp:
        GT
    |   LT
    |   EQ
    |   GEQ
    |   LEQ
    ;

fExp:
        NUMBER
    |   '(' binaryOp fExp fExp ')'
    |   fHead
    ;

binaryOp:
        '+'
    |   '-'
    |   '*'
    |   '/'
    ;

fHead:
        '(' IDENTIFIER term_NList ')'
    |   IDENTIFIER
    ;

effect:
        '(' ')'
    |   '(' AND cEffect_NList ')'
    |   cEffect
    ;

cEffect:
        '(' FORALL '(' typedListVar ')' effect ')'         //{ checkRequirement("conditional-effects"); }// { if (!hasReqKey("conditional-effects")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' WHEN goalDef CondEffect ')'                    //{ checkRequirement("conditional-effects"); }// { if (!hasReqKey("conditional-effects")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   pEffect
    ;

cEffect_NList:
        cEffect_NList cEffect
    |   /* vazio */
    ;

CondEffect:
        '(' AND pEffect_NList ')'
    |   pEffect
    ;   

pEffect:
        '(' NOT atomicFormulaTerm ')'
    |    atomicFormulaTerm
    |   '(' assignOp fHead fExp ')'                     //{ checkRequirement("fluents"); }// { if (!hasReqKey("fluents")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

pEffect_NList:
        pEffect_NList pEffect
    |   /* vazio */
    ;

assignOp:
        ASSIGN
    |   SCALE_UP
    |   SCALE_DOWN
    |   INCREASE
    |   DECREASE
    ;

durativeActionDef:
        '(' ':' DURATIVE_ACTION IDENTIFIER ':' PARAMETERS '(' typedListVar ')' daDefBody ')'
    ;

daDefBody:
        ':' DURATION '(' EQ '?' DURATION fExp ')' ':' CONDITION daGd                            /* TODO ver essa bomba: ':' effect daEffect */ 
    ;

daGd: 
        '(' ')'
    |   timedGd
    |   '(' AND timedGdList ')'
    ;

timedGdList:
        timedGdList timedGd
    |   timedGd
    ;

timedGd:
        '(' AT timeSpecifier goalDef ')'
    |   '(' OVER interval goalDef ')'
    ;

timeSpecifier:
        START
    |   END
    ;

interval:
        ALL
    ;

derivedDef:
        '(' ':' DERIVED typedListVar goalDef ')'
    ;

problem:
        '(' DEFINE '(' PROBLEM IDENTIFIER')'
        '(' ':' DOMAIN IDENTIFIER ')'
        definitionsProb
        init
        goal
        metricSpec_Opt ')'
    ;

definitionsProb:
        definitionsProb definitionProb
    |   /* vazio */
    ;

definitionProb:
        reqDefProb
    |   objctDeclaration
    ;

reqDefProb:
        '(' ':' REQUIREMENTS reqKey_List ')'
    ;
    
objctDeclaration: 
        '(' ':' OBJECTS typedListName ')'
    ;
     
init: 
        '(' ':' INIT initEl_NList ')'
    ;

initEl_NList:
        initEl_NList initEl
    |   /* vazio */
    ;

initEl:
        literalName
    |   '(' EQ fHead NUMBER ')'                //{ checkRequirement("fluents"); }// { if (!hasReqKey("fluents")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' AT identifierNumbers ')'           //{ checkRequirement("timed-initial-literals"); }// { if (!hasReqKey("timed-initial-literals")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

// TODO gambiarra: pq há exemplos errados no moj
identifierNumber:
        IDENTIFIER
    |   NUMBER
    ;

// TODO gambiarra: pq há exemplos errados no moj
identifierNumbers:
        identifierNumbers identifierNumber
    |   identifierNumber
    ;

literalName:
        atomicFormulaName
    |   '(' NOT atomicFormulaName ')'
    ;  

atomicFormulaName:
        '(' IDENTIFIER identifier_NList ')'
    ;

identifier_NList:
        /* vazio */
    |   identifier_NList IDENTIFIER
    ;

goal:
        '(' ':' GOAL goalDef ')'
    ;

metricSpec_Opt:
        metricSpec
    |   /* vazio */
    ;

metricSpec:
        '(' ':' METRIC optimization groundFExp ')'
    ;

optimization:
        MINIMIZE
    |   MAXIMIZE
    ;

groundFExp:
        '(' binaryOp groundFExp groundFExp ')'
    |   '(' '-' groundFExp ')'
    |   NUMBER
    |   '(' IDENTIFIER identifier_NList ')'
    |   TOTAL_TIME
    |   IDENTIFIER
    ;
   
%%

int main(int argc, char **argv) {
    /* #ifdef YYDEBUG
    extern int yydebug;
    yydebug = 1;
    #endif */

    if (argc < 3) {
        printf("Uso: %s <dominio.pddl> <problema.pddl>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Erro ao abrir arquivo: %s\n", argv[1]);
        return 1;
    }

    current_filename = argv[1];

    if (yyparse() != 0) {
        printf("Rejected: %s at line %d\n", argv[1], yylineno);
        fclose(yyin);

        return 0;
    }

    fclose(yyin);

    yylineno = 1;

    yyin = fopen(argv[2], "r");
    if (!yyin) {
        printf("Erro ao abrir arquivo: %s\n", argv[2]);
        return 1;
    }

    current_filename = argv[2];

    if (yyparse() != 0) {
        printf("Rejected: %s at line %d\n", argv[2], yylineno);
        fclose(yyin);

        return 0;
    }

    fclose(yyin);

    printf("Accepted\n");

    return 0;
}

static char *errorMessage;

void yyerror(const char *s) {
    errorMessage = (char *)s;
}