-- Questão 01
SELECT *
FROM department;


-- Questão 02
SELECT *
FROM dependent;


-- Questão 03
SELECT *
FROM dept_locations;


-- Questão 04
SELECT *
FROM employee;


-- Questão 05
SELECT *
FROM project;


-- Questão 06
SELECT *
FROM works_on;


-- Questão 07
SELECT fname, lname
FROM employee
WHERE sex='M';


-- Questão 08
SELECT fname
FROM employee
WHERE sex='M' AND (superssn='' OR superssn IS NULL);


-- Questão 09
SELECT e.fname AS Employee_name, s.fname AS Supervisor_name
FROM employee AS e, employee AS s
WHERE e.superssn = s.ssn;


-- Questão 10
SELECT e.fname
FROM employee AS e, employee AS s
WHERE e.superssn = s.ssn AND s.fname = 'Franklin';


-- Questão 11
SELECT d.dname, l.dlocation
FROM department AS d, dept_locations AS l
WHERE d.dnumber = l.dnumber;


-- Questão 12
SELECT d.dname, l.dlocation
FROM department AS d, dept_locations AS l
WHERE d.dnumber = l.dnumber AND l.dlocation LIKE 'S%';


-- Questão 13
SELECT e.fname, e.lname, d.dependent_name
FROM employee AS e, dependent AS d
WHERE e.ssn = d.essn;


-- Questão 14
SELECT (fname || ' ' || minit || ' ' || lname) AS full_name, salary
FROM employee
WHERE salary > 50000;


-- Questão 15
SELECT p.pname, d.dname
FROM project AS p, department AS d
WHERE p.dnum = d.dnumber;


-- Questão 16
SELECT p.pname, e.fname
FROM project AS p, department AS d, employee AS e
WHERE p.dnum = d.dnumber AND d.mgrssn = e.ssn;


-- Questão 17
SELECT p.pname, e.fname
FROM project AS p, employee AS e
WHERE p.dnum = e.dno;


-- Questão 18
SELECT e.fname, d.dependent_name, d.relationship
FROM employee AS e, dependent as d, project as p
WHERE e.ssn = d.essn AND e.dno = p.dnum AND p.pnumber = 91;
