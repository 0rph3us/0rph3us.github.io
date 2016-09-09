---
title: Wie ärgere ich mein zfs
author: Michael Rennecke
type: post
date: 2010-08-10T15:43:44+00:00
excerpt: |
  <p>
  <a href="http://hub.opensolaris.org/bin/view/Community+Group+zfs/WebHome">zfs</a> hat den Ruf, dass es unzerstörbar ist. Ab und zu hört man, dass User xy sein zfs kaputt bekommen hat und meint, dass <a href="http://hub.opensolaris.org/bin/view/Community+Group+zfs/WebHome">zfs</a> nicht mehr kann als sein altes Dateisystem. Wenn man sich mal ansieht, was der User xy gemacht hat, dann bemerkt der aufmerksame <a href="http://www.systemhelden.com/">Systemheld</a>, dass man mit derartigen Attacken auch Enterprise Storage-Systeme im Wert von mehreren Millionen kaputt bekommt.
  </p>
url: /solaris/wie-argere-ich-mein-zfs
categories:
  - Solaris
tags:
  - hack
  - StorEdge D1000
  - Sun Enterprise
  - zfs

---
[zfs][1] hat den Ruf, dass es unzerstörbar ist. Ab und zu hört man, dass User xy sein zfs kaputt bekommen hat und meint, dass [zfs][1] nicht mehr kann als sein altes Dateisystem. Wenn man sich mal ansieht, was der User xy gemacht hat, dann bemerkt der aufmerksame [Systemheld][2], dass man mit derartigen Attacken auch Enterprise Storage-Systeme im Wert von mehreren Millionen kaputt bekommt. 

#### Was kann zfs nicht

  * im laufenden Betrieb mehr Plattenausfälle verkraften als die zur Verfügung stehende Redundanz
  * im laufenden Betrieb mehr Platten tauschen, als man Redundanz hat
  * mit kaputten Platten laufen

Auch wenn es zu den einen oder andern Punkt abweichende Behauptungen gibt, so muss ich hier ausdrücklich sagen, dass ein solches Verhalten im Allgemeinen Fall **unmöglich** ist. Es **kann** hingegen sein, dass man aus einem zerstörten zpool noch Daten retten kann. Das funktioniert aber nur mit **Glück**. 

#### Was kann zfs

Das folgende habe ich auf einer [Sun Enterprise E450][3] und einem [StorEdge D1000][4] ausprobiert. Im StorEdge hatte ich einen bunten Mix aus 36 GB und 18 GB Platten. Das folgende **sollte** man nicht an einem Produktivsystem ausprobieren! Bei den Testläufen habe ich <tt>/dev/random</tt> bzw. <tt>/dev/zero</tt> in eine Datei, auf den betreffenden zpool geschrieben.

  * Sämtliche Schweinereien mit den Platten gehen, solange man die Redundanz einhält.
  * Die Platten vom Strom trennen oder ein Systemabsturz provozieren. Das zfs überlebt das alles und bleibt konsistent
  * Wenn das System herunter gefahren ist, alle Platten des **nicht exportierten** zpool mischen. Das ärgert das zfs schon sehr,
         
    ich musste meinen zpool exportieren und wieder importieren, damit alles wieder korrekt funktioniert hat
  * Aus einen buten Plattenmix ein raidz bzw. ein raidz2 bauen. Das macht aber aus Performancesicht **keinen** Sinn.
  * Im laufenden Betrieb eine Platte wechseln (wenn man Redundanz hat)

Das war eigenlich alles, was ich mit zfs probiert habe. Ich hatte nicht mehr dumme Ideen. zfs verhält sich auf Dateien anderst als auf echten Devices. Was daran liegt, dass Dateien evtl. noch im Cache sind. Jeder, der die Möglichkeit hat, sollte einige Szenarien vorher einmal ausprobieren.

 [1]: http://hub.opensolaris.org/bin/view/Community+Group+zfs/WebHome
 [2]: http://www.systemhelden.com/
 [3]: http://docs.sun.com/app/docs/coll/e450?l=en
 [4]: http://docs.sun.com/app/docs/coll/d1000-arrray