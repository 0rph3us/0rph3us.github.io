---
layout: post
title: Acrobat Reader für Debian wheezy
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
meta:
  _edit_last: '2'
  _jd_tweet_this: 'yes'
  _wp_jd_wp: http://0rpheus.net/?p=5971
  _wp_jd_target: http://0rpheus.net/?p=5971
  _jd_wp_twitter: 'a:1:{i:0;s:37:"New post:  http://0rpheus.net/?p=5971";}'
author:
  login: rennecke
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
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
