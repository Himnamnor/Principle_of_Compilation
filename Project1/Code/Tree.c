#include "Tree.h"

TreeNode *newNonTerminalNode(const char *name, int line)
{
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->nodeKind = NODE_NONTERMINAL;
    strcpy(node->nodeName, name);
    node->nodeVal.lineNum = line;
    node->child = NULL;
    node->sibling = NULL;
    return node;
}

TreeNode *newIDNode(const char *name)
{
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->nodeKind = NODE_ID;
    strcpy(node->nodeName, "ID");
    strcpy(node->nodeVal.idName, name);
    node->child = NULL;
    node->sibling = NULL;
    return node;
}

TreeNode *newTypeNode(const char *type)
{
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->nodeKind = NODE_TYPE;
    strcpy(node->nodeName, "TYPE");
    strcpy(node->nodeVal.typeName, type);
    node->child = NULL;
    node->sibling = NULL;
    return node;
}

TreeNode *newIntNode(int val)
{
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->nodeKind = NODE_INT;
    strcpy(node->nodeName, "INT");
    node->nodeVal.ival = val;
    node->child = NULL;
    node->sibling = NULL;
    return node;
}

TreeNode *newFloatNode(float val)
{
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->nodeKind = NODE_FLOAT;
    strcpy(node->nodeName, "FLOAT");
    node->nodeVal.fval = val;
    node->child = NULL;
    node->sibling = NULL;
    return node;
}

TreeNode *newOtherNode(const char *name)
{
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->nodeKind = NODE_OTHER;
    strcpy(node->nodeName, name);
    node->child = NULL;
    node->sibling = NULL;
    return node;
}

TreeNode *addChildren(TreeNode *parent, int num, ...)
{
    if (parent == NULL)
        return NULL;
    va_list args;
    va_start(args, num);
    TreeNode *cur = va_arg(args, TreeNode *);
    parent->child = cur;
    for (int i = 1; i < num; i++)
    {
        if (cur == NULL)
            continue;
        TreeNode *next = va_arg(args, TreeNode *);
        if (next != NULL)
        {
            cur->sibling = next;
            cur = next;
        }
    }
    va_end(args);
    return parent;
}

void printTree(TreeNode *node, int level)
{
    if (node == NULL)
        return;
    if (strcmp(node->nodeName, "PostfixExp") == 0 ||
        strcmp(node->nodeName, "UnaryExp") == 0 ||
        strcmp(node->nodeName, "MultiplicativeExp") == 0 ||
        strcmp(node->nodeName, "AdditiveExp") == 0 ||
        strcmp(node->nodeName, "RelationalExp") == 0 ||
        strcmp(node->nodeName, "LogicalAndExp") == 0 ||
        strcmp(node->nodeName, "LogicalOrExp") == 0 ||
        strcmp(node->nodeName, "AssignmentExp") == 0||
        strcmp(node->nodeName,"PrimaryExp")==0
    )
    {
    }
    else
    {
        for (int i = 0; i < level; i++)
            printf("  ");
        printf("%s", node->nodeName);
        switch (node->nodeKind)
        {
        case NODE_NONTERMINAL:
            printf(" (%d)", node->nodeVal.lineNum);
            break;
        case NODE_ID:
            printf(": %s", node->nodeVal.idName);
            break;
        case NODE_TYPE:
            printf(": %s", node->nodeVal.typeName);
            break;
        case NODE_INT:
            printf(": %d", node->nodeVal.ival);
            break;
        case NODE_FLOAT:
            printf(": %f", node->nodeVal.fval);
            break;
        default:
            break;
        }
        printf("\n");
    }
    printTree(node->child, level + 1);
    printTree(node->sibling, level);
}