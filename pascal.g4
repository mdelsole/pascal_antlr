grammar pascal;


////////// Parser rules (putting input into tree) //////////


// Program name

program: PROGRAM PNAME SMCOLN;

// Variable declarations (not finished)

variable: VAR NEWLINE TAB varDeclaration+;
varDeclaration: vNameList COLON VTYPE;
vNameList: VNAME (COMMA VNAME)*;

// TODO: Main program block

// Basic arithmetic expressions with variables
arithExpr: VNAME EXPR VNAME;


////////// Lexer rules (breaking up the input). Must be uppercase names! //////////


// Program name

PROGRAM: 'program';
PNAME: [a-zA-Z][a-zA-Z0-9_]*;

// Variable declarations

VAR: 'VAR';
VNAME: [a-zA-Z][a-zA-Z0-9_]*;
VTYPE: 'boolean' | 'real';

// Main program block


// Basic arithmetic expressions with variables
EXPR: '+' | '*' | '-' | '/';


// Comments
COMMENT1: '(*' .*? '*)' -> skip;
COMMENT2: '{' .*? '}' -> skip;

// Misc. characters

NUM: [0-9]+;
// Could mess things up?
SPACE : [ ] -> skip;
SMCOLN: ';';
COMMA: ',';
COLON: ':';
NEWLINE: [\n\r];
TAB: [\t];

// Misc. utility
