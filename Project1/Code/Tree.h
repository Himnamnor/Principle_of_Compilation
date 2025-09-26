#ifndef TREE_H
#define TREE_H
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>

typedef enum
{
    NODE_NONTERMINAL,
    NODE_ID,
    NODE_TYPE,
    NODE_INT,
    NODE_FLOAT,
    NODE_OTHER
} NodeKind;

typedef struct TreeNode
{
    char nodeName[50];
    NodeKind nodeKind;
    union
    {
        int lineNum;
        int ival;
        float fval;
        char idName[50];
        char typeName[50];
    } nodeVal;
    struct TreeNode *child;
    struct TreeNode *sibling;
} TreeNode;


TreeNode *newNonTerminalNode(const char *name, int line);
TreeNode *newIDNode(const char *name);
TreeNode *newTypeNode(const char *type);
TreeNode *newIntNode(int val);
TreeNode *newFloatNode(float val);
TreeNode *newOtherNode(const char *name);
TreeNode *addChildren(TreeNode *parent, int num, ...);
void printTree(TreeNode *node, int level);

#endif