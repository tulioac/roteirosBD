-- Questão 01

-- Letra A: vw_dptmgr: contém apenas o número do departamento e o nome do gerente

CREATE VIEW vw_dptmgr
AS
    SELECT
        E.dno,
        E.fname
    FROM
        department AS D,
        employee AS E
    WHERE 
        D.mgrssn=E.ssn;


-- Letra B: vw_empl_houston: contém o ssn e o primeiro nome dos empregados com endereço em Houston

CREATE VIEW vw_empl_houston
AS
    SELECT
        E.ssn,
        E.fname
    FROM
        employee AS E
    WHERE 
        E.address LIKE '%Houston%';


-- Letra C: vw_deptstats: contém o número do departamento, o nome do departamento e o número de funcionários que trabalham no departamento

CREATE VIEW vw_deptstats
AS
    SELECT
        D.dnumber,
        D.dname,
        COUNT(*) AS num_employee
    FROM
        (works_on AS W
        INNER JOIN
        project AS P ON (P.number = W.pno)
        INNER JOIN
        department AS D ON (P.dnum = D.dnumber)
    GROUP BY 
    D.dnumber;


-- Letra D: vw_projstats: contém o id do projeto e a quantidade de funcionários que trabalham no projeto

CREATE VIEW vw_projstats
AS
    SELECT
        P.pnumber,
        COUNT(*) AS num_employee
    FROM
        (works_on AS W
        INNER JOIN
        project AS P ON (P.pnumber=W.pno))
    GROUP BY 
        P.pnumber;


-- Questão 02

-- Letra A:

SELECT *
FROM vw_dptmgr;


-- Letra B:

SELECT *
FROM vw_empl_houston;


-- Letra C:

SELECT *
FROM vw_deptstats;


-- Letra D:

SELECT *
FROM vw_projstats;


-- Questão 03

-- Letra A:

DROP VIEW vw_dptmgr;


-- Letra B:

DROP VIEW vw_empl_houston;


-- Letra C:

DROP VIEW vw_deptstats;


-- Letra D:

DROP VIEW vw_projstats;


-- Questão 04

CREATE OR REPLACE FUNCTION check_age
(E_ssn CHAR
(7)) 
RETURNS VARCHAR AS $$DECLARE
    E_idade INTEGER;
    saida VARCHAR;
BEGIN
    SELECT date_part("year",age(bdate))
    INTO E_idade
    FROM employee AS e
    WHERE E_ssn = e.ssn;
    IF (E_idade >= 50) 
    THEN saida := "SENIOR";
ELSEIF
(E_idade < 50 AND E_idade >= 0) 
THEN saida := "YOUNG";
    ELSEIF
(E_idade IS NULL) 
THEN saida := "UNKNOWN";
    ELSE saida := "INVALID";
END
IF;
    RETURN saida;
END;
$$ LANGUAGE plpgsql;


-- Questão 05

CREATE OR replace FUNCTION check_mgr
() 
RETURNS trigger AS $check_mgr$
DECLARE
        E_dno INTEGER;
        E_age INTEGER;
        E_supervisee employee%ROWTYPE;
BEGIN
    SELECT dno
    INTO E_dno
    FROM employee
    WHERE ssn = new.mgrssn;
    SELECT *
    INTO E_supervisee
    FROM employee
    WHERE new.mgrssn = superssn;
    SELECT date_part("year",age(bdate))
    INTO E_age
    FROM employee
    WHERE ssn = new.mgrssn;
    IF new.dnumber != E_dno THEN RAISE EXCEPTION 'manager must be a department''s employee';
END
IF;
        IF E_age < 50 THEN RAISE EXCEPTION 'manager must be a SENIOR employee';
END
IF;
        IF E_supervisee IS NULL THEN RAISE EXCEPTION 'manager must have supervisees';
END
IF;
        RETURN null;
END;
$check_mgr$ LANGUAGE plpgsql;

CREATE TRIGGER check_mgr BEFORE
INSERT OR
UPDATE ON department
    FOR EACH ROW
EXECUTE PROCEDURE check_mgr
();