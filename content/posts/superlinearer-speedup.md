---
title: Superlinearer Speedup
author: Michael Rennecke
type: post
date: 2010-05-14T09:12:27+00:00
categories:
  - HPC
tags:
  - C++
  - cilk
  - Kaktusstack
  - strassen

---

Ich habe für meine Diplomarbeit die [Matrixmultiplikation nach Strassen][1] implementiert. Das ganze habe ich mit [Cilk++][2] implementiert.

![superlinearer Speedup](/strassen-results.png)

Ich war recht erstaunt, als ich diese Ergebnisse gesehen habe. Es ist erklärbar, weswegen ich einen superlinearen [Speedup][3] erreicht habe. Wenn ich auf 4 CPUs rechne habe ich mehr [Cache][4] zur Verfügung. Diesen hohen Speedup kann man nur durch Caching Effekte erreichen.

 [1]: http://de.wikipedia.org/wiki/Strassen-Algorithmus
 [2]: http://en.wikipedia.org/wiki/Cilk
 [3]: http://de.wikipedia.org/wiki/Speedup
 [4]: http://de.wikipedia.org/wiki/Cache