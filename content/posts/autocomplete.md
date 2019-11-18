+++
title = "Autovervollständigung mit PostgreSQL"
date = "2018-02-22T20:50:26+01:00"
author = "Michael Rennecke"
hide_authorbox = true
disable_comments = true
draft = false
categories = ["Datenbank"]
tags = ["PostgreSQL"]
+++

In diesen Artikel wird nicht gezeigt, wie man eine Autovervollständigung
im Frontend umsetzt. Hier geht es ausschließlich um die Realisierung
der Autovervollständigungslogik in der Datenbank.

Wenn mich jemand fragt, wie man eine Autovervollständigung umsetzt, dann
würde ich immer [Elasticsearch] empfehlen. Wenn man schon PostgreSQL als
Datenbank benutzt, dann kann man auch PostgreSQL dafür nutzen. Das hat den
Vorteil, dass der Technologiestack kleiner ist. Es entfällt ggf. die 
Synchronistaion von Elasticsearch mit PostgreSQL.

Eine "einfache" Autovervollständigung basiert auf einen [Präfixbaum][^1]. Dieser
hat den Nachtteil, dass man genau wissen muss, wie der Suchbegriff geschrieben
wird und die Reihenfole muss stimmen, falls man über mehrere Wörter sucht
bzw. vervollständigt.

Wenn man eine Autovervollständigung bzw. Suche auf Kundendaten implentiert, dann
werden die Informationen, in der Regel, in getrennten Feldern gespeichert.
Wenn man nur ein Such- bzw. Eingabefeld hat, dann kann es mitunter ungeschickt
sein alle Felder mit **oder** zu verknüfen. Beispiel man hat in seiner Datenbank
100 Leute, die Peter heißen und davon heißen auch noch 20 Müller. Sowie man
anfängt auf 2 Feldern zu suchen funktioniert eine einfaches **oder** nicht mehr.
Aus diesem Grund ist es evtl. notwendig über den Inhalt von meheren Feldern zu
suchen.

Wenn man ein [n-Gramm]-Index baut, dann spielen die Reihenfolge der Wörter und
Tippfehler keine Rolle mehr. Einen solchen Index kann man mit der [pg_trgm]
Erweiterung auch mit PostgreSQL realisieren. Der große Vorteil ist, dass man
den gleichen Index auch für eine Suche auf den Datensätzen benutzen kann. Ich
habe die Erfahrung gemacht, dass die Suche auf einen 3-Gramm Index in PostgreSQL
für eine Webanwendung und eine Autovervollständigung, welche mit JavaScript im
Frontend relaisiert ist, schnell genug ist. Die Qualität der Suchergebnisse stimmt
auch, in meinen Augen. In der Praxis habe ich diesen Ansatz auf einer Tabelle mit
ca. 260.000 Datensätzen im Einsatz.

## Beispiel

An diesem Beispiel möchte ich zeigen, wie man so etwas mit PostgreSQL umsetzen kann.

Als erstes erzeugt man eine Tabelle `customer` und befüllt sie mit Daten. Man kann sich
Demodaten schnell mit [mockaroo] erzeugen. Diese sind zwar nicht gut, aber man kann so
das Prinzip sehen.

{{< highlight sql >}}
-- is needed for gin_trgm_ops
CREATE EXTENSION IF NOT EXISTS pg_trgm;

create table customer (
	id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	gender VARCHAR(50),
	city VARCHAR(50),
	street VARCHAR(50)
);
{{< /highlight >}}

Wenn die Tabelle, wie oben erzeugt wurde und Daten eingefügt sind, dann erstellt man 
die Spalte `autocomplete` und legt einen Index darauf an. In einer praktischen Anwendung
muss man diese Spalte über Trigger immer aktualisieren, wenn sich `first_name`, `last_name`
oder `city` ändern. Das kann man auch in der Anwendung machen.

{{< highlight sql >}}
-- add column autocomplete in table customer
ALTER TABLE customer ADD COLUMN IF NOT EXISTS autocomplete TEXT;

-- first_name, last_name and city -> copy into column autocomplete
UPDATE customer SET autocomplete = concat_ws(' ', first_name, last_name, city) WHERE autocomplete IS NULL;

-- add trigram index on column autocomplete in table customer
CREATE INDEX IF NOT EXISTS customer_autocomplete_idx ON customer USING GIN(autocomplete gin_trgm_ops);
{{< /highlight >}}

Als nächstes legt man ein prepared Statement an bzw. man nutzt nur die Anfrage. Das prepared Statement hat
den Vorteil, dass man der Konsole bessere spielen kann. Die verwendeten Operatoren sind in der [Dokumention]
beschrieben.

{{< highlight sql >}}
PREPARE search (text, int) AS
    SELECT
        word_similarity($1, autocomplete) AS similarity,
        autocomplete <-> $1 AS distance,
        *
    FROM
        customer
    WHERE
        $1 <% autocomplete
    ORDER BY
        similarity DESC, autocomplete <-> $1
    LIMIT $2;
{{< /highlight >}}

Im prepared Statement ist `$1` die Suchphrase und `$2` die Anzahl der
Zeilen, die zurückgegeben werden.

Die Anfrage ist im Grunde genommen ganz einfach. Es werden die Ähnlichkeit,
Distanz and alle Spalten der Tabelle zurück gegeben. Die Bedingung filtert
alle Zeilen heraus, welche eine "ähnlich" zur Suchphrase sind. Bei mir ist
es oft vorgekommen, dass sehr viele Zeilen die gleiche Ähnlichkeit haben.
Aus diesem Grund sortiere ich nach der Ähnlichkeit aufsteigend und nach der
Distanz absteigend. Den Zusammenhang zwischen similarity (`word_similarity`) 
und distance (`<->`) kann man in der [pg_trgm] Dokumentation nachlesen.


Man kann das prepared Statement einfach ausführen und mit verschiedenen
Suchphrasen herumspielen.

{{< highlight sql >}}
EXECUTE search('gibb', 2);
{{< /highlight >}}

## Optimierung

Auf die Spalte `autocomplete` kann man in diesen Fall auch verzichten.
Dadruch kann man etwas Speicherplatz sparen. Dadurch kann es passieren,
dass die Anfrage etwas langsamer ist. Auf der anderen Seite hat man
somit keine Probleme beim Update bzw. einfügen von Datensätzen.

{{< highlight sql >}}
DROP INDEX customer_autocomplete_idx;
ALTER TABLE customer DROP COLUMN autocomplete;

-- create a new index on columns first_name, last_name and city
CREATE INDEX IF NOT EXISTS customer_autocomplete_idx ON customer USING GIN((first_name || ' ' || last_name || ' ' || city) gin_trgm_ops);
{{< /highlight >}}

{{< highlight sql >}}
DEALLOCATE search;
PREPARE search (text, int) AS
    SELECT
        word_similarity($1, (first_name || ' ' || last_name || ' ' || city)) AS similarity,
        (first_name || ' ' || last_name || ' ' || city) <-> $1 AS distance,
        *
    FROM
        customer
    WHERE
        $1 <% (first_name || ' ' || last_name || ' ' || city)
    ORDER BY
        similarity DESC, (first_name || ' ' || last_name || ' ' || city) <-> $1
    LIMIT $2;
{{< /highlight >}}


[Elasticsearch]: https://www.elastic.co/de/products/elasticsearch
[Präfixbaum]: https://de.wikipedia.org/wiki/Trie
[n-Gramm]: https://de.wikipedia.org/wiki/N-Gramm
[pg_trgm]: https://www.postgresql.org/docs/10/static/pgtrgm.html
[mockaroo]: https://www.mockaroo.com/
[Dokumention]: https://www.postgresql.org/docs/10/static/pgtrgm.html#PGTRGM-OP-TABLE

[^1]: Es gibt auch viele andere Ansätze, auf die ich nicht eingehen möchte.
