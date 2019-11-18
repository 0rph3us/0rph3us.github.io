---
title: "SQL Für Fortgeschrittene Teil 2"
date: 2019-11-17T14:27:03+01:00
description:
categories:
 - Datenbank
tags:
 - PostgreSQL
featured_image:
author: ""
---

Hintergrund des heutigen Beitrags ist die Migaration einer [Access]-Anwendung/*Datenbank* in eine Webanwendung.
Da ich ein *fauler* Mensch bin, wollte ich es mir einfach machen und so wenig Code wie möglich schreiben. In der
Access-Anwendung gab es auch noch einiges an Visual Basic-Code[^1]. Die Anwendung soll [MAC-Adressen] aus einen
gewissen Block verwalten. Es gibt die folgenden Anforderungen:

* Adressen werden in Bereichen verwaltet
* es dürfen keine Adressen doppelt vergeben werden
* Bestimmung der freien und verwendeten Adressen
* Analyse, ob die Adressen lückenlos vergeben wurden
* Migartion der alten Daten
* MAC Adressen müssen in dem Bereich von FE:EB:CC:00:00:00 bis FE:EB:CC:FF:FF:FF

Diese Anforderungen sahen für mich so aus, dass man sie direkt in PostgreSQL implementieren kann. Als Backend habe
ich [PostgREST] verwendet. Damit wir automatisch eine [RESTful] API bereit gestellt. Dieses API kann von einem
JavaScript-Framework wie [Vue.js] benutzt werden, um ein Frontend zu bauen. In diesem Artikel werde ich nur die
Datenbank beleuchten. Beim Frontend hat mich Daniel Kühn unterstützt.

## Tabelle

{{< highlight sql >}}
CREATE ROLE web_anon;

CREATE TABLE IF NOT EXISTS address_range (
  id           SERIAL,
  date         TIMESTAMP WITH TIME ZONE,
  mac_range    INT8RANGE CHECK (mac_range <@ INT8RANGE('x0000FEEBCC000000'::BIT(64)::BIGINT, 'x0000FEEBCCFFFFFF'::BIT(64)::BIGINT, '[]')) NOT NULL,
  assigned_by  TEXT NOT NULL,
  comment      TEXT,
  EXCLUDE USING GIST (mac_range WITH &&)
);
{{< /highlight >}}

Als erstes wird die Rolle `web_anon` angelegt. PostgREST wirde dieses Nutzer nutzen, um mit der Datenbank zu arbeiten. Dadurch ist
es möglich, dass man bestimmte Tabellen und Funktionen für die API nicht sicherbar sind.

Die Idee hinter Tabelle `address_range` ist, dass nur der vergebene Bereich gespeichert wird. MAC Adressen sind 48 Bit lang, deswegen
können wir vollständig in einem 64 Bit Integer speichern. Die Bedingung der Spalte `mac_range` prüft, dass der Bereich der Mac-Adressen
eingehalten wird. Die `EXCLUDE` Bedingung stellt sicher, dass die Spalte `mac_range` keine Überlappungen hat. Die Operatoren `<@` und `&&`
sind auch in der [Dokumentation] gut erklärt. Man kann mit dieser Tabelle raltiv einfach Bereiche von MAC Adressen verwalten, sicherstellen,
dass keine doppelt vergeben wird und das der Bereich eingehalten wird.

## Hinzufügen

Da die Tabelle für den Nutzer `web_anon` nicht sichtbar ist, werden neue Datensätze über die Funktion `add_mac_range` hinzugefügt. Sie
ist auch eine Abstraktion und kümmert sich um alles. Als Parameter benötigt sie insbesondere die Anzahl der MAC Adressen. Als Ergebnis
bekommt man einen Bereich von MAC Adressen zurück.

{{< highlight sql >}}
CREATE FUNCTION  add_mac_range (assigned_by TEXT, comment TEXT, number_of_macs INT)
  RETURNS TABLE (
    first_mac MACADDR, last_mac MACADDR
  )
  AS $BODY$
DECLARE
  result_range INT8RANGE;
BEGIN
  INSERT INTO address_range (date, mac_range, assigned_by, comment)
  VALUES
  (
    now(),
    (
      SELECT
        INT8RANGE(
          max(upper(mac_range)),                  -- first address of new range
          max(upper(mac_range)) + number_of_macs, -- last address of new range
          '[)'                                    -- half open range
        )
      FROM
        address_range
    ),
    assigned_by,
    comment
  )
  RETURNING
    mac_range INTO result_range;
  
  RETURN QUERY
    SELECT
      to_hex(lower(result_range))::MACADDR AS "first_mac",
      to_hex(upper(result_range) - 1)::MACADDR AS "last_mac";
END;
$BODY$
LANGUAGE plpgsql
SECURITY DEFINER;
{{< /highlight >}}

Im `SELECT` wird der neue Bereich bestimmt. Die erste Adresse, ist die obere Grenze der letzten Range[^2]. Es muss bedacht werden,
dass in PostgreSQL die Range-Typen mit einem [halboffenen Intervall] arbeiten. Das Intervall, welches eingefügt wird, wird beim
`INSERT` zurück gegeben. Anschließend wird es in *lesbare* und formatiere MAC Adressen umgewandelt. Dazu wird der Datentyp [MACADDR]
verwendet. Die Funktion fügt nur Werte ein, wenn ein Datensatz in der Tabelle ist. Man kann sie aber so bauen, dass sie auch mit
leeren Tabellen zurecht kommt. Eine weitere Fehlerbehandlung ist nicht nötig. Wenn `number_of_macs` negativ ist, dann erhalät man einen
Fehler von PostgreSQL, weil die rechte Grenze der Range kleiner als die Linke ist. Falls man 0 angibt fügt man eine leere Range hinzu.

## Anzeigen

{{< highlight sql >}}
CREATE VIEW mac_view AS
SELECT
  id,
  to_hex(lower(mac_range))::MACADDR AS "first_mac",
  to_hex(upper(mac_range) - 1)::MACADDR AS "last_mac",
  upper(mac_range) - lower(mac_range) "number_of_macs",
  to_char(date, 'YYYY-MM-DD HH24:MI') AS "date",
  assigned_by,
  comment
FROM
  address_range
;
GRANT SELECT ON mac_view TO web_anon;
{{< /highlight >}}

Diese View zeigt die vergebenen MAC Adressen an. Die erste Adressen ist die untere Schranke und die letzte Adresse ist
die obere Schranke. Die Anzahl ergibt sich auf `oberer Schranke - unterer Schranke`. Das Datum wird so formatiert, dass man
es im Frontend gut verarbeiten kann.

## Kennzahlen

{{< highlight sql >}}
CREATE VIEW stats AS
SELECT
  max(upper(mac_range)) - min(lower(mac_range)) AS "assigned_macs",
  ('x0000FEEBCCFFFFFF'::BIT(64)::BIGINT - max(upper(mac_range)))::BIGINT + 1 AS "free_macs"
FROM
  address_range;
GRANT SELECT ON stats TO web_anon;
{{< /highlight >}}

In der View `stats` werden ganz simple die Anzahl der vergeben und freien Adressen bestimmt. Es wird davon ausgegangen, dass sich
keine Lücken zwischen den Ranges befinden. Falls sich Lücken darin befinden, dann kann man sie mit der Funktion `add_mac_range`
nicht füllen.

## Lücken finden

{{< highlight sql >}}
CREATE VIEW gap_view AS
SELECT
  to_hex(lower(gaps.gap_range))::MACADDR  AS "first_mac",
  to_hex(upper(gaps.gap_range) - 1)::MACADDR AS "last_mac",
  upper(gaps.gap_range) - lower(gaps.gap_range) AS "size_of_gab"
FROM
  (
    SELECT
      INT8RANGE(
        lower(nr.mac_range),
        upper(nr.next_nr)
      ) - nr.mac_range - nr.next_nr AS "gap_range"
    FROM
      (
        SELECT
          mac_range,
          LEAD(mac_range) OVER (ORDER BY mac_range) AS next_nr
        FROM
          address_range
        WHERE
          isempty(mac_range) = False
      ) nr
    WHERE
      nr.mac_range -|- nr.next_nr = FALSE
  ) gaps
;
GRANT SELECT ON gap_view TO web_anon;
{{< /highlight >}}

Wir fangen mit dem ganz inneren `SELECT` an. Es werden alle leeren Ranges über die `WHERE`-Klausel ausgeschlossen. Diese können per Definition
keine Lücken verursachen. `LEAD` ist eine [Window-Funktion]. Dadurch bekommt man die nächste Zeile, sortiert nach `mac_range`. Dieses `SELECT`
gibt also die Range der aktuellen Zeile und die Range der nächsten Zeile zurück. Im mittleren `SELECT` werden alle Ranges herausgefiltert, welche
nicht adjazent[^3] sind. Wenn 2 Intervalle nicht adjazent sind, dann haben sie eine Lücke. Ihre Schnittmenge muss leer sein, denn die `EXCLUDE`
Bedingung in der Tabelle `mac_view` ist für alle Datensätze erfüllt. Die Berechnung der eigentlichen Lücke ist einfach: Man bestimmt die Vereinigung
der beiden Intervalle und zieht sie danach wieder ab. Zum Schluss erhält man die Lücke. Im äußeren `SELECT` werden die Lücken nur noch einmal,
zur besseren lebarkeit, aufgearbeitet. Es gibt die Größe der Lücke, sowie die erste und letzte MAC Adresse zurück.

## Fazit

Man kann mit SQL mehr als `SELECT *` machen und auch einiges an Anwendungslogik damit erschlagen. PostgreSQL ist verdammt schnell, insbesondere bei
komplexen Anfragen. Ich finde den hier vorgestellten Anwendungsfall sehr elegant umgesetzt. Man ist wahrscheinlich nicht schneller, wenn man ein
Problem mit SQL löst, anstatt in einer Hochsprache. Durch den wenigen Code ist aber ein Review einfacher.
Ich halte es nicht für zweckmäßig, wenn man Daten Gigabyteweise durch das Netzwerk schickt. So werden die Daten dort verarbeitet wo sie sind. Da
sich viele Datenbanken langweilen, können die CPUs auch mal etwas berechnen.

Es werden wahrscheinlich nie viele mit MAC Adressen zu tun haben, aber der Beitrag soll eine Inspiration sein, dass man mit SQL viel mehr machen
kann.

[^1]: Keine Ahnung wie die Sprache richtig heißt, meine Leser wissen was ich meine :D
[^2]: mathematisch ist es ein Intervall. Ich versuche es überall Range zu nennen, weil der Datentyp so heißt.
[^3]: obere Schranke des kleinern halboffenen Intervall ist die untere Schranke des größeren halboffenen Intervalls
[Vue.js]: https://vuejs.org/
[Access]: https://de.wikipedia.org/wiki/Microsoft_Access
[RESTful]: https://de.wikipedia.org/wiki/Representational_State_Transfer
[MACADDR]: https://www.postgresql.org/docs/11/datatype-net-types.html#DATATYPE-MACADDR
[PostgREST]: http://postgrest.org/en/v6.0/
[MAC-Adressen]:https://de.wikipedia.org/wiki/MAC-Adresse
[Dokumentation]: https://www.postgresql.org/docs/11/functions-range.html#RANGE-OPERATORS-TABLE
[Window-Funktion]: https://www.postgresql.org/docs/11/functions-window.html
[halboffenen Interval]: https://www.postgresql.org/docs/11/rangetypes.html#RANGETYPES-INCLUSIVITY
