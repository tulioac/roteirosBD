# Aula 07 - Parte 02

## Operador de comparação `IN`
- Compara `v` com um conjunto de valores `V`

```SQL
SELECT  Pnumber
FROM    PROJECT
WHERE   Pnumber IN 
        ( SELECT Pnumber
          FROM PROJECT, DEPARTAMENT, EMPLOYEE
          WHERE Dnum=Dnumber AND Mgr_ssn=Snn AND Lname='Smith'
        );
```

- Pode-se usar tuplas de valores nas comparações

```SQL
SELECT  Pnumber
FROM    WORKS_ON
WHERE   (Pno, Hours) IN 
        ( SELECT Pno, Hour
          FROM WORKS_ON
          WHERE Essn='123456789'
        );
```

## Operador `ALL`

```SQL
SELECT  Lname, Fname
FROM    EMPLOYEE
WHERE   Salary > ALL
        ( SELECT Salary
          FROM EMPLOYEE
          WHERE Dno=5
        );
```

## Função `EXISTS`
- Verifica se o resultado de uma consulta aninha correlacionada está **vazio ou não**.
- Função **booleana**.

```SQL
SELECT  Fname, Lname
FROM    EMPLOYEE
WHERE   EXISTS
        ( SELECT *
          FROM DEPENDENT
          WHERE Ssn=Essn
        ) 
        AND EXISTS
        ( SELECT *
          FROM Departament
          WHERE Ssn=Mgr_Ssn
        );
```

## Tabela de Junção
- Permite que os usuários especifiquem uma tabela resultante de uma operação de junção na cláusula `FROM` de uma consulta.
- Por padrão o `JOIN` será o `INNER JOIN` (junção interna).

```SQL
SELECT  Fname, Lname, Adress
FROM    (EMPLOYEE JOIN DEPARTAMENT ON Dno=Dnumber)
WHERE   Dname='Research';
```

### NATURAL JOIN
- Junção implícita

```SQL
SELECT  Fname, Lname, Adress
FROM    (EMPLOYEE NATURAL JOIN 
        (DEPARTAMENT AS DEPT (Dname, Dno, Mssn, Msdate)))
WHERE   Dname='Research';
```

> Condição de **junção implícita**: ```EMPLOYEE.Dno = DEPT.Dno```

### OUTER JOIN
- `INNER JOIN` (versus `OUTER JOIN`)
  - Tipo padrão de junção.
  - Uma tupla é incluída no resultado apenas se existir uma tupla correspondente na outra relação (se houver *matching*).

- `LEFT OUTER JOIN`
  - Toda tupla na tabela à esquerda deve aparecer no resultado.
  - Se **não** houver correspondência, são atribuídos valores nulos para os atributos da tabela direita.
  
- `RIGHT OUTER JOIN`
  - Toda tupla na tabela à direita deve aparecer no resultado.
  - Se **não** houver correspondência, são atribuídos valores nulos para os atributos da tabela esquerda.

Exemplo: `LEFT OUTER JOIN`

```SQL
SELECT  E.Lname AS Employee_Name,
        S.Lname AS Supervisor_Name
FROM    Employee AS E LEFT OUTER JOIN EMPLOYEE AS S ON E.Super_ssn=S.Snn;
```

Sintaxe alternativa:

```SQL
SELECT  E.Lname , S.Lname
FROM    EMPLOYEE E, EMPLOYEE S
WHERE   E.Super_ssn += S.Ssn;
```

### Mais sobre `JOIN`
- `FULL OUTER JOIN` - Combina os resultados de `LEFT` e `RIGHT OUTER JOIN`.
- `CROSS JOIN` é utilizado para representar o produto cartesiano (**gera todas as combinações!**).
- Podemos aninhar junções (*Multiway* `JOIN`):

```SQL
SELECT  Pnumber, Dnum, Lname, Address, Bdate
FROM    ((PROJECT JOIN DEPARTMENT ON
        Dnum=Dnumber) JOIN EMPLOYEE ON
        Mgr_ssn=Ssn)
WHERE   Plocation=‘Stafford’;
```

## Funções de Agregação
- Utilizadas para sumarizar informações: `COUNT`, `SUM`, `MAX`, `MIN` e `AVG`

```SQL
SELECT  SUM (Salary), MAX (Salary), MIN (Salary), AVG (Salary)
FROM    EMPLOYEE;
```

- O resultado pode ser representado com novos nomes:

```SQL
SELECT  SUM (Salary) AS Total_Sal, MAX (Salary) AS Highest_Sal, MIN (Salary) AS Lowest_Sal, AVG (Salary) AS Average_Sal
FROM    EMPLOYEE;
```

- Valores `NULL` são descartados quando uma função de agregação é aplicada a uma coluna específica.

Mais exemplos:

```SQL
SELECT  SUM (Salary), MAX (Salary), MIN (Salary), AVG (Salary)
FROM    (EMPLOYEE JOIN DEPARTAMENT ON Dno=Dnumber)
WHERE   Dname='Research';
```

```SQL
SELECT  COUNT (*)
FROM    EMPLOYEE;
```

```SQL
SELECT  COUNT (*)
FROM    EMPLOYEE, DEPARTMENT
WHERE   Dno=Dnumber AND Dname='Research';
```

### Funções de Agregrações em Booleanos
- `SOME` e `ALL`podem ser aplicados como funções em valores booleanos.
- `SOME` retorna `TRUE` se algum elemento da coleção é `TRUE` (similar ao `OR`).
- `ALL` retorna `TRUE` se todos os elementos da coleção são
`TRUE` (similar ao `AND`).

## Agrupamento: Cláusula `GROUP BY`
- **Particiona** a relação em subconjuntos de tuplas.
  - Cria grupos de tuplas antes de sumarizar as informações.
  - Baseia-se em **artibutos de agrupamento**.
  - Aplica a função a cada subgrupo independentemente.
- Cláusula `GROUP BY`
  - Especifica os atributos de agrupamento.
 
- O atributo de agrupamento deve aparecer na cláusula `SELECT`:

```SQL
SELECT    Dno, COUNT (*), AVG (SALARY) 
FROM      EMPLOYEE
GROUP BY  Dno;
```

- Se o atributo de agrupamento tem `NULL` como um valor possível, um grupo separado é criado para o valor nulo.

- `GROUP BY` pode ser aplicado para o resultado de um `JOIN`:

```SQL
SELECT    Pnumber, Pname COUNT (*)
FROM      PROJECT, WORKS_ON
WHERE     Pnumber=Pno
GROUP BY  Pnumber, Pname;
```
