---
title: Letzte Rettung von MySQL
author: Michael Rennecke
type: post
date: 2011-08-08T20:35:44+00:00
categories:
  - Datenbank
  - Linux
  - Tools
tags:
  - MySQL
  - recovery

---
Ich hatte heute wieder Spaß mit [MySQL][1]. Die [InnoDB][2] Tabelle einer Datenbank hat sich erfolgreich selbst zerstört. Das hat sich dahingehend geäußert, dass sich [MySQL][1] immer wieder neu gestartet hat. [MySQL][1] war leider nicht in der Lage die betroffene Tabelle selbst wieder her zu stellen. 

Mit Hilfe von [innodb\_force\_recovery][3] kann man MySQL dazu bringen, dass es Tabellen wieder her stellt. Diese Option schreibt man einfach in die <tt>my.cnf</tt>. Er kann die Werte von 1 bis 6 annehmen. Je höher der Wert ist, desto höher ist die Wahrscheinlichkeit, dass die Tabelle wieder hergestellt werden kann. Aber Achtung: Je größer der Wert ist, desto mehr Daten kann MySQL beim Wiederherstellen zerstören. Es ist deswegen ratsam den Wert inkrementell zu erhöhen, dieses Vorgehen dauert evtl. länger, aber man geht nicht in Gefahr unnötig Daten zu verlieren.

 [1]: http://www.mysql.com/
 [2]: http://www.innodb.com/
 [3]: http://dev.mysql.com/doc/refman/5.0/en/forcing-innodb-recovery.html