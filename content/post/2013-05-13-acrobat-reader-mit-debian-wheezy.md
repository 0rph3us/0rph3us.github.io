---
layout: post
title: Acrobat Reader für Debian wheezy
date: 2013-05-13
categories:
- Linux
tags:
- Acrobat Reader
- acroread
- Debian
- Linux
- pdf
status: publish
type: post
published: true
---

Ich hatte heute wieder eine [pdf] mit Formularen in,
welche in einen alternativen Viewer nicht wirklich funktioniert hat.
Den Arcobat Reader gibt es leider nicht als 64-Bit Paket, aber die 32-Bit Version tut auch ihren Dienst.


``` sh
echo "deb http://www.deb-multimedia.org wheezy main non-free" >> /etc/apt/sources.list
gpg --keyserver pgpkeys.mit.edu --recv-key 07DC563D1F41B907
gpg -a --export 07DC563D1F41B907 | apt-key add -
dpkg --add-architecture i386
apt-get update
apt-get install acroread
```

P.S.: Auf meinen Servern benutze ich `/etc/apt/sources.list.d/<listname>.list` für zusätzliche Paketlisten.

[pdf]: http://www.adobe.com/devnet/pdf/pdf_reference.html
