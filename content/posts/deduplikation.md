---
title: Deduplikation
author: Michael Rennecke
type: post
date: 2010-02-08T12:55:43+00:00
categories:
  - Solaris
tags:
  - Deduplikation
  - OpenSolaris
  - zfs

---
Einige haben bestimmt schon von den Deduplikations-Feature in zfs gehört. Ich hatte leider keine Zeit ehr darüber zu schreiben. Bei Dedublikation speichert man doppelte Blöcke nur einmal. Diese kann man recht schnell erzeugen, wenn man eine Datei kopiert. Man kann auch gezielt Deduplikation nutzen. So kann man jeder Nutzer seine eigene Musiksammlung haben, denn doppelte Lieder benötigen keinen zusätzlichen Platz.

Ich möchte auch nicht meiner Freundin überall Schreibrechte geben, nicht dass sie ausversehen meine [Mario Ranieri][1]-Sammlung löscht. Kann sie mit ihren home nicht so umgehen, wie unter [Windoof][2], dann ist Open Solaris nicht mehr schön. Also ist Dedublikation die administratorfreundliche Lösung, denn man spart Platz und die User freuen sich über mehr Freiheiten. Es gibt noch viele andere Fälle, bei denen Deduplikation nützlich ist. In Unis und in Firmen haben auch einige Leute die gleichen Daten im home. Ich habe bei mir in allen zpools Deduplukation an. Es stimmt, dass Deduplikation CPU-Leistung braucht. Ich muss Sun recht geben, dass heutige CPUs genug Leistung haben und das nebenbei mit erledigen. Ich habe es noch nie erlebt, dass ich beim kopieren von Daten oder ähnlichen Aktionen mein System lahm gelegt habe.

Wie findet [zfs][3] eigenlich die doppelten Blöcke? In der default-Einstellung wird von den Blöcken eine [SHA-256][4]-Prüfsumme gebildet. Wenn 2 Prüfsummen gleich sind, dann sagt [zfs][3], dass die Blöcke gleich sind. Für paranoide Leute bietet [zfs][3] die Möglichkeit, dass man im Falle von 2 gleichen Prüfsummen die Blöcke (Es besteht die Möglichkeit, dass 2 unterschiedliche Blöcke die selbe Prüfsumme haben, das ist aber viel unwahrscheinlicher als unerkannte ECC-Fehler) noch einmal Byteweise vergleicht. Das wird aber sehr teuer. Das 2 Blöcke die selbe Prüfsumme haben tritt immer auf, wenn diese gleich sind. Also sollte man nicht denken, dass man die Blöcke nur Byteweise vergleicht, wenn die Prüfsummen gleich sind aber die Blockinhalte unterschiedlich. Die Deduplikation arbeitet im gesamten Pool, d.h. wenn man Dateien von einem Dateisystem in ein anderes kopiert werden die Daten auch dedupliziert.

Das ganze aktiviert man wie folgt:

``` sh
rennecke@walhalla ~ $  pfexec zfs set dedup=on rpool
```

 [1]: http://www.marioranieri.at/
 [2]: http://de.wikipedia.org/wiki/Microsoft_Windows
 [3]: http://chaosradio.ccc.de/cre049.html
 [4]: http://de.wikipedia.org/wiki/Secure_Hash_Algorithm
