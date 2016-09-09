---
title: noSQL Datenbanken
author: Michael Rennecke
type: post
date: 2011-05-18T20:48:39+00:00
url: /tools/nosql-datenbanken
categories:
  - Linux
  - Tools
tags:
  - Datenbank
  - hpc
  - mongoDB
  - noSQL
  - performance

---
Ich arbeite inzwischen bei [Unister][1] als [Junior Systemarchitekt][2]. Zu meinen ersten Aufgaben hat gezählt eine Architektur für eine eine Datenbank zu schaffen, welche mit sehr hohen Schreibaufkommen zurecht kommt. Als Datenbank haben wir [mongoDB][3] benutzt. Dabei handelt es sich um eine [noSQL][4]-Datenbank. Diese Dazenbanken haben kein festes Datenbankschema. 

Die ersten Ergebnisse waren sehr erschütternd. Die Schreibperformence war einfach zu gering. Da man bei [mongoDB][3] nichts konfigurieren kann (Im Vergleich zu klassischen Datenbanken, wie MySQL oder PostgreSQL) war ich erst einmal ratlos. Das ganze konnte mit Clustern nicht verbessert werden. Eine genaue Untersuchung der Applikation hat ergeben, dass die Daten synchron und damit blockierend geschrieben wurden. Nachdem die Inserts nicht blockierend und in Batches umgesetzt wurden konnte schon ein Performancesprung festgestellt werden. Das konnte weiter verbessert werden, als wir die einzufügenden Daten in der Applikation nach dem Index vorsortiert eingefügt haben. Die Ursache liegt darin, das die Datenbank den Batch schneller abarbeiten kann und weniger Operationen auf dem Index nötig sind. 

Zum Schluss möchte ich noch ein paar Worte zum Clustern von [mongoDB][3] verlieren. Es wird alles mitgebracht um schnell einen Cluster aufzusetzten. Ich habe es es leider geschafft, durch den Absturz von einem Knoten, den gesamten Cluster zu zerstören. Also sollte man bei Wichtigen Daten für Redundanz im Cluster sorgen. Es gibt auch viele Mittel in mongoDB um diese Redundanz zu erreichen.

 [1]: http://www.unister.de/
 [2]: http://0rpheus.net/privat/junior-system-architekt
 [3]: http://www.mongodb.org/
 [4]: http://nosql-database.org/