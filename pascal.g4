grammar pascal;


////////// Parser rules (putting input into tree) //////////


// Program name

program: PROGRAM PNAME SMCOLN;

// Variable declarations (not finished)

variable: VAR NEWLINE TAB varDeclaration+;
varDeclaration: vNameList COLON VTYPE SMCOLN;
vNameList: VNAME (COMMA VNAME)*;

// TODO
assign_variable: VNAME; //VNAME ASSIGN ...?

// Main program block
program_block: BEGIN statement END;
statement_list: statement | statement SMCOLN statement_list;
statement: program_block | assign_variable | empty;

// Basic arithmetic expressions with variables
arithExpr: VNAME EXPR VNAME;

// Misc. utility
empty: ;


////////// Lexer rules (breaking up the input). Must be uppercase names! //////////


// Program name

PROGRAM: 'program';
PNAME: [a-zA-Z][a-zA-Z0-9_]*;

// Variable declarations

VAR: 'VAR';
VNAME: [a-zA-Z][a-zA-Z0-9_]*;
VTYPE: 'boolean' | 'real';

// Main program block
BEGIN: 'BEGIN';
END: 'END';

// Basic arithmetic expressions with variables
EXPR: PLUS | MINUS | MULT | DIV;
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';


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
