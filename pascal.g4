grammar pascal;

// See https://stackoverflow.com/questions/7527232/antlr-header-parser-superclass-option-and-basic-file-io-java
@header {
    import java.lang.Math;
    import java.util.HashMap;
    import java.util.Scanner;
}

@members {
    Map<String, Double> arithVars = new HashMap<String, Double>();
    Map<String, Boolean> boolVars = new HashMap<String, Boolean>();

    Scanner scanner = new Scanner(System.in);

    // Separate the variable name list into usable names
    public String [] parseString(String variable_list){
        String[] values = variable_list.split("\\s*,\\s*");

        return values;
    }
}


/*************** Parser rules (putting input into tree) ***************/


/***** Program *****/

program: PROGRAM NAME SMCOLN (variable)? program_block;

/***** Variable declarations *****/

variable: VAR varDeclaration+;
varDeclaration: vNameList COLON VTYPE '=' (REAL | BOOL) SMCOLN
    { if ($VTYPE.text.equals("boolean")){
        String [] vnames = parseString($vNameList.text);
        for (int i = 0; i < vnames.length; i++){
            boolVars.put(vnames[i], Boolean.parseBoolean($BOOL.text));
        }
      }
      else if ($VTYPE.text.equals("real")){
        String [] vnames = parseString($vNameList.text);
        for (int i = 0; i < vnames.length; i++){
            arithVars.put(vnames[i], Double.valueOf($REAL.text));
        }
      }
      else {
        System.out.println("Error! Unrecognized type");
      }
    }
    | vNameList COLON VTYPE '=' (arith_expr | bool_expr) SMCOLN
          { if ($VTYPE.text.equals("boolean")){
              String [] vnames = parseString($vNameList.text);
              for (int i = 0; i < vnames.length; i++){
                  boolVars.put(vnames[i], Boolean.parseBoolean($bool_expr.text));
              }
            }
            else if ($VTYPE.text.equals("real")){
              String [] vnames = parseString($vNameList.text);
              for (int i = 0; i < vnames.length; i++){
                  arithVars.put(vnames[i], Double.valueOf($arith_expr.text));
              }
            }
            else {
              System.out.println("Error! Unrecognized type");
            }
          }
    ;

vNameList: NAME (COMMA NAME)*;

/***** Main program block *****/

program_block: BEGIN statement_list END SMCOLN;
statement_list: statement | statement SMCOLN statement_list;
statement: program_block | if_block | empty; // TODO: readln, writeln

empty: ;

/***** Basic arithmetic expressions with variables *****/

// For 'real' (double) variables
arith_expr returns[double d]:
       '(' e=arith_expr ')' { $d = $e.d; }
       | el=arith_expr '*' er=arith_expr { $d = $el.d * $er.d; }
       | el=arith_expr '/' er=arith_expr { $d = $el.d / $er.d; }
       | el=arith_expr '+' er=arith_expr { $d = $el.d + $er.d; }
       | el=arith_expr '-' er=arith_expr { $d = $el.d - $er.d; }
       // Base
       | REAL { $d = Double.valueOf($REAL.text); }
       // Variable names
       | NAME { $d = arithVars.get($NAME.text); }
       // Special expressions
       | spcl_math_expr {$d = $spcl_math_expr.d; }
       ;

/***** Boolean/logical Expressions *****/

bool_expr returns [boolean b]:
    el=bool_expr AND er=bool_expr { $b = (($el.b != false ? true : false) && ($er.b != false ? true : false)) ? true : false; }
    | el=bool_expr OR er=bool_expr { $b = (($el.b != false ? true : false) || ($er.b != false ? true : false)) ? true : false; }
    | NOT el=bool_expr { $b = (!($el.b != false ? true : false) ? true : false); }
    // Base
    | BOOL { $b = Boolean.parseBoolean($BOOL.text); }
    // Variable names
    | NAME { $b = boolVars.get($NAME.text); }
    ;

/***** Decision Making (if-then-else, case) *****/

if_block: IF condition THEN statement (ELSE IF bool_expr THEN statement)* (ELSE statement)?;

condition returns [boolean b]:
    el=bool_expr '=' er=bool_expr { $b = (($el.b == $er.b) ? true : false; }
    | el=bool_expr NOT '=' er=bool_expr { $b = (($el.b == $er.b) ? true : false; }
    | BOOL { $b = Boolean.parseBoolean($BOOL.text); }
    ;

// TODO: Case

/***** Special Expressions: Readln, Writeln, sqrt, sin, cos, ln, exp *****/

// TODO: Readln (unfinished), Writeln
readln: READLN '(\'' TEXT '\')' { System.out.println($TEXT.text); };

// For sqrt, sin, cos, ln, and exp
spcl_math_expr returns [double d]:
    expr=SQRT '(' contents=arith_expr ')' { $d = Math.sqrt($contents.d); }
    | expr=SIN '(' contents=arith_expr ')' { $d = Math.sin($contents.d); }
    | expr=COS '(' contents=arith_expr ')' { $d = Math.cos($contents.d); }
    | expr=LN '(' contents=arith_expr ')' { $d = Math.log($contents.d); }
    | expr=EXP '(' contents=arith_expr ')' { $d = Math.exp($contents.d); }
    ;


/*************** Lexer rules (breaking up the input). Must be uppercase names! ***************/


/*
Ordering rule is: Most specific to least specific. DO NOT BREAK THIS RULE! Very bad things will happen if you do.
*/

PROGRAM: 'program';
VAR: 'VAR';
VTYPE: 'boolean' | 'real';
VASSIGN: ':=';
BEGIN: 'BEGIN';
END: 'END';


READLN: 'readln';
WRITELN: 'writeln';


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

REAL: [-]?[0-9]+('.'[0-9]+)?;
INT: [0-9]+;

NAME: [a-zA-Z][a-zA-Z0-9_]*;

// Could mess things up?
SPACE : [ \n\r\t] -> skip;
SMCOLN: ';';
COMMA: ',';
COLON: ':';

TEXT: .;