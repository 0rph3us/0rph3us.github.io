---
title: Gnome-Keyring und Xfce
author: Michael Rennecke
type: post
date: 2013-12-31T15:14:05+00:00
url: /linux/gnome-keyring-und-xfce
categories:
  - Linux
tags:
  - gnome-keyring
  - Linux
  - pkcs11
  - xfce

---
Ich bin seit kurzen von [Gnome][1] auf [Xfce][2] umgestiegen. Dabei ist mir die folgende Fehlermeldung öfter einmal durch die Konsole gelaufen:

<div class="codecolorer-container text default" style="overflow:auto;white-space:nowrap;width:635px;">
  <div class="text codecolorer">
    WARNING: gnome-keyring:: couldn't connect to: /home/rennecke/.cache/keyring-4OkyiQ/pkcs11: No such file or directory
  </div>
</div>

Das ganze lässt sich beheben, wenn man in der <tt>/etc/xdg/autostart/gnome-keyring-pkcs11.desktop</tt> die folgende Zeile von:

<div class="codecolorer-container text default" style="overflow:auto;white-space:nowrap;width:635px;">
  <div class="text codecolorer">
    OnlyShowIn=GNOME;Unity;
  </div>
</div>

in

<div class="codecolorer-container text default" style="overflow:auto;white-space:nowrap;width:635px;">
  <div class="text codecolorer">
    OnlyShowIn=GNOME;Unity;XFCE
  </div>
</div>

ändert. Nach dem neu anmelden bzw. Neustarten ist der Fehler weg. Ich habe diesen Fehler unter [Debian][3] und [Xubuntu][4] beobachtet. Der Fehler scheint [dieser offizielle Bug][5] zu sein.

 [1]: http://www.gnome.org/
 [2]: http://www.xfce.org/
 [3]: http://www.debian.org/
 [4]: http://xubuntu.org/
 [5]: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=649408