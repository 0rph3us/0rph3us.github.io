---
title: Platz sparen mit zfs
author: Michael Rennecke
type: post
date: 2010-10-22T08:16:19+00:00
url: /solaris/platz-sparen-mit-zfs
categories:
  - Solaris
tags:
  - compression
  - Deduplikation
  - gnu
  - Linux
  - zfs

---
Mir sind heute meine Festplatten fast voll gelaufen. Also habe ich [quick&dirty][1] die Kompression und die Deduplikation von zfs f&uuml;r die betreffenden Dateisysteme aktiviert. Da zfs (noch) kein rewrite der Daten hat, habe ich angefangen die Daten zu kopieren und anschlie&szlig;end die alte Version gel&ouml;scht. Für import und Export von Pool hatte ich einfach zu wenig Platz, deswegen die umständliche Aktion mit dem kopieren. Und dann kam der Schreck: <tt>du -hs</tt> zeigte auf einmal eine kleinere Größe an. Nach einiger Nachforschung habe ich mitbekommen, dass **d**isk **u**sage wörtlich zu nehmen ist. <tt>du</tt> zeigt wirklich die Größe an, welche auf dem Device verbraucht wird. Das [GNU][2]&#8211;<tt>du</tt> kann hier Abhilfe schaffen, mit <tt>/usr/gnu/bin/du --apparent-size -hs</tt> bekommt man die Aufsummierte Größe der Dateien. In diesem Zusammenhang ist der [Blogeintrag von Ben Rockwood][3] lesenswert. 

Zum Schluss sei noch gesagt, dass sich die Aktion für meine Daten gelohnt hat. Ich habe <tt>zfs compression=on ....</tt> gesetzt, also keine gzip-Kompression benutzt.

 [1]: http://en.wikipedia.org/wiki/Quick-and-dirty
 [2]: http://www.gnu.org/
 [3]: http://www.cuddletech.com/blog/pivot/entry.php?id=983