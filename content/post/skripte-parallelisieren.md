---
type: post
title: "Skripte parallelisieren"
date: 2015-02-12
description: ""
categories:
 - 'Linux'
 - 'Tools'
tags:
 - 'parallel'
 - 'bash'
---


Für viele Aufgaben bei meiner täglichen Arbeit mit Linux nutze ich [bash]-Skripte bzw. tippe sie gleich auf der Komandozeile ein. Es gibt viele Aufgaben welche _langwierig_ sind und leicht parallelisierbar sind. Hier kann das Programm [parallel] helfen. Im einfachsten Fall stellt man es sich wie eine Art Queueing-System vor. Die Aufgabenpakete werden in eine Warteschlange gesteckt und `n` Prozesse arbeiten die Warteschlange ab. Wenn man nichts konfiguriert, dann ist `n` die Anzahl der Prozessorkerne.

Man kann `parallel` als Ersatz für `xargs` nehmen oder um Schleifen zu parallelisieren. Auf der Seite von `parallel` gibt es viele [Beispiele], welche über das parallelisieren von Schleifen hinaus gehen.

### Aktueller Anwendungsfall
Ich nutze `parallel` zum erstellen von Backups. Dazu kopiere ich sehr viele kleine Dateien auf eine [NFS]-Freigabe. Ich habe [rsync] und `cp` probiert. `rsync` ist in meinen Fall langsamer als `cp`.

Aus diesem Grund habe ich `cp`, wie folgt parallelisiert:

``` sh
find . -type f -mtime -2 | parallel --jobs 16 /usr/sbin/backup_helper.sh {}
```

Es werden alle Dateien gesucht, welche jünger als 2 Tage sind. Diese werden mit 16 parallelen `cp` auf das NFS-Share kopiert. So bekomme meine 1GBit Netzwerkanbindung während des Backups ausgelastet. Beim sequenziellen kopieren bzw. mit `rsync` bin ich nicht über 100MBit/s gekommen.

Das script `backup_helper.sh` sieht wie folgt aus:

``` sh
cat /usr/sbin/backup_helper.sh
#!/bin/bash

base="$(dirname ${1})"
mkdir -p "/backup/${base}"
cp "${1}" "/backup/${1}"
```



[bash]: http://tiswww.case.edu/php/chet/bash/bashtop.html
[rsync]: http://rsync.samba.org/
[parallel]: http://www.gnu.org/software/parallel/
[Beispiele]: http://www.gnu.org/software/parallel/man.html
[NFS]: http://de.wikipedia.org/wiki/Network_File_System
