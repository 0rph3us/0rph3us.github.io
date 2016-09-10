---
title: BigData mit Hypertable
author: Michael Rennecke
type: post
date: 2011-12-11T16:50:31+00:00
categories:
  - Datenbank
tags:
  - BigData
  - Hypertable
  - noSQL

---
Ich beschäftige mich beruflich gerade mit [Big Data][1] und deren Verarbeitung. Ich habe nur ein Problem, dass ich keine _gute_ Hardware dafür habe, oder gar ein ganzes Rechenzentrum, wie Fratzenbuch oder google. Bei der Suche nach einem Lösungsansatz für mein Problem bin ich auf [Hypertable][2] gestoßen.

Wenn es um BigData geht, wird oft [HBase][3] genannt. In keinen kleinen Prototypen, war HBase in einer VM gefühlt viel langsamer als Hypertable. Deswegen habe ich mich weiter mit Hypertable und nicht mit HBase beschäftigt. 

[Hypertable][2] ist eine verteilte Datenbank, welche vom Prinzip her [spaltenorientiert][4] ist. Dieses Prinzip kann mit Hilfe der [Access Groups][5] aufweichen. Man sollte auf keinen Fall versuchen aus Hypertable eine zeilenorientierte Datenbank zu machen. 

Die aktuelle Zielarchitektur sieht wie folgt aus: Auf 12 Rechnern läuft [HDFS][6] von [Hadoop][7]. Auf 11 von diesen Rechnern läuft eine RangeServer für Hypertable. Dieser ist auf 2 GB RAM Verbrauch limitiert, weiterhin habe ich einen Hypertable Master. In meiner Testdatenbank habe ich 15,3 Millarden Datensätze. Auf dieser Datenmenge dauert ein random-Zugriff im Durchschnitt 200ms, wobei die worstcase Zeit einige Sekunden beträgt. Ich bin zumindest begeistert, dass ich derartig große Datenmengen auf schlechter Commodity Hardware handeln kann. Ich bin mir sicher, dass ich mit der zur Verfügung stehenden Hardware noch mehr haus holen kann.

 [1]: http://de.wikipedia.org/wiki/Big_Data
 [2]: http://hypertable.org/
 [3]: http://hbase.apache.org/
 [4]: http://de.wikipedia.org/wiki/Spaltenorientierte_Datenbank
 [5]: http://code.google.com/p/hypertable/wiki/ArchitecturalOverview
 [6]: http://hadoop.apache.org/hdfs/
 [7]: http://hadoop.apache.org/