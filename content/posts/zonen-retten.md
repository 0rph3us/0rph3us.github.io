---
title: Zonen retten
author: Michael Rennecke
type: post
date: 2010-02-19T11:21:26+00:00
categories:
  - Solaris
tags:
  - OpenSolaris
  - zone

---
Ich habe mir vor einigen Wochen meine Systemplatten zerstört. Das hat mich noch nicht sonderlich gestört. Denn man kann OpenSolaris sehr schnell wieder installieren. Von den ganzen Konfigurationen hatte ich ein Backup. Ein kleineres Problem hatte ich mit den Zonen. Sie ließen sich nicht ohne weiteres im neuen System importieren. Ein möglicher Grund ist, dass ich sie nicht detachet hatte und die Zoneroots hatte ich auch nicht mehr.

Der Fehler hat sich wie folgt geäußert:

```
rennecke@walhalla ~ $ pfexec zoneadm -z test attach -u
Log File: /var/tmp/test.attach_log.KvayPK
ERROR: no active dataset.
rennecke@walhalla ~ $ pfexec zoneadm -z test attach
Log File: /var/tmp/test.attach_log.X4aOcK
ERROR: no active dataset.
rennecke@walhalla ~ $ pfexec cat /var/tmp/test.attach_log.X4aOcK
[Montag, 15. Februar 2010, 12:45:18 Uhr CET] Log File: /var/tmp/test.attach_log.X4aOcK
[Montag, 15. Februar 2010, 12:45:18 Uhr CET] ERROR: no active dataset.
```

Also habe ich etwas gebastelt und habe die Zonen wieder importiert.

1\. Das Backup von `/etc/zones` eingespielt
2\. Den zpool mit den zonen importiert, mit der Option **-f**
3\. ID des Parent Bootenvironment auslesen:

``` sh
rennecke@walhalla ~ $ zfs get -r org.opensolaris.libbe:uuid rpool/ROOT
...                                -
rpool/ROOT/opensolaris          org.opensolaris.libbe:uuid  642ced7d-55a2-cc3b-fbdf-fbdda1c33ebc  local
...
```

4\. Das höchste Bootenvironment der Zone bestimmen. Das ist die höchste Nummer:

``` sh
rennecke@walhalla ~ $ zfs get -r org.opensolaris.libbe:parentbe
...
daten/zone/test/ROOT/zbe-10                      org.opensolaris.libbe:parentbe  5741bca6-d793-454e-ad53-84c2cf7c630b  local
...
```

5\. ID des Parent Bootenvironment setzten:

``` sh
rennecke@walhalla ~ $ pfexec zfs set org.opensolaris.libbe:parentbe=642ced7d-55a2-cc3b-fbdf-fbdda1c33ebc daten/zone/test/ROOT/zbe-10

```

6\. Status der Zone in der Datei `/etc/zones/index` auf **configured** setzten
7\. Zone neu installieren:

``` sh
rennecke@walhalla ~ $ pfexec zoneadm -z test install
```

8\. Testen, ob die Zone sich **nicht** booten lässt:

``` sh
rennecke@walhalla ~ $ pfexec zoneadm -z test boot
```

Es sollte ein Fehler kommen, dass es mehrere aktive Datasets gibt.

9\. Das neu angelegte Bootenvironment der Zone löschen:

``` sh
rennecke@walhalla ~ $ pfexec zfs destroy daten/zone/test/ROOT/zbe-11
```

10\. Fertig, nun kann man die Zone wieder normal booten

Diese Unschönheit kommt bei Solaris 10 nicht vor. Es kann sein, dass sie auch nur bei den, von mir verwendten Build 131 vorkommt. Man sollte bei dieser Bastelei wissen was man tut, also bitte nicht wild darauf los tippen, wenn ihr den selben Fehler habt.
