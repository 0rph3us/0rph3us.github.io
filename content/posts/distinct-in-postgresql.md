+++
title = "DISTINCT in PostgreSQL"
date = "2017-08-25T21:41:13+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["PostgreSQL"  ]
categories = ["Datenbank"]
+++

Ich habe sehr lange ausschließlich [MySQL] benutzt. Mein Chef bei busnetworx, wollte
unbedingt [PostgreSQL] einsetzten. Aus diesem Grund habe ich mir PostgreSQL genauer
angesehen. Das Schlüsselwort `DISTINCT` ist in PostgreSQL *mächtiger* als in MySQL
und ich möchte es im einmal erklären.

## SELECT DISTINCT

Ich habe eine einfache Mitarbeitertabelle angelegt, wie man sie in vielen Tutorials findet.
Die Testdaten habe ich mit [mockaroo] generiert.

{{< highlight text >}}
test=# \d employee
                                  Table "public.employee"
   Column   |         Type          |                       Modifiers                       
------------+-----------------------+-------------------------------------------------------
 id         | integer               | not null default nextval('employee_id_seq'::regclass)
 first_name | character varying(50) | 
 name       | character varying(50) | 
 department | character varying(50) | 
 salary     | integer               | 
Indexes:
    "employee_pkey" PRIMARY KEY, btree (id)

test=# SELECT * FROM employee limit 3;
 id | first_name |  name   | department  | salary 
----+------------+---------+-------------+--------
  1 | Francklin  | Gurr    | Services    |   4207
  2 | Cecily     | Churm   | Engineering |   3728
  3 | King       | Tribell | Training    |   3780
(3 rows)
{{< /highlight >}}

### Was macht DISTINCT

> SELECT DISTINCT entfernt Duplikate aus der Ergebnismenge.

So erhält man eine Liste mit allen Abteilungen:

{{< highlight sql >}}
SELECT DISTINCT department FROM employee;
{{< /highlight >}}

{{< highlight text >}}
        department        
--------------------------
 Engineering
 Training
 Business Development
 Sales
 Marketing
 Accounting
 Services
 Support
 Research and Development
 Legal
 Product Management
 Human Resources
(12 rows)
{{< /highlight >}}

Mir ist durchaus bewusst, dass das Schema nit normalisiert ist. Aber das Beispiel
sollte sehr einfach sein, um das Verhalten von `DISTINCT` zu zeigen.

In diesem Beispiel erhält das identische Ergebnis, wenn man `GROUP BY` benutzt.
`GROUP BY` kann im Gegegsatz zu `DISTINCT` potenziell einen Index nutzen, das ist 
auf großen Tabellen von Vorteil.

{{< highlight sql >}}
SELECT department FROM employee GROUP BY department;
{{< /highlight >}}

## DISTINCT ON

Nun möchte man wissen, welcher Mitarbeiter das höchste Gehalt in seine Anteilung hat.
Dazu wird in einer Subquery das höchste Gehalt der jeweiligen Abteilungen bestimmt.
Danach sucht man alle Mitarbeiter, welche dieses Gehalt in der jeweiligen Abteilung
haben.

{{< highlight sql >}}
SELECT  
  *
FROM
  employee
WHERE
  (department, salary) IN (
    SELECT 
      department,
      MAX(salary)
    FROM
      employee
    GROUP BY
      department
    )
ORDER BY
    department;
{{< /highlight >}}

{{< highlight text >}}
  id  | first_name |   name    |        department        | salary 
------+------------+-----------+--------------------------+--------
 4841 | Caresse    | Simonian  | Accounting               |   9971
 4117 | Hedda      | Whifen    | Business Development     |   9936
 4433 | Delmar     | Pieper    | Engineering              |   9993
 5239 | Pebrook    | Roycraft  | Human Resources          |   9991
 4336 | Murry      | Cadwaladr | Legal                    |   9974
 5840 | Hayes      | Levee     | Marketing                |  10000
 3656 | Geno       | Culmer    | Marketing                |  10000
 3075 | Harland    | Dendle    | Product Management       |   9917
 5599 | Kayne      | Oppy      | Research and Development |   9984
 4065 | Alric      | de Zamora | Sales                    |   9993
 5178 | Brunhilde  | Glanton   | Services                 |   9995
 5988 | Grier      | Gotcliffe | Support                  |   9984
 5920 | Gray       | Bizley    | Training                 |   9955
(13 rows)
{{< /highlight >}}

Wenn 2 Mitarbeiter das höchste Gehalt einer Abteilung haben, dann werden
beide ausgegeben. So ist es bei der Abteilung Marketing der Fall.

Wenn man nur ein Datensatz pro Abteilung haben möcht, muss man mit den
[Window Functions] arbeiten. Ich habe mit diesen Funktionen noch
nie gearbeitet, ich kenne sie nur von Stackoverflow und der Dokumentation.

{{< highlight sql >}}
WITH ranked_employee AS (
  SELECT 
    ROW_NUMBER() OVER (
        PARTITION BY department ORDER BY salary DESC
      ) AS row,
      *
    FROM 
      employee
)
SELECT
  *
FROM
  ranked_employee
WHERE
  row = 1
ORDER BY 
  department;
{{< /highlight >}}

{{< highlight text >}}
 row |  id  | first_name |   name    |        department        | salary 
-----+------+------------+-----------+--------------------------+--------
   1 | 4841 | Caresse    | Simonian  | Accounting               |   9971
   1 | 4117 | Hedda      | Whifen    | Business Development     |   9936
   1 | 4433 | Delmar     | Pieper    | Engineering              |   9993
   1 | 5239 | Pebrook    | Roycraft  | Human Resources          |   9991
   1 | 4336 | Murry      | Cadwaladr | Legal                    |   9974
   1 | 3656 | Geno       | Culmer    | Marketing                |  10000
   1 | 3075 | Harland    | Dendle    | Product Management       |   9917
   1 | 5599 | Kayne      | Oppy      | Research and Development |   9984
   1 | 4065 | Alric      | de Zamora | Sales                    |   9993
   1 | 5178 | Brunhilde  | Glanton   | Services                 |   9995
   1 | 5988 | Grier      | Gotcliffe | Support                  |   9984
   1 | 5920 | Gray       | Bizley    | Training                 |   9955
(12 rows)
{{< /highlight >}}

Wie man sieht, enthält diese Ausgabe keine Duplikate mehr. In PostgreSQL kann
man diese Anfrage auch sehr elegant mit [DISTINCT ON] schreiben. Das ist aber
nicht Teil des SQL-Standards. Diese Lösung finde ich sehr elegant und einfach.

{{< highlight sql >}}
SELECT DISTINCT ON (department)
  *
FROM
  employee
ORDER BY
  department,
  salary DESC;
{{< /highlight >}}

> SELECT DISTINCT ON ( expression [, ...] ) keeps only the first row of each set of rows where the given expressions evaluate to equal. 

## IS DISTINCT FROM

In diesen Abschnitt wird die folgende Tabelle verwendet:

{{< highlight sql >}}
CREATE TABLE t AS (
  SELECT 1 AS a, 1 AS b UNION ALL
  SELECT 1, 2 UNION ALL
  SELECT NULL, 1 UNION ALL
  SELECT NULL, NULL
);
{{< /highlight >}}

In SQL kann eine Abfrage die 3 verschiedene Ergebisse haben: `TRUE`, `FALSE` und `NULL`.

{{< highlight sql >}}
SELECT
  a,
  b,
  a = b AS equals
FROM
  t;
{{< /highlight >}}

{{< highlight text >}}
  a   |  b   | equals 
------+------+--------
    1 |    1 | t
    1 |    2 | f
 NULL |    1 | NULL
 NULL | NULL | NULL
{{< /highlight >}}

Wie man sieht, kann man in SQL nicht mit `NULL` auf Gleichheit vergleichen. Sowie man mit
`NULL` vergleicht, kommt immer `NULL` heraus. In vielen Fällen möchte man aber trotzdem mit
`NULL` vergleichen und `TRUE` bzw. `FALSE` erhalten. Das funktioniert mit einen komplexen Ausdruck.

{{< highlight sql >}}
SELECT
  a,
  b,
  a = b AS equals,
  (
    (a IS NULL AND b IS NULL) 
    OR
    (a IS NOT NULL AND b IS NOT NULL AND a = b)
  ) AS full_condition
FROM
  t;
{{< /highlight >}}

{{< highlight text >}}
  a   |  b   | equals | full_condition 
------+------+--------+----------------
    1 |    1 | t      | t
    1 |    2 | f      | f
 NULL |    1 | NULL   | f
 NULL | NULL | NULL   | t
{{< /highlight >}}

Der verwendete Ausdruck ist sehr komplex. Die meisten sind wahrscheinlich nicht in der Lage
ihn schnell aufzuschreiben. Im SQL Standard gibt es einen Operator für einen sicheren
Vergleich mit `NULL`.

{{< highlight sql >}}
SELECT
  a,
  b,
  a = b as equal,
  a IS DISTINCT FROM b AS is_distinct_from
FROM
  t;
{{< /highlight >}}

{{< highlight text >}}
  a   |  b   | equal | is_distinct_from 
------+------+-------+------------------
    1 |    1 | t     | f
    1 |    2 | f     | t
 NULL |    1 | NULL  | t
 NULL | NULL | NULL  | f
{{< /highlight >}}

Im [PostgreSQL Wiki] findet die Wertetabellen für `IS DISTINCT FROM`.

## ARRAY_AGG(DISTINCT)

Die Funktion [ARRAY_AGG] verkettet alle Argumente zu einem Array.

{{< highlight sql >}}
SELECT
    department,
    ARRAY_AGG(first_name || ' ' || name) AS employees
FROM
    employee
GROUP BY
    department
ORDER BY
    department;
{{< /highlight >}}

{{< highlight text >}}
     department     |              employees               
--------------------+--------------------------------------
 Accounting         | {"Devlin Klulik"}
 Engineering        | {"Cecily Churm","Nevin Melladew"}
 Legal              | {"Camey Speers","Gottfried Carneck"}
 Product Management | {"Glenda Trout"}
 Services           | {"Francklin Gurr"}
 Training           | {"King Tribell"}
{{< /highlight >}}

Nun sieht man, welche Mitarbeiter in einer Abteilung arbeiten. Man kann auch
`DISTINCT` verwenden, um das höchste Gehalt innerhalb einer Abteilung zu finden.

{{< highlight sql >}}
SELECT
    department,
    ARRAY_AGG(DISTINCT salary) AS salaries
FROM
    employee
GROUP BY
    department
ORDER BY
    department;
{{< /highlight >}}

{{< highlight text >}}
     department     |  salaries   
--------------------+-------------
 Accounting         | {3785}
 Engineering        | {3728,4033}
 Legal              | {3962}
 Product Management | {3982}
 Services           | {4207}
 Training           | {3780}
{{< /highlight >}}

Man sieht, dass die Legal-Abteilung 2 Mitarbeiter hat, aber es git nur ein Gehalt. Daraus folgt,
dass alle Mitarbeiter dasselbe Gehalt haben müssen. Die `ORDER BY department` Befehle, sorgen dafür,
dass die Ausgabe immer gleiche Reihenfolge hat. Sie sind für die Anfragen nicht notwendig.

## Schluss

Ich wollte einmal auf die verschiedenen Verwendungen von `DISTINCT` hinweisen. Auf einige Verwendungen
bin ich erst beim Schreiben des Artikels gestoßen. Was ich mitnehme (und ihr mitnehmen solltet), man
sollte öfter einmal in die Dokumention von PostgreSQL schauen, anstatt umständliches SQL zu schreiben
oder die Daten noch einmal in der Applikation verarbeiten.

[MySQL]: https://de.wikipedia.org/wiki/MySQL
[PostgreSQL]: https://de.wikipedia.org/wiki/PostgreSQL
[mockaroo]: https://www.mockaroo.com/
[Window Functions]: https://www.postgresql.org/docs/current/static/functions-window.html
[DISTINCT ON]: https://www.postgresql.org/docs/current/static/sql-select.html#SQL-DISTINCT
[PostgreSQL Wiki]: https://wiki.postgresql.org/wiki/Is_distinct_from
[ARRAY_AGG]: https://www.postgresql.org/docs/9.5/static/functions-aggregate.html