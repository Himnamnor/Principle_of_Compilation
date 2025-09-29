# 问题与解决
1. 单独新建main.c文件，不识别yylex()函数，在lexical.l的definition中添加生成头文件指令`%option header-file="lexical.h"`，编译生成lexical.h，在main.c中添加该头文件解决错误
2. 使用yylineno处理行号时，要规定对文本`\n`的处理（即使为空也行），但不能没有
3. 处理不合法八进制十六进制数时遭遇词法分析不全的问题，解决办法是通过增加一条专门识别不合法数据的正则规则来检测该错误
4. 对于保留字和标识符之间的空格（包含`\t \r`等），可以跟之前的`\n`一样留白处理
5. 在syntax.y中要显式定义yyerror
6. 在词法分析过程中，我自作聪明地将int正则写成了支持符号的形式，结果在语法分析时，减号被词法分析为负号而无法匹配语法规则，惨败
7. 在将所有C文法输入syntax.y编译后，报出许多冲突，经分析，其中基本是由于运算符二义性导致的，因此将手册中一长串Exp表达式分多级Exp，成功消除除了","导致的二义性：
变量初始化赋值的","
    ```
    Dec:
        VarDec
        | VarDec ASSIGNOP Exp
        ;
    ````
    还是表达式中的","
    ```
    Exp:
        AssignmentExp
        | Exp COMMA AssignmentExp
        ;
    ```
    这个通过将Dec规则中的VarDec ASSIGNOP Exp改成VarDec ASSIGNOP AssignExp成功消除，（因为Exp里也有COMMA导致归约冲突）

8. 语法规则
    ```
    ExtDef: Specifier ExtDecList SEMI
    ```
    会导致将单个ID吞进ExtDecList而导致ASSIGNOP不能归约，将其改为
    ```
    ExtDef: Specifier DecList SEMI
    ```解决，正确处理带赋值的声明

建树采用子节点指针+兄弟节点指针（链表）的形式

9. 基本写完了，然后尝试跑样例，发现只能输出一个错误，想到指导中提到的错误处理，在代码中3个位置打上error处理

10. 使用makefile make时，发现链接出错，又把第一条里面定义的lexical.h删掉……（没错我是边写边记录这个报告的）