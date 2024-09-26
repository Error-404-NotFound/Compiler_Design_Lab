%{
#include<stdio.h>
#include<stdbool.h>
#include<string.h>
#include<stdlib.h>
#include<limits.h>
#include<float.h>

int yylex();
int yyerror(char*);
int yyparse();
extern FILE * yyin;
int errorFlag = 0;
int eflag = 0;
int temp_int = INT_MIN;
float temp_float = FLT_MIN;

typedef struct Node {
    char *type;   
    struct Node *left;
    struct Node *right;
    int value;    
    char* varName; 
} Node;

Node* createNode(char *type, Node *left, Node *right, int value, char *varName);
void printPostOrder(Node *node);
void freeTree(Node *node);

%}

%name parser

%union{
    int num;
    float fnum;
    char* lexeme;
    char* varName;
    struct Node* node;
}

%token <num> INT
%token <fnum> FLOAT
%token <lexeme> ID
%token INCREMENT DECREMENT ADD SUB MUL DIV MOD LP RP ASSIGN SEMICOLON

%right ASSIGN
%left ADD SUB
%left MUL DIV MOD
%right UMINUS

%type <node> E T F 

%%
slist: 
    stmt SEMICOLON
    | slist stmt SEMICOLON
    ;

stmt:
    ID ASSIGN E {
        if(errorFlag == 0){
            // printf("\t\tAccepted.\n");
            Node *varNode = createNode("variable", NULL, NULL, 0, $1);
            printf("\t\t");
            printPostOrder($3);
            freeTree($3);
            printf("\n");
        }
        errorFlag = 0;
    }
    | error { 
        printf("\t\tError: Syntax error.\n"); 
        errorFlag = 1; 
    }
    ;

E: 
    E ADD T { 
        // $$ = $1 + $3; 
        $$ = createNode("+", $1, $3, 0, NULL);
    }
    | E SUB T { 
        $$ = $1 - $3; 
        $$ = createNode("-", $1, $3, 0, NULL);
    }
    | T { 
        $$ = $1; 
    }
    | E error T { 
        printf("\t\tError: Operand missing.\n");
        errorFlag = 1; 
    }
    // | LP E RP { $$ = $2; }
    ;

T:
    T MUL F { 
        // $$ = $1 * $3; 
        $$ = createNode("*", $1, $3, 0, NULL);
    }
    | T DIV F { 
        if (temp_int == 0){
            printf("\t\tError: Division by zero.\n");
            errorFlag = 1;
            temp_int = INT_MIN;
        }
        else{
            // $$ = $1 / $3;
            $$ = createNode("/", $1, $3, 0, NULL);
        }
    }
    | T MOD F { 
        if (temp_float!=FLT_MIN){
            printf("\t\tError: MOD by float.\n");
            errorFlag = 1;
            temp_float = FLT_MIN;
        }
        else{
            // $$ = $1 % $3;
            $$ = createNode("%", $1, $3, 0, NULL);
        }
    }
    | F { 
        $$ = $1; 
    }
    | error {
        printf("\t\tError: Invalid Term.\n");
        errorFlag = 1;
    }
    ;

F:
    LP E RP { 
        $$ = $2; 
    }
    | LP E error{
        printf("\t\tError: ')' missing.\n");
        errorFlag = 1;
    }
    | error RP {
        printf("\t\tError: '(' missing.\n");
        errorFlag = 1;
        // $$ = 0;
        $$ = createNode("number", NULL, NULL, 0, NULL);
    }
    | SUB F %prec UMINUS { 
        // $$ = -$2; 
        $$ = createNode("-", $2, NULL, 0, NULL);
    }
    | INT { 
        // $$ = $1;
        // temp_int = $1; 
        $$ = createNode("number", NULL, NULL, $1, NULL);
    }
    | ID { 
        // $$ = $1;
        $$ = createNode("variable", NULL, NULL, 0, strdup($1));
    }
    | error { 
        printf("\t\tError: Invalid Factor.\n"); 
        errorFlag = 1; 
    }
    ;
%%

Node* createNode(char *type, Node *left, Node *right, int value, char *varName) {
    Node *node = (Node *)malloc(sizeof(Node));
    node->type = strdup(type);
    node->left = left;
    node->right = right;
    node->value = value;
    node->varName = varName ? strdup(varName) : NULL;
    return node;
}

void printPostOrder(Node *node) {
    if (node == NULL) return;
    printPostOrder(node->left);
    printPostOrder(node->right);
    if (node->type == NULL) {
        return;
    }
    if (strcmp(node->type, "number") == 0) {
        printf(" %d ", node->value);
    } else if (strcmp(node->type, "variable") == 0) {
        printf(" %s ", node->varName);
    } else {
        printf(" %s ", node->type);
    }
}

void freeTree(Node *node) {
    if (node == NULL) return;
    freeTree(node->left);
    freeTree(node->right);
    free(node->type);
    if (node->varName) free(node->varName); // Free varName if it was allocated
    free(node);
}

int yyerror(char *s){
    eflag = 0;
    // fprintf(stderr, "%s\n", s);
    // if (eflag == IMAG_MISS){
    //     // yyerror("Imaginary part missing.");
    //     fprintf(stderr, "Error: Imaginary part missing.\n");
    //     eflag = 0;
    // }
    return 0;
}

int main(int argc, char *argv[]){
    if(argc != 2){
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if(yyin == NULL){
        fprintf(stderr, "Error opening the input file.\n");
        return 1;
    }
    yyparse();
    fclose(yyin);
    return 0;
}
