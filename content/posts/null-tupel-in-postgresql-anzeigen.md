+++
title = "NULL Tupel in Postgresql Anzeigen"
date = "2017-09-25T21:57:27+02:00"
hide_authorbox = false
disable_comments = false
draft = false
categories = ["Datenbanken"]
tags = ["PostgreSQL"]
+++

Ich habe mich in den letzten Wochen immer wieder aufgeregt, dass PostgreSQL `NULL`-Tupel
auf der Konsole nicht anzeigt bzw. man kann `NULL`:


    postgres=# SELECT NULL AS "<null>", '' AS "empty string";
     <null> | empty string 
    --------+--------------
            | 
    (1 row)



Man kann mittel `\pset` die `NULL`-Tupel auch explizit anzeigen:

    postgres=# \pset null '<null>'
    Null display is "<null>".
    postgres=# SELECT NULL AS "<null>", '' AS "empty string";
     <null> | empty string 
    --------+--------------
     <null> | 
    (1 row)
    
    postgres=#



