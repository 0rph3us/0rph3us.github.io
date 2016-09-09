---
type: post
title: Superlinearer Speedup
date: 2010-05-14
categories:
 - HPC
tags:
 - C++
 - cilk
 - Kaktusstack
 - Strassen
lightbox: true
---
Ich habe für meine Diplomarbeit die [Matrixmultiplikation nach Strassen] implementiert. Das ganze habe ich mit
[Cilk++] implementiert.

<a href="/strassen-results.png" title="" data-lightbox="set1" data-title="Speedup von Matrixmultiplikation nach Strassen"><img src="/strassen-results-thumbnail.png" alt="superlinearer Speedup"></a>

Ich war recht erstaunt, als ich diese Ergebnisse gesehen habe. Es ist erklärbar, weswegen ich einen superlinearen
[Speedup] erreicht habe. Wenn ich auf 4 CPUs rechne habe ich mehr [Cache] zur Verfügung. Diesen hohen
Speedup kann man nur durch Caching Effekte erreichen.


[Matrixmultiplikation nach Strassen]: http://de.wikipedia.org/wiki/Strassen-Algorithmus
[Cilk++]: http://en.wikipedia.org/wiki/Cilk
[Speedup]: http://de.wikipedia.org/wiki/Speedup
[Cache]: http://de.wikipedia.org/wiki/Cache
