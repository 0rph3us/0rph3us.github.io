---
layout: post
title: Superlinearer Speedup
categories:
- HPC
tags:
- C++
- cilk
- Kaktusstack
- strassen
type: post
author:
  login: rennecke
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
---
Ich habe für meine Diplomarbeit die [Matrixmultiplikation nach Strassen] implementiert. Das ganze habe ich mit
[Cilk++] implementiert.


{% lightbox 300xAUTO strassen-results.png group:"result_group" caption:"Speedup von Matrixmultiplikation nach Strassen" alt="superlinearer Speedup" %}


Ich war recht erstaunt, als ich diese Ergebnisse gesehen habe. Es ist erklärbar, weswegen ich einen superlinearen
[Speedup] erreicht habe. Wenn ich auf 4 CPUs rechne habe ich mehr [Cache] zur Verfügung. Diesen hohen
Speedup kann man nur durch Caching Effekte erreichen.


[Matrixmultiplikation nach Strassen]: http://de.wikipedia.org/wiki/Strassen-Algorithmus
[Cilk++]: http://en.wikipedia.org/wiki/Cilk
[Speedup]: http://de.wikipedia.org/wiki/Speedup
[Cache]: http://de.wikipedia.org/wiki/Cache
