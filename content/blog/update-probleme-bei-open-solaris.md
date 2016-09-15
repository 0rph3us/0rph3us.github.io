---
title: Update-Probleme bei Open Solaris
author: "Michael Rennecke"
type: post
date: "2010-02-04T05:32:56+00:00"
categories:
  - Solaris
tags:
  - OpenSolaris
  - pkg

---
Mein neuer Blog ist noch nicht so lange online und ich arbeite noch daran. Deswegen kommt diese Meldung etwas verspätet. Ich konnte bei meinen Rechnern nicht auf Build 131 updaten. Der Fehler äußerte sich wie folgt:

``` sh
root@walhalla Videos $ pkg install -q SUNWipkg
```

pkg: Angeforderter "install"-Vorgang würde sich auf Dateien auswirken, die im Live-Abbild nicht geändert werden können.

Versuchen Sie diesen Vorgang in einer alternativen Startumgebung erneut.

Der Grund sind "falsche" Pakte im [contrib-Repository][1]. Diese Pakte haben einen nicht korrekten Verweis auf das Paket entire, welche Pakte das sind kann man wie folgt raus finden:

``` sh
root@walhalla Videos $ pkg contents -Ho pkg.name,action.raw -t depend | grep fmri=entire@ | cut -f1
wine
```

Nun habe ich das entsprechnende Paket mit

``` sh
root@walhalla Videos $ pkg uninstall wine
```

destinstalliert. Dadnach ging das update ohne Probleme.

 [1]: http://pkg.opensolaris.org/contrib
