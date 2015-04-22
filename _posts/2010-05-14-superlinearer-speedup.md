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
status: publish
type: post
published: true
meta:
  _edit_last: '2'
author:
  login: rennecke
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
---
<p>Ich habe f&uuml;r meine Diplomarbeit die <a href="http://de.wikipedia.org/wiki/Strassen-Algorithmus">Matrixmultiplikation nach Strassen</a> implementiert. Das ganze habe ich mit  <a href="http://en.wikipedia.org/wiki/Cilk">Cilk++</a> implementiert.<a href="http://0rpheus.net/uploads/2010/05/strassen-results.png"><img src="assets/strassen-results-300x300.png" alt="superlinearer Speedup" title="Speedup von Matrixmultiplikation nach Strassen" width="300" height="300" class="aligncenter size-medium wp-image-2432" /></a></p>
<p>
Ich war recht erstaunt, als ich diese Ergebnisse gesehen habe. Es ist erkl&auml;rbar, weswegen ich einen superlinearen <a href="http://de.wikipedia.org/wiki/Speedup">Speedup</a> erreicht habe. Wenn ich auf 4 CPUs rechne habe ich mehr <a href="http://de.wikipedia.org/wiki/Cache">Cache</a> zur Verf&uuml;gung. Diesen hohen Speedup kann man nur durch Caching Effekte erreichen.</p>
