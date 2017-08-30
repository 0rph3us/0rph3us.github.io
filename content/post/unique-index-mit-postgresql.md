+++
title = "Unique Index mit PostgreSQL"
date = "2017-08-30T20:40:02+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["PostgreSQL"  ]
categories = ["Datenbank"]
+++

Das ist wieder ein Beitrag zum Thema: Ich lerne [PostgreSQL]. Wobei (fast) alle relationalen
Datenbanken das Verhalten haben, welches ich beschreibe.

Man kann ein `Unique Index` über mehrere Spalten von einer Tabelle definieren, dann sichergestellt,
dass es keine doppelten Tupel gibt.

> [UNIQUE]
>
> Causes the system to check for duplicate values in the table when the index is created (if data already exist) and each time data is added. Attempts to insert or update data which would result in duplicate entries will generate an error.


Ich habe eine Tabelle, welche Key-Value-Paare für Benutzer[^1] speichert. Wenn die `user_id` `NULL` ist, dann
handelt es sich um eine globale Konfiguration. Durch das Hinzufügen eines Unique Indexes, soll sichergestellt
werden, dass der Key immer global eindeutig bzw. eindeutig für einen Nutzer ist.

{{< highlight sql >}}
CREATE TABLE conf (
  id SERIAL PRIMARY KEY,
  user_id INT,
  key VARCHAR NOT NULL,
  value VARCHAR
);
CREATE UNIQUE INDEX ON conf (user_id, key);
{{< /highlight >}}

```
test=# \d conf
                               Table "public.conf"
 Column  |       Type        |                     Modifiers                     
---------+-------------------+---------------------------------------------------
 id      | integer           | not null default nextval('conf_id_seq'::regclass)
 user_id | integer           | 
 key     | character varying | not null
 value   | character varying | 
Indexes:
    "conf_pkey" PRIMARY KEY, btree (id)
    "conf_user_id_key_idx" UNIQUE, btree (user_id, key)
```

Was passiert, wenn man nun ein paar globale Konfigurationen hinzufügt? 

{{< highlight sql >}}
INSERT INTO conf
  (user_id, key, value) 
  VALUES 
  (NULL, 'ohoh', 'peng'), (NULL, 'ohoh', 'peng'), (NULL, 'ohoh', 'peng');
SELECT * FROM conf;
{{< /highlight >}}

```
 id | user_id | key  | value 
----+---------+------+-------
  1 |         | ohoh | peng
  2 |         | ohoh | peng
  3 |         | ohoh | peng
(3 rows)
```

Wie man sieht, wurde der Key mit dem Namen *ohoh* dreimal hinzugefügt. Das ganze ist kein Fehler,
sondern ein [dokumentieres Verhalten]:

> ... Null values are not considered equal. ...

Das heißt, *NULL* ist immer ungleich *NULL*. Aus diesem Grund sind die 3 Datensätze verschieden.
In vielen Fällen möchte man dieses Verhalten nicht. Die Lösung ist, dass man einen zusätzlichen
Index anlegt. Damit man diesen anlegen kann, muss man erst einmal alle Dublikate löschen.

{{< highlight sql >}}
DELETE FROM conf WHERE 
  id NOT IN ( SELECT MIN(id) FROM conf WHERE key = 'ohoh' ) 
  AND key = 'ohoh';
{{< /highlight >}}

Nun kann der zusätzliche Index angelegt werden. Dieser ist eindeutig für `key`, wenn `user_id`
den Wert `NULL` hat.

{{< highlight sql >}}
CREATE UNIQUE INDEX ON conf (key) WHERE user_id IS NULL;
{{< /highlight >}}

Falls man jetzt wieder doppelte globale *Keys* anlegen möchte, gibt es einen Fehler.

```
ERROR:  duplicate key value violates unique constraint "conf_key_idx"
DETAIL:  Key (key)=(ohoh) already exists.
```

In meinen Fall darf `key` nicht `NULL` sein. Wenn der Fall auftritt, dass `key` und
`user_id` den Wert `NULL` annehmen können, dann muss man noch einen dritten Index anlegen.
Dieser prüft, ob `user_id` eindeutig ist, wenn der `key` `NULL` ist.

{{< highlight sql >}}
ALTER TABLE conf ALTER key DROP NOT NULL;
CREATE UNIQUE INDEX ON conf (user_id) WHERE key IS NULL;
{{< /highlight >}}


## Schluss

Das beschriebene Verhalten ist in meinen Augen konsistent. Der SQL-Standart sagt aus, dass
`NULL = NULL` `NULL` ergibt und nicht `True`. In Abfragen sind die meisten bestimmt schon
auf diese *Problematik* gestoßen. Da muss man mit `IS NULL` vergleichen, um einen Wahrheitswert
zu bekommen.

Bei einem Index denken wahrscheinlich die wenigen, wie auch ich, an `NULL`-Werte. Nachdem man
diesen Artikel gelesen hat, sollte man beim Anlegen des nächsten Index nachdenken, ob `NULL`-Werte
vorkommen können.


[PostgreSQL]: https://de.wikipedia.org/wiki/PostgreSQL
[UNIQUE]: https://www.postgresql.org/docs/9.6/static/sql-createindex.html
[dokumentieres Verhalten]: https://www.postgresql.org/docs/9.6/static/indexes-unique.html
[^1]: in der richtigen Tabelle gibt es natürlich eine entsprechende Fremdschlüssel-Constraint