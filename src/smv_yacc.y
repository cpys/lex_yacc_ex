%{
#include "node.h"
%}

%token MODULE VAR ASSIGN TRANS CASE ESAC INIT NEXT TRUE
%token RANGE_OP INIT_OP
%token<m_string>IDENTIFIER
%token<m_int>CONSTANT

%start file

%%

file
    : module
    | file module
    ;

module
    : declaration_module declaration_vars
    | declaration_module declaration_vars initialization_vars
    | declaration_module declaration_vars initialization_vars transition_vars
    ;

declaration_module
    : MODULE IDENTIFIER
    {
        cout << "module: " << $2 << endl;
    }
    ;

declaration_vars
    : VAR statement_list
    ;

initialization_vars
    : ASSIGN statement_list
    ;

transition_vars
    : TRANS statement_list

statement_list
    : statement
    | statement_list statement
    ;

statement
    : expression_statement
    | switch_statement
    ;

expression_statement
    : ';'
    | expression ';'
    ;

switch_statement
    : CASE statement_list ESAC
    ;

expression
    : unary_expression
    | unary_expression operator expression
    | conditional_expression ':' expression
    ;

unary_expression
    : primary_expression
    | INIT '(' primary_expression ')'
    | NEXT '(' primary_expression ')'
    | '(' expression ')'
    ;

primary_expression
    : IDENTIFIER
    {
        cout << "identifier: " << $1 << endl;
    }
    | CONSTANT
    {
        cout << "constant: " << $1 << endl;
    }
    ;

operator
    : ':'
    | INIT_OP
    | '='
    | RANGE_OP
    | '%'
    ;

conditional_expression
    : equality_expression
    | TRUE
    ;

equality_expression
    : primary_expression '=' primary_expression
    ;


%%

void yyerror(const char* s) {
    cerr << s << endl;
}

// 程序主函数，这个函数也可以放到其他.c, .cpp文件中
int main() {
    const char* sFile = "../examples/bmc_tutorial.smv";
    FILE* fp = fopen(sFile, "r");
    if (fp == NULL) {
        printf("cannot open %s\n", sFile);
        return -1;
    }
    extern FILE* yyin;  // yyin和yyout都是FILE*类型
    yyin = fp;  // yacc会从yyin读取输入，yyin默认是标准输入，这里改为磁盘文件。yacc默认向yyout输出，可修改yyout改变输出目的

    printf("-----begin parsing %s\n", sFile);
    yyparse();  // 使yacc开始读取输入和解析，它会调用lex的yylex()读取记号
    puts("-----end parsing");

    fclose(fp);

    return 0;
}