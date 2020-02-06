variable: VAR varDeclaration+;
varDeclaration: vNameList COLON VTYPE assignment SMCOLN
    {
        if (!($assignment.s.equals("null"))){
            if ($VTYPE.text.equals("boolean")){
                String [] vnames = parseString($vNameList.text);
                for (int i = 0; i < vnames.length; i++){
                    boolVars.put(vnames[i], Boolean.parseBoolean($assignment.s));
                }
            }
            else if ($VTYPE.text.equals("real")){
                String [] vnames = parseString($vNameList.text);
                for (int i = 0; i < vnames.length; i++){
                    arithVars.put(vnames[i], Double.parseDouble($assignment.s));
                }
            }
        }

        else{
            if ($VTYPE.text.equals("boolean")){
                String [] vnames = parseString($vNameList.text);
                for (int i = 0; i < vnames.length; i++){
                    boolVars.put(vnames[i], false);
                }
            }
            else if ($VTYPE.text.equals("real")){
                String [] vnames = parseString($vNameList.text);
                for (int i = 0; i < vnames.length; i++){
                    arithVars.put(vnames[i], 0.0);
                }
            }
        }
    }
    ;

vNameList: NAME (COMMA NAME)*;

assignment returns [String s]:
'=' BOOL {$s = $BOOL.text;}
| '=' REAL {$s = $REAL.text;}
| '=' arith_expr {$s = $arith_expr.text;}
| '=' bool_expr {$s = $bool_expr.text;}
| {$s = "null";};