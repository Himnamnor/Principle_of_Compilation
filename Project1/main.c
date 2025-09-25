#include<stdio.h>
#include "Tree.h"
#include"lexical.h"
#include<string.h>
#include"syntax.tab.h"


extern int yylineno;
extern int yycolumn;
extern int yydebug;
TreeNode *root;
int has_error = 0;

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
    //printf("parse end\n");
    if (root != NULL&&has_error==0)
    {
        printTree(root, 0);
    }
    return 0;
}