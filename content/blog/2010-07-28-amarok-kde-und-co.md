---
title: amarok, KDE und Co
author: Michael Rennecke
type: post
date: 2010-07-28T07:53:37+00:00
wp_jd_wp:
  - http://0rpheus.net/?p=3092
wp_jd_target:
  - http://0rpheus.net/?p=3092
categories:
  - Solaris
  - Tools
tags:
  - amarok
  - KDE
  - OpenSolaris
  - pkg

---
Es gibt inzwischen KDE Pakte für Open Solaris. Diese werden von [Pavel Heimlich][1] betreut. Er hat dafür ein eigenes Repo. Ich nutze nur [amarok][2], welches ich an eine mysql-DB gebunden habe.

Es scheint prinzipell alles zu funktionieren. Ich habe nur den Eindruck, dass alles etwas langsam ist. Das schreibt auch Pavel in seinen Blog. Das liegt an [dbus][3]. Mein aktueller Build 142 macht das ganze sicher auch besser&#8230; 

Der primäre Server ist <http://solaris.bionicmutton.org:10000/> Die nimmt keine neuen Verbindungen mehr an, wenn seine Downloadgeschwindigkeit ca. 100kBit/s ist. Ich habe gute Erfahrungen mit den Mirror gemacht: <http://pkg.osladil.cz:30000/>. Vielleicht kommt das mal in die offizellen Repos mit rein, die sind aber auch nicht gerade schnell&#8230;.

Es gibt eine neue Versiom im Repo. Aber sie läuft auch noch etwas harklig auf meinen Build 142. Ich hoffe, dass Illumos bals aus den Puschen kommt&#8230;

 [1]: http://blog.hajma.cz/
 [2]: http://amarok.kde.org/
 [3]: http://www.opensolaris.org/jive/thread.jspa?threadID=130031&tstart=0