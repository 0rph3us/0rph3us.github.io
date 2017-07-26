---
title: Neuer GPG-Key
author: Michael Rennecke
type: post
date: 2013-09-09T18:38:06+00:00
categories:
  - Sicherheit
  - Tools
tags:
  - DSA
  - gpg
  - RSA
  - Security

---
Nach den ganzen [NSA][1]-Enthüllungen, habe ich mich wieder mit Public-Key-Kryptografie beschäftigt. Mein bisheriger [GPG][2]-Schüssel D12E87BA hat [DSA][3] und [ElGamal][4] verwendet. Ich habe damals diese Algorithmen damals gewählt, da ich keinen &#8220;Standard-Key&#8221; haben wollte. Die Längen sind auch nach heutigen Maßstäben ausreichend. Es aber [Angriffe für DSA][5], welche darauf beruhen, dass die Zufallszahlen von Zufallszahlengeneratoren nicht zufällig sind. Da ich meinen Schlüssel auf beliebigen Rechnern und auch Endgeräten nutzen möchte, kann ich nicht immer sicher stellen, dass der Zufallszahlengenerator wirklich korrekt seine Arbeit macht. Aus diesem Grund habe ich mir ein neues Schlüsselpaar mit [RSA][6] zum verschlüsseln und signieren erstellt.

Es ist nicht ganz unwahrscheinlich, dass [große Organisationen 1024 Bit RSA Schüssel faktorisieren][7] können. Ein Schlüssellänge von 2048 Bit gilt als sicher und 4096 Bit als paranoid. Ich bin lieber paranoid und nehme 4096 lange Schlüssel, da diese Schüssellänge auf heutigen Rechnern kein Problem darstellt und von fast allen Implementieren von GPG unterstützt wird.

Mein neuer Key ist [EE75C6FE][8].

 [1]: http://www.nsa.gov/
 [2]: http://www.gnupg.org/
 [3]: http://www.itl.nist.gov/fipspubs/fip186.htm
 [4]: http://de.wikipedia.org/wiki/Elgamal-Verschl%C3%BCsselungsverfahren
 [5]: http://rdist.root.org/2010/11/19/dsa-requirements-for-random-k-value/
 [6]: http://de.wikipedia.org/wiki/RSA-Kryptosystem
 [7]: http://news.cnet.com/8301-13578_3-57591560-38/facebooks-outmoded-web-crypto-opens-door-to-nsa-spying/
 [8]: http://pgp.mit.edu:11371/pks/lookup?op=vindex&search=0x617EB806EE75C6FE