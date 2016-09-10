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
Ich habe f&uuml;r meine Diplomarbeit die [Matrixmultiplikation nach Strassen][1] implementiert. Das ganze habe ich mit [Cilk++][2] implementiert.<a href="http://0rpheus.net/uploads/2010/05/strassen-results.png" rel="lightbox[2422]"><img src="http://0rpheus.net/uploads/2010/05/strassen-results-300x300.png" alt="superlinearer Speedup" title="Speedup von Matrixmultiplikation nach Strassen" width="300" height="300" class="aligncenter size-medium wp-image-2432" srcset="http://0rpheus.net/uploads/2010/05/strassen-results-300x300.png 300w, http://0rpheus.net/uploads/2010/05/strassen-results-150x150.png 150w, http://0rpheus.net/uploads/2010/05/strassen-results.png 600w" sizes="(max-width: 300px) 100vw, 300px" /></a>

Ich war recht erstaunt, als ich diese Ergebnisse gesehen habe. Es ist erkl&auml;rbar, weswegen ich einen superlinearen [Speedup][3] erreicht habe. Wenn ich auf 4 CPUs rechne habe ich mehr [Cache][4] zur Verf&uuml;gung. Diesen hohen Speedup kann man nur durch Caching Effekte erreichen.

 [1]: http://de.wikipedia.org/wiki/Strassen-Algorithmus
 [2]: http://en.wikipedia.org/wiki/Cilk
 [3]: http://de.wikipedia.org/wiki/Speedup
 [4]: http://de.wikipedia.org/wiki/Cache