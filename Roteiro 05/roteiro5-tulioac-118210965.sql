-- Questão 01
SELECT COUNT (*)
FROM employee
WHERE sex='F';


-- Questão 02
SELECT AVG (salary)
FROM employee
WHERE 
  sex='M'
  AND
  address LIKE '%, TX';


-- Questão 03
SELECT
  E.superssn AS ssn_supervisor,
  COUNT (*) AS qtd_supervisionados
FROM
  employee AS E
  LEFT JOIN
  employee AS S
  ON E.superssn=S.ssn
GROUP BY E.superssn
ORDER BY COUNT (*) ASC;


-- Questão 04
SELECT
  S.fname AS nome_supervisor,
  COUNT (*) AS qtd_supervisionados
FROM
  employee AS S
  JOIN
  employee AS E
  ON S.ssn=E.superssn
GROUP BY S.fname
ORDER BY COUNT (*) ASC;


-- Questão 05
SELECT
  S.fname AS nome_supervisor,
  COUNT (*) AS qtd_supervisionados
FROM
  employee AS S
  RIGHT JOIN
  employee AS E
  ON S.ssn=E.superssn
GROUP BY S.fname
ORDER BY COUNT (*) ASC;


-- Questão 06
SELECT MIN(proj.COUNT) AS qtd
FROM
  (
  SELECT COUNT(*)
  FROM works_on
  GROUP BY pno
  ) AS proj;


-- Questão 07
SELECT
  pno AS num_projeto,
  proj.qnt_min1 AS qtd_func
FROM (
  (
  SELECT
    COUNT(*) as qnt_min1,
    pno
  FROM works_on
  GROUP BY pno
  ) AS proj
  JOIN
  ( 
  SELECT MIN(qnt_min3) as qnt_min2
  FROM
    (
    SELECT COUNT (*) as qnt_min3
    FROM works_on
    GROUP BY pno
    ) AS t1
  )  AS t2
  ON qnt_min1 = qnt_min2
);


-- Questão 08
SELECT
  W.pno AS num_proj,
  AVG (E.salary) AS media_sal
FROM
  employee AS E
  JOIN
  works_on AS W
  ON E.ssn=W.essn
GROUP BY W.pno;


-- Questão 09
SELECT
  P.pnumber AS num_proj,
  P.pname AS proj_name,
  AVG (E.salary) AS media_sal
FROM
  employee AS E
  JOIN
  works_on AS W
  ON E.ssn=W.essn
  JOIN
  project AS P
  ON P.pnumber=W.pno
GROUP BY P.pnumber
ORDER BY media_sal;


-- Questão 10
SELECT
  E.fname,
  E.salary
FROM
  employee AS E
WHERE E.salary > ALL 
(
SELECT salary
FROM
  works_on AS W
  JOIN
  employee AS EMP
  ON (W.essn=EMP.ssn AND W.pno=92)
);


-- Questão 11
SELECT
  E.ssn,
  COUNT (W.pno) AS qtd_proj
FROM
  employee AS E
  LEFT JOIN
  works_on AS W
  ON (E.ssn=W.essn)
GROUP BY E.ssn
ORDER BY COUNT (W.pno) ASC;


-- Questão 12
SELECT *
FROM
  ( 
  SELECT
    W.pno  AS num_proj,
    COUNT (e.ssn) AS qtd_func
  FROM
    employee AS E
    LEFT JOIN
    works_on AS W
    ON (E.ssn=W.essn)
  GROUP BY W.pno
  ORDER BY COUNT (E.ssn)
) AS contador
WHERE qtd_func < 5;


-- Questão 13
SELECT fname
FROM employee
WHERE ssn IN (
  SELECT W.essn
FROM
  works_on AS W,
  project AS P
WHERE 
  P.plocation = 'Sugarland'
  AND
  W.pno = P.pnumber
  AND
  ssn IN (
    SELECT D.essn
  FROM
    employee AS E,
    dependent AS D
  WHERE E.ssn=D.essn
  )
);


-- Questão 14
SELECT D.dname
FROM department AS D
WHERE NOT EXISTS 
(
SELECT *
FROM project AS P
WHERE P.dnum=D.dnumber
);


-- Questão 15
SELECT
  E.fname,
  E.lname
FROM employee AS E
WHERE 
E.ssn = (
SELECT W.essn
FROM works_on AS W
WHERE W.pno IN 
  (
  SELECT WO.pno
  FROM works_on AS WO
  WHERE 
  WO.essn='123456789'
  )
  AND
  W.essn<>'123456789'
GROUP BY W.essn
HAVING COUNT (W.pno) = (
  SELECT COUNT(*)
FROM works_on AS WO
WHERE WO.essn='123456789'));