PROGRAM sample;
VAR
    i, j : real;
    alpha, beta5x : boolean;

BEGIN
    i := 7;
    j := i + 2*i;
    IF i <= j THEN i := j;
    IF j > i THEN i := 3*j
    ELSE BEGIN
        alpha := true;
        beta5x := false;

        IF alpha THEN beta5x := false;
        IF beta5x THEN alpha := false;

    END
END.