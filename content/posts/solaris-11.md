---
title: "Solaris 11"
date: 2019-09-30T20:47:46+02:00
draft: false
description:
categories:
 - solaris
featured_image:
author: "Michael Rennecke"
---

Heute habe ich mal wieder Solaris installiert. Ich wollte einmal sehen, was aus meinen favorisierten Betriebsystem geworden ist. Nachdem ich nun
viele Jahre raus bin, fällt es mir schwer mich zurecht zu finden. Besonders nervig finde ich die grottige Geschwindigkeit der Spiegelserver.
Das war zu meinen aktiven Sun-Zeiten viel besser. Ich kann den Artikel schreiben, weil ich gerade `pkg install solaris-desktop` eingeben habe,
um den Desktop genießen können. Ich habe auch das Gefühl, dass der Installer schlechter geworden ist, im Vergleich zu Open Solaris.

Zu den schönen Dingen: Es wurde die Schrift beibehalten. Ich denke der Font heißt Gallant demi. Er ist unverwechselbar und ich assoziiere ihn
mit Solaris und der guten alten lila Sparc-Hardware.

Nachem ich etwas rum gespielt habe, werde ich Linux treu bleiben. Solaris ist definitiv ein Betriebssystem für dicke Server. Das Fault Management
configuration Tool `fmadm` unterstreicht diesen Anspruch. Es hat mich gleich auf einen unsichern Kernel Boot Parameter hingewiesen.
Ich kann trotzdem nicht mehr damit arbeiten. Da viele Tools, die ich täglich nutze nicht verfügbar sind. Dazu zählen auch docker und ansible. Ich 
wollte auch einmal schnell eine Windows
Domain mit samba 4 (samba 4.7.6 wird ausgeliefert) aufsetzten. Dabei musste ich mit entsetzen feststellen, dass die Manpage zu `samba-tool` existiert,
aber das Komando extiert nicht. Das hinterlässt bei mir einen sehr faden Beigeschmack, was die Pflege des Repositoies anbelangt.

## Fazit

Ich weiß nicht so richtig. Solaris ist wahrscheinlich immernoch geil, aber sie sind an einigen Stellen stehen geblieben. Das Software aus den eigenen
Repos nicht funktion, wie in der Manpage beschrieben, das kannte ich nicht von früher. Software übersetzten ist nach wie vor ein Krampf. [Opencsw]
sieht inzwischen auch wie eine Mottenkiste aus. Es gibt auch Pakete, welche 2018 aktualisiert wurden.

Wenn man noch nie Solaris angefasst hat und kein Enthusiast ist, dann sollte man einen großen Bogen als Privatperson um Solaris machen. Vielleicht
spiele ich noch einmal damit.

[Opencsw]: https://www.opencsw.org/
