---
title: Hadoop Cluster und das Netzwerk
author: Michael Rennecke
type: post
date: 2013-05-28T20:11:20+00:00
url: /hpc/hadoop-cluster-und-das-netzwerk
categories:
  - HPC
  - Linux
tags:
  - Architektur
  - Cluster
  - Hadoop
  - Hardware
  - Infiniband
  - Linux
  - Netzwerk

---
Ich habe mich heute wieder mit der Architektur von Hadoop-Clustern beschäftigt. Der Softwarestack ist relativ unspektakulär: Linux -> Java -> [Hadoop][1]. Beim Hardware-Stack scheiden sich etwas die Geister. Ich habe immer noch mit dem Gerücht zu kämpfen, dass man für Hadoop _Schrott-Rechner_ verwenden kann. Hier wird der Begriff _Commodity Hardware_ etwas falsch interpretiert. Commodity Hardware bezeichnet im Hadoop-Kontext keine spezielle Hardware verwendet wird. Große Datenbankensysteme verwenden in der Regel sehr spezielle Hardware.

Ich beobachte einen Trend, dass es immer mehr [Appliances][2] gibt, welche schon recht spezielle Netzwerktechnik verwenden, welche man ehr im klassischen HPC mit MPI vermuten würde. Wenn man sich die folgende Frage stellt, dann kommt man schnell selbst zu der Erkenntnis, dass man auch im Hadoop-Umfeld sehr spezielle Hardware benötigt.

Ich möchte das ganze einmal an einem Beispiel vorführen: Wenn man in einem Hadoop-Knoten 12 3TB große SAS Platten verbaut, dann ist es nicht unrealistisch, dass man 120 MB/s von jeder Platte lesen bzw. 100 MB/s schreiben kann und das über einen längeren Zeitraum. Daraus resultiert eine gesamte Bandbreite von 1440 MB/s bzw. 1200 MB/s. Wenn man sich diese Zahlen ansieht, dann ergibt es durchaus Sinn 2 10 GBit-Interfaces pro Node zu haben. Wenn man von komprimierten Daten im hdfs ausgeht, welche unkomprimiert versendet werden, dann können auch 2 QDR [Infiniband][3]-Interfaces (40 GBit/s) Sinn. Es gibt durchaus Anbieter, welche auf Infiniband setzten.

Durch die Administration und den Ausbau das Hadoop-Clusters meines Arbeitgebers kann ich bestätigen, dass die Daten nicht so lokal bleiben, wie man es sich das wünschen würde. Das ganze kann sich verschärfen, wenn man im Cluster noch eine Datenbank, wie [Hypertable][4] betreibt.

 [1]: http://hadoop.apache.org/
 [2]: http://de.wikipedia.org/wiki/Appliance
 [3]: http://de.wikipedia.org/wiki/InfiniBand
 [4]: http://hypertable.com/