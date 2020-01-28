grammar pascal;


////////// Parser rules (putting input into tree) //////////


// Program name

program: PROGRAM PNAME SMCOLN;

// Variable declarations (not finished)

variable: VAR VNAME;
varDeclaration: vNameList COLON;
vNameList: VNAME (COMMA VNAME)*;

// Main program block




////////// Lexer rules (breaking up the input). Must be uppercase names! //////////


// Program name

PROGRAM: 'program';
PNAME: [a-zA-Z][a-zA-Z0-9_]*;

// Variable declarations

VAR: 'VAR';
VNAME: [a-zA-Z][a-zA-Z0-9_]*;
// TODO: VTYPE

// Main program block



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

// Misc. utility
