---
title: Mehrkern oder nicht Mehrkern, dass ist die Frage
author: Michael Rennecke
type: post
date: 2010-06-21T18:25:59+00:00
categories:
  - HPC
tags:
  - C++
  - Cache
  - Mehrkern

---
Ich habe inzwischen ein paar Experimente mit verschiedenen Mehrkernarchitekturen gemacht. Ich habe verschiende Algorithmen mit [Cilk++][1] implementiert. Dabei kam es zu interessanten Ergebnissen. Ich hatte von superlinearen Speedup bis zu einem Speedup unter 1 alles. Aber woran liegt das, dass die Ergebnisse so weit auseinander gehen? Die schlechten Ergebnisse habe ich auf einem 2 Sockel [Intel Xeon E5420][2]-System mit 32 GB RAM gemacht. In der Mitte lag ein 2 Sockel System mit [Intel Xeon X5570][3] und 48 GB RAM Die besten Ergebnisse lieferte ein 4 Sockel Rechner mit 16 GB RAM und [AMD Opteron 852][4] Prozessoren.

Eine Erklärung für das unterschiedliche abschneiden der Systeme ist die Anbindung an den RAM und die Caches. Bei dem AMD-System hat jeder (Einkern-) Prozessor privaten Cache und einen eignen Speicherkontroller. Hier gibt es keine Engpässe. Bei dem [Intel Xeon X5570][3] sind die Speicherkontroller in der CPU, aber der L2 Cache ist shared zwischen 2 Kernen. [Hyperthreading][5] hat keine Verbesserung der Laufzeit gebacht. Am schlechtesten schnitt das [Intel Xeon E5420][2]-System ab. Die beiden Prozessoren gehen über die Nordbrücke, um an den RAM zu gelangen. Ab einer bestimmten Problemgröße wurden die Algorithmen über die Speicherzugriffe sequenzialisiert.

 [1]: http://en.wikipedia.org/wiki/Cilk
 [2]: http://ark.intel.com/Product.aspx?id=33927
 [3]: http://ark.intel.com/Product.aspx?id=37111
 [4]: http://www.cpu-world.com/CPUs/K8/AMD-Opteron%20852%20-%20OSP852FAA5BM.html
 [5]: http://www.intel.com/technology/platform-technology/hyper-threading/