grammar pascal;

// See https://stackoverflow.com/questions/7527232/antlr-header-parser-superclass-option-and-basic-file-io-java
@header {
    import java.lang.Math;
}

@members {
    Map<String, Map<Integer, Double>> vars = new HashMap<String, HashMap<Integer, Double>>();
    Scanner scanner = new Scanner(System.in);
}


/*************** Parser rules (putting input into tree) ***************/


/***** Program name *****/

program: PROGRAM PNAME SMCOLN;

/***** Variable declarations (not finished) *****/

variable: VAR NEWLINE TAB varDeclaration+;
varDeclaration: vNameList COLON VTYPE SMCOLN;
vNameList: VNAME (COMMA VNAME)*;

// TODO
assign_variable: VNAME; //VNAME ASSIGN ...?

/***** Main program block *****/

program_block: BEGIN statement END;
statement_list: statement | statement SMCOLN statement_list;
statement: program_block | assign_variable | empty; // | if | general_expr

/***** Basic arithmetic expressions with variables *****/

// Order: PEMDAS
arith_expr returns[int i]:
       '(' e=arith_expr ')' { $i = $e.i; }
       | el=arith_expr '*' er=arith_expr { $i = $el.i * $er.i; }
       | el=arith_expr '/' er=arith_expr { $i = $el.i / $er.i; }
       | el=arith_expr '+' er=arith_expr { $i = $el.i + $er.i; }
       | el=arith_expr '-' er=arith_expr { $i = $el.i - $er.i; }
       // Base
       | INT { $i = Integer.parseInt($INT.text); }
       ;

// TODO: Floats?

/***** Boolean/logical Expressions *****/

bool_expr returns [int i]:
    el=bool_expr AND er=bool_expr { $i = (($el.i != 0 ? true : false) && ($er.i != 0 ? true : false)) ? 1 : 0; }
    | el=bool_expr OR er=bool_expr { $i = (($el.i != 0 ? true : false) || ($er.i != 0 ? true : false)) ? 1 : 0; }
    | NOT el=bool_expr { $i = (!($el.i != 0 ? true : false) ? 1 : 0); }
    // Base
    | INT { $i = Integer.valueOf($INT.text); }
    ;

/***** Expressions as a whole (combined arith+bool+float) *****/

//general_expr returns [String s] ;


/***** Decision Making (if-then-else, case) *****/

// IF (condition) THEN {statement} (ELSE IF (condition) THEN {statement})* (ELSE {statement})?
if_block: IF condition THEN statement (ELSE IF bool_expr THEN statement)* (ELSE statement)?;

condition returns [boolean b]:
    el=bool_expr '=' er=bool_expr
    | el=bool_expr '>' er=bool_expr;

// TODO: Case

/***** Special Expressions: Readln, Writeln, sqrt, sin, cos, ln, exp *****/

// For Readln, Writeln
spcl_read_expr: VNAME;

// For sqrt, sin, cos, ln, and exp
spcl_math_expr returns [double i]:
    expr=SQRT '(' contents=arith_expr ')' { $i = Math.sqrt($contents.i); }
    | expr=SIN '(' contents=arith_expr ')' { $i = Math.sin($contents.i); }
    | expr=COS '(' contents=arith_expr ')' { $i = Math.cos($contents.i); }
    | expr=LN '(' contents=arith_expr ')' { $i = Math.log($contents.i); }
    | expr=EXP '(' contents=arith_expr ')' { $i = Math.exp($contents.i); }
    ;

/***** Misc. utility *****/

empty: ;


/*************** Lexer rules (breaking up the input). Must be uppercase names! ***************/


/***** Program name *****/

PROGRAM: 'program';
PNAME: [a-zA-Z][a-zA-Z0-9_]*;

/***** Variable declarations *****/

VAR: 'VAR';
VNAME: [_a-zA-Z][a-zA-Z0-9_]*;
VTYPE: 'boolean' | 'real';

/***** Main program block *****/

BEGIN: 'BEGIN';
END: 'END';

/***** Comments *****/

COMMENT1: '(*' .*? '*)' -> skip;
COMMENT2: '{' .*? '}' -> skip;

/***** Basic arithmetic expressions with variables *****/

PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';

/***** Boolean/logical Expressions *****/

AND : 'and' ;
OR : 'or' ;
NOT : 'not' ;

/***** Special Expressions: Readln, Writeln, sqrt, sin, cos, ln, exp *****/

SQRT : 'sqrt' ;
EXP : 'exp';
COS : 'cos';
SIN : 'sin';
LN : 'ln';

/***** Decision Making (if-then-else, case) *****/

IF : 'if';
ELSE : 'else';
THEN : 'then';

// TODO: Case

/***** Misc. characters *****/

INT: [0-9]+;
// Could mess things up?
SPACE : [ ] -> skip;
SMCOLN: ';';
COMMA: ',';
COLON: ':';
NEWLINE: [\n\r];
TAB: [\t];

/***** Misc. utility *****/
