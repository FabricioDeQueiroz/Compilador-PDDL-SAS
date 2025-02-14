%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;

extern int yylineno;

int yylex(void);
int yyparse(void);

void yyerror(const char *s);

extern char *yytext;  // String do token atual no Flex
extern int yytoken;   // Último token processado pelo Bison

#define MAX_REQ_KEYS 1024
static char *reqKeys[MAX_REQ_KEYS];
static int reqKeysCount = 0;

void addReqKey(const char *req) {
    if (reqKeysCount < MAX_REQ_KEYS) {
        reqKeys[reqKeysCount++] = strdup(req);
    }
}

int hasReqKey(const char *req) {
    int i;
    for (i = 0; i < reqKeysCount; i++) {
        if (strcmp(reqKeys[i], req) == 0)
            return 1;
    }
    return 0;
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
    |   typeDef
    |   constDef
    |   predDef
    |   funcDef
    |   structDef
    ;

reqDef: 
        '(' ':' REQUIREMENTS reqKey_List ')'
    ;

reqKey_List:
        reqKey
    |   reqKey_List reqKey
    ;

reqKey:
        ':' IDENTIFIER { addReqKey($2); }
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
        NameList '-' typeType               { if (!hasReqKey("typing")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
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

atomicFormulaSkeleton:
        '(' IDENTIFIER typedListVar ')'
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
        VarList '-' typeType            { if (!hasReqKey("typing")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

VarList:
        VarList VARIABLE
    |   VARIABLE
    ;

funcDef:
        '(' ':' FUNCTIONS functionTypedList ')'         { if (!hasReqKey("fluents")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

functionTypedList:
        atomicFormulaSkeletonList
    |   atomicFormulaSkeletonList '-' NUMBER functionTypedList            { if (!hasReqKey("typing")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   /* vazio */
    ;

structDef:
        actionDef
    |   durativeActionDef           { if (!hasReqKey("durative-actions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   derivedDef                  { if (!hasReqKey("derived-predicates")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
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
    |   literalTerm                                         { if (!hasReqKey("negative-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' AND goalDef_NList ')'   
    |   '(' OR goalDef_NList ')'                            { if (!hasReqKey("disjunctive-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' NOT goalDef ')'                                 { if (!hasReqKey("disjunctive-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' IMPLY goalDef goalDef ')'                       { if (!hasReqKey("disjunctive-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' EXISTS '(' typedListVar ')' goalDef ')'   { if (!hasReqKey("existential-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' FORALL '(' typedListVar ')' goalDef ')'   { if (!hasReqKey("universal-preconditions")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   fComp                                               { if (!hasReqKey("fluents")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

atomicFormulaTerm:
        '(' IDENTIFIER term_NList ')'
    ;

term_NList:
        term_NList term
    |   /* vazio */
    ;

term:
        VARIABLE
    |   IDENTIFIER
    ;

literalTerm:
       '(' NOT atomicFormulaTerm ')'
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
    |   '(' '-' fExp ')'
    |   fHead
    ;

binaryOp:
        '+'
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
        '(' FORALL '(' var_NList ')' effect ')'         { if (!hasReqKey("conditional-effects")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' WHEN goalDef CondEffect ')'                 { if (!hasReqKey("conditional-effects")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   pEffect
    ;

cEffect_NList:
        cEffect_NList cEffect
    |   /* vazio */
    ;

var_NList:
        var_NList VARIABLE
    |   /* vazio */
    ;

CondEffect:
        '(' AND pEffect_NList ')'
    |   pEffect
    ;   

pEffect:
        '(' NOT atomicFormulaTerm ')'
    |    atomicFormulaTerm
    |   '(' assignOp fHead fExp ')'                     { if (!hasReqKey("fluents")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
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
    |   '(' '=' fHead NUMBER ')'                { if (!hasReqKey("fluents")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    |   '(' AT NUMBER literalName ')'           { if (!hasReqKey("timed-initial-literals")) { yyerror("Erro"); } } // TODO ver como colocar o arquivo onde ocorreu e a linha
    ;

literalName:
        atomicFormulaName
    |   '(' NOT atomicFormulaName ')'
    ;  

atomicFormulaName:
        '(' IDENTIFIER identifier_NList ')'
    ;

identifier_NList:
        identifier_NList IDENTIFIER
    |   /* vazio */
    ;

goal:
        '(' ':' GOAL goalDef ')'
    ;

metricSpec_Opt:
        metricSpec
    |   /* vazio */
    ;

metricSpec:
        '(' METRIC optimization groundFExp ')'
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
        fprintf(stderr, "Uso: %s <dominio.pddl> <problema.pddl>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Erro ao abrir arquivo: %s\n", argv[1]);
        return 1;
    }

    if (yyparse() != 0) {
        fprintf(stderr, "Rejected: %s at line %d\n", argv[1], yylineno);
        fclose(yyin);

        return 0;
    }

    fclose(yyin);

    yyin = fopen(argv[2], "r");
    if (!yyin) {
        fprintf(stderr, "Erro ao abrir arquivo: %s\n", argv[2]);
        return 1;
    }

    if (yyparse() != 0) {
        fprintf(stderr, "Rejected: %s at line %d\n", argv[2], yylineno);
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
    /* printf("Erro na linha %d | TOKEN: %s\n", yylineno, yytext); */
}