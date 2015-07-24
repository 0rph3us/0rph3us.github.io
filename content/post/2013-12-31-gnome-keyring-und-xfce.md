---
layout: post
title: Gnome-Keyring und Xfce
date: 2013-12-31
categories:
- Linux
tags:
- gnome-keyring
- Linux
- pkcs11
- xfce
status: publish
type: post
published: true
---
Ich bin seit kurzen von [Gnome](http://www.gnome.org/) auf [Xfce](http://www.xfce.org/) umgestiegen.
Dabei ist mir die folgende Fehlermeldung öfter einmal durch die Konsole gelaufen:


    WARNING: gnome-keyring:: couldn't connect to: /home/rennecke/.cache/keyring-4OkyiQ/pkcs11: No such file or directory

Das ganze lässt sich beheben, wenn man in der `/etc/xdg/autostart/gnome-keyring-pkcs11.desktop` die folgende Zeile von:

    OnlyShowIn=GNOME;Unity;

in

    OnlyShowIn=GNOME;Unity;XFCE

ändert. Nach dem neu anmelden bzw. Neustarten ist der Fehler weg. Ich habe diesen Fehler unter [Debian](http://www.debian.org/) und [Xubuntu](http://xubuntu.org/) beobachtet.
Der Fehler scheint [dieser Bug](http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=649408) zu sein.
