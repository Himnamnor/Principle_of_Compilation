#include<stdio.h>
#include"lexical.h"
#include<string.h>
#include"syntax.tab.h"

extern int yylineno;
extern int yycolumn;
extern int yydebug;

int main(int argc, char** argv){
    if(argc>1){
        if(!(yyin=fopen(argv[1],"r"))){
            perror(argv[1]);
            return 1;
        }
    }
    yyrestart(yyin);
    yydebug = 0;
    yyparse();
    return 0;
}