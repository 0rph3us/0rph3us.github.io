---
layout: post
title: "kaputtes System nach Restore mit Obnam"
date: 2015-04-20
description: ""
categories: 
 - 'linux'
 - 'tools'
tags:
 - 'obnam'
 - 'backup'
 - 'ubuntu'
---


[Obnam] ist ein nettes Backup-Tool, welches ich auf meinen Laptop unter Ubuntu 14.04 verwende.
Ich wollte die Tage einen Restore von einer Datei machen und habe sie inplace wieder herstellen wollen.

```
sudo obnam --generation=243130 restore --to=/  /etc/apt/sources.list.d/adiscon-v8-stable-trusty.list
```

Danach war meine aktuelle Session im Eimer und ich habe meinen Rechner neu gestartet. Danach gab es eine
große Überraschung: Ich konnte mich nicht mehr einloggen. Nach dem ersten Schreck, dass obnam vielleicht
die Platte geschrottet hat, habe ich mit [grml] auf die Platte geschaut. Alles war da. Nach einiger Zeit
habe ich festgestellt, dass obnam die Rechte von / auf 700 geändert hat. Nachdem ich / wieder auf 755 geändert
habe ging alles. 

Es ist leider reproduzierbar, dass obnam die Rechte alle Verzechnisse beim Restore kaputt macht, welche
es nicht unter Kontrolle hat. Aus diesem Grund mache ich einen Restore jetzt wie folgt:

```
sudo obnam --generation=243130 restore --to=/home/rennecke/restore  /etc/apt/sources.list.d/adiscon-v8-stable-trusty.list
```

Das aktuelle Verhalten ist ein absolutes No-Go! Ich verwende die Version 1.9 aus [dieser PPA]
 

[Obnam]: http://obnam.org/
[grml]: https://grml.org/
[dieser PPA]: https://launchpad.net/~chris-bigballofwax/+archive/ubuntu/obnam-ppa
