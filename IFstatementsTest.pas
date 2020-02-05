PROGRAM ifstatementstest;
VAR
    i, j : boolean;
    k, m : real;

BEGIN
    i := true;
    j := false;
    k := 13;
    m := 6;

    IF j THEN WRITELN(k)
    ELSE BEGIN
        IF i THEN WRITELN(m);
    END
END.