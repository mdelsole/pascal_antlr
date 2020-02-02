grammar pascal;

// See https://stackoverflow.com/questions/7527232/antlr-header-parser-superclass-option-and-basic-file-io-java
@header {
    import java.lang.Math;
    import java.util.HashMap;
    import java.util.Scanner;
}

@members {
    Map<String, String> vars = new HashMap<>();
    Scanner scanner = new Scanner(System.in);
}


/*************** Parser rules (putting input into tree) ***************/


/***** Program name *****/

program: PROGRAM NAME SMCOLN;
// TODO: Store?

/***** Variable declarations *****/

variable: VAR varDeclaration+;
varDeclaration: vNameList COLON VTYPE SMCOLN;
vNameList: NAME (COMMA NAME)*;

/***** Main program block *****/

program_block: BEGIN (variable)? statement_list END;
statement_list: statement | statement SMCOLN statement_list;
statement: program_block | if_block | empty; //general_expr

/***** Basic arithmetic expressions with variables *****/

// For 'real' (float) variables
arith_expr returns[double d]:
       '(' e=arith_expr ')' { $d = $e.d; }
       | el=arith_expr '*' er=arith_expr { $d = $el.d * $er.d; }
       | el=arith_expr '/' er=arith_expr { $d = $el.d / $er.d; }
       | el=arith_expr '+' er=arith_expr { $d = $el.d + $er.d; }
       | el=arith_expr '-' er=arith_expr { $d = $el.d - $er.d; }
       // Base
       | DOUBLE { $d = Double.valueOf($DOUBLE.text); }
       ;

/***** Boolean/logical Expressions *****/

bool_expr returns [boolean b]:
    el=bool_expr AND er=bool_expr { $b = (($el.b != false ? true : false) && ($er.b != false ? true : false)) ? true : false; }
    | el=bool_expr OR er=bool_expr { $b = (($el.b != false ? true : false) || ($er.b != false ? true : false)) ? true : false; }
    | NOT el=bool_expr { $b = (!($el.b != false ? true : false) ? true : false); }
    // Base
    | BOOL { $b = Boolean.parseBoolean($BOOL.text); }
    ;

/***** Expressions as a whole (combined bool+float) *****/

//general_expr returns [String s] ;


/***** Decision Making (if-then-else, case) *****/

if_block: IF condition THEN statement (ELSE IF bool_expr THEN statement)* (ELSE statement)?;

condition returns [boolean b]:
    el=bool_expr '=' er=bool_expr { $b = (($el.b == $er.b) ? true : false; }
    | el=bool_expr NOT '=' er=bool_expr { $b = (($el.b == $er.b) ? true : false; }
    | BOOL { $b = Boolean.parseBoolean($BOOL.text); }
    ;

// TODO: Case

/***** Special Expressions: Readln, Writeln, sqrt, sin, cos, ln, exp *****/

// TODO: Readln, Writeln
//spcl_read_expr: NAME;

// For sqrt, sin, cos, ln, and exp
spcl_math_expr returns [double d]:
    expr=SQRT '(' contents=arith_expr ')' { $d = Math.sqrt($contents.d); }
    | expr=SIN '(' contents=arith_expr ')' { $d = Math.sin($contents.d); }
    | expr=COS '(' contents=arith_expr ')' { $d = Math.cos($contents.d); }
    | expr=LN '(' contents=arith_expr ')' { $d = Math.log($contents.d); }
    | expr=EXP '(' contents=arith_expr ')' { $d = Math.exp($contents.d); }
    ;

/***** Misc. utility *****/

empty: ;


/*************** Lexer rules (breaking up the input). Must be uppercase names! ***************/

/*
Antlr is dumb. Why can't the parser listen for a lexer token? That kind of defeats the purpose of the whole language.

Ordering rule is: Most specific to least specific. DO NOT BREAK THIS RULE! Very bad things will happen if you do.
*/

PROGRAM: 'program';
VAR: 'VAR';
VTYPE: 'boolean' | 'real';
BEGIN: 'BEGIN';
END: 'END';


COMMENT1: '(*' .*? '*)' -> skip;
COMMENT2: '{' .*? '}' -> skip;

BOOL: 'true' | 'false';
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';

AND : 'and' ;
OR : 'or' ;
NOT : 'not' ;


SQRT : 'sqrt' ;
EXP : 'exp';
COS : 'cos';
SIN : 'sin';
LN : 'ln';

IF : 'if';
ELSE : 'else';
THEN : 'then';

DOUBLE: [-]?[0-9]+('.'[0-9]+)?;
INT: [0-9]+;

NAME: [a-zA-Z][a-zA-Z0-9_]*;

// Could mess things up?
SPACE : [ \n\r\t] -> skip;
SMCOLN: ';';
COMMA: ',';
COLON: ':';