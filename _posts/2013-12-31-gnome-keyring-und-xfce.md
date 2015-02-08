---
layout: post
title: Gnome-Keyring und Xfce
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
meta:
  _wp_jd_target: http://0rpheus.net/?p=6496
  _jd_wp_twitter: 'a:1:{i:0;s:59:"New post: Gnome-Keyring und Xfce http://0rpheus.net/?p=6496";}'
  _wp_jd_wp: http://0rpheus.net/?p=6496
  _jd_tweet_this: 'yes'
  _edit_last: '2'
author:
  login: rennecke
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
---
Ich bin seit kurzen von [Gnome](http://www.gnome.org/) auf [Xfce](http://www.xfce.org/) umgestiegen.
Dabei ist mir die folgende Fehlermeldung öfter einmal durch die Konsole gelaufen:

{% highlight text %}
WARNING: gnome-keyring:: couldn't connect to: /home/rennecke/.cache/keyring-4OkyiQ/pkcs11: No such file or directory
{% endhighlight %}

Das ganze lässt sich beheben, wenn man in der `/etc/xdg/autostart/gnome-keyring-pkcs11.desktop` die folgende Zeile von:

{% highlight c %}
OnlyShowIn=GNOME;Unity;
{% endhighlight %}

in

{% highlight c %}
OnlyShowIn=GNOME;Unity;XFCE
{% endhighlight %}

ändert. Nach dem neu anmelden bzw. Neustarten ist der Fehler weg. Ich habe diesen Fehler unter [Debian](http://www.debian.org/) und [Xubuntu](http://xubuntu.org/) beobachtet.
Der Fehler scheint [dieser Bug](http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=649408) zu sein.
