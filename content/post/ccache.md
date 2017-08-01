+++
title = "ccache"
date = "2017-08-01T21:40:24+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["gcc"]
categories = ["Linux", "Tools"]
+++

Ich habe heute mit 2 Bekannten über den Beitrag [Kernel bauen] gesprochen und wir sind auf
das Thema [ccache] gekommen. Sie konnten meine Aussage nicht nachvollziehen, dass ich
ccache nutze. Einer nutzt ccache nicht, weil er auf seinen System keinen (merkbaren)
Geschwindigkeitsvorteil hat. Eine weitere Meinung ist, die nicht von der Hand zu
weisen ist, die Wahrscheinlichkeit für Compilerfehler steigt, weil ccache auch Bugs
haben kann und ggf. das falsche ausliefert. Das Hauptargument war, dass man einen Kernel
in 4 Minuten baut, weil man natürlich nur das baut, was man wirklich benötigt.


Als Fazit von der ganzen Geschichte, kann ich nur sagen es kommt darauf an, ob ccache
sich prositiv auf die Übersetzungszeit auswirkt. 



[Kernel bauen]: {{< relref "kernel-bauen.md" >}}
[ccache]: https://ccache.samba.org/