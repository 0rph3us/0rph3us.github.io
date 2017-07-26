---
title: Meine neue Festplatte
author: Michael Rennecke
type: post
date: 2010-01-19T11:04:34+00:00
categories:
  - privat

---
Ich habe vor ein paar Tagen geschrieben, dass ich Ärger mit der Post hatte. Nachdem ich endlich zu Hause war, habe ich die enthaltene Festplatte in meinen Rechner eingebaut. Ich wollte damit eine alte Festplatte ersetzt mit [zfs][1] als Dateisystem ist das ganz einfach: <tt>zpool replace daten c4d0 c11d0</tt>

Nun schreibt zfs die Daten von der Platte c4d0 auf die Platte c11d0, das geht im laufenden Betrieb. Mit <tt>zpool status</tt> kann man sich ansehen, wie weit das kopieren der Daten fortgeschritten ist. Wenn man Platten ersetzt, dann muss die neue Platte mindestens so groß sein, wie die alte Platte.

 [1]: http://hub.opensolaris.org/bin/view/Community+Group+zfs/