+++
author = ""
categories = [ "Sicherheit", "Linux" ]
date = "2017-07-26T21:42:12+02:00"
description = ""
featured = ""
featuredalt = ""
featuredpath = ""
linktitle = ""
title = "SSH Authentifizierung"
type = "post"
tags = ["ssh"]
+++

Man kann sich bei [SSH] mit Nutzername und Passwort authentifizieren oder man
nutzt ein [Public Key-Verfahren], statt Passwort. In den meisten Fällen ist
die Authentifizierung mit einem Schlüssel zu bevorzugen. Wenn man sich oft anmeldet,
dann kann es nervig sein jedes mal das Passwort einzugeben. Ein entsperrter
Schlüssel vereinfacht die Arbeit erheblich. Außerdem tuen sich viele Leute schwer
ein starken Passwort zu merken.


## Authentifizierung mit Schlüssel

Als erstes muss man einen Schlüssel erzeugen. Für den Schlüssel sehen folgenden
Algorithmen zur Verfügung: [DSA], ECDSA, [ED25519], [RSA] und RSA1. RSA1 darf
man nicht mehr verwenden. Damit werden Schlüssel für die SSH Version 1 
erzeugt. Ich kenne keinen Server, der das alte Protokoll ausschließlich unterstüzt.
DSA sollte man auch nicht mehr verwenden, da SSH nur DSA Schlüssel mit einer
maximalen Länge von 1024 Bit unterstüzt. RSA muss man benutzen, wenn man einen
Schlüssel für alte Server bzw. Clients benötigt. Bei der Länge des Schlüssels
darf man keine Kompromisse machen. Hier halte ich 3072 bzw. 4096 Bit für
angemessen. ED25519 und ECDSA sind Verfahren, welche auf [Elliptischen Kurven]
basieren. ECDSA ist gegenüber ED25519 etwas langsamer und empfindlicher für
[Seitenkanalangriffe]. Der Nachteil von ED25519 ist, das es durchaus noch einige
Server gibt, die diesen Algorithmus nicht unterstützen.


### Hinweis

Es gibt durchaus SSH-Server, welche nur RSA mit maximal 2048 Bit langen Schlüsseln
können. Für diese Ausnahmen habe ich separate kurze Schlüssel. Man kann schließlich
mehrere Schlüssel haben.


### Schlüssel erzeugen

Ein RSA-Schlüssel erzeugt man mit `ssh-keygen -t rsa -b 4096` und einen ED25519-Schlüssel
mit `ssh-keygen -t ed25519`. Das 

{{< highlight sh >}}
ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/michael/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/michael/.ssh/id_ed25519.
Your public key has been saved in /home/michael/.ssh/id_ed25519.pub.
The key fingerprint is:
SHA256:ujmHnITO7c5ihgu4qIPkIDf0Z+DY2w6gLh8202v9plM michael@loki
The key's randomart image is:
+--[ED25519 256]--+
|                 |
|                 |
|                 |
|  . .            |
| ..= o  S        |
|+o+o= +.E        |
|X.==oX.+         |
|*=.+O+Xoo        |
|*+o=.=OB.        |
+----[SHA256]-----+
{{< /highlight >}}



[SSH]: https://de.wikipedia.org/wiki/Secure_Shell
[Public Key-Verfahren]: https://de.wikipedia.org/wiki/Asymmetrisches_Kryptosystem
[DSA]: https://de.wikipedia.org/wiki/Digital_Signature_Algorithm
[ED25519]: https://ed25519.cr.yp.to/
[RSA]: https://de.wikipedia.org/wiki/RSA-Kryptosystem
[Elliptischen Kurven]: https://de.wikipedia.org/wiki/Elliptic_Curve_Cryptography
[Seitenkanalangriffe]: https://de.wikipedia.org/wiki/Seitenkanalattacke
