---
type: post
title: amarok, KDE und Co
date: 2010-07-28
categories:
 - Solaris
 - Tools
tags:
 - amarok
 - KDE
 - OpenSolaris
 - pkg
---
Es gibt inzwischen KDE Pakte für Open Solaris. Diese werden
von [Pavel Heimlich] betreut. Er hat dafür ein eigenes
Repo. Ich nutze nur [amarok], welches ich an eine MySQL-DB
gebunden habe.


Es scheint prinzipell alles zu funktionieren.
Ich habe nur den Eindruck, dass alles etwas langsam ist.
Das schreibt auch Pavel in seinen Blog. Das liegt an
[dbus]. Mein aktueller Build 142 macht das ganze sicher auch besser...


Der primäre Server ist [http://solaris.bionicmutton.org:10000/].
Die nimmt keine neuen Verbindungen mehr an, wenn seine
Downloadgeschwindigkeit ca. 100kBit/s ist. Ich habe gute
Erfahrungen mit den Mirror gemacht:
[http://pkg.osladil.cz:30000] Vielleicht kommt das mal in die offizellen
Repos mit rein, die sind aber auch nicht gerade schnell....


Es gibt eine neue Versiom im Repo. Aber sie läuft auch noch etwas harklig auf meinen Build 142.
Ich hoffe, dass Illumos bals aus den Puschen kommt...

[Pavel Heimlich]: http://blog.hajma.cz/
[amarok]: http://amarok.kde.org/
[http://pkg.osladil.cz:30000]: http://pkg.osladil.cz:30000
[http://solaris.bionicmutton.org:10000/]: http://solaris.bionicmutton.org:10000/
[dbus]: http://www.opensolaris.org/jive/thread.jspa?threadID=130031&tstart=0
