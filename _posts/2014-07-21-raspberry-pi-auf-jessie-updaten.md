---
layout: post
title: "Raspberry Pi auf Jessie updaten"
description: ""
category:
 - Linux
 - Raspberry Pi
tags: [debian, Jessie, Raspberry Pi, Raspbian]
---
{% include JB/setup %}


Das aktuell Raspbian basiert auf Debian 7 "Wheezy". Seit einiger Zeit gibt
es auch Raspberian Pakete für Debian 8 "Jessie". Jessie ist der Nachfolger von "Wheezy".
Die Pakete von "Jessie" sind um einiges aktueller, als die von "Wheezy". Das bedeutet
aber, dass sie nicht unbedingt so stabil sein können. Ich habe bis jetzt noch keine
negativen Erfahrungen gemacht.


### Aktualisierung ausführen ###

Die folgenden Schritte müssen alle als Benutzer **root** ausgeführt werden. Entweder man
loggt sie als **root** ein,  man schreibt `sudo` vor jedes Komando oder man öffnet eine
root-Shell mit `sudo -i`.

Man muss die `/etc/apt/sources.list` editieren. Dazu öffnet man sie mit einem Editor 
der Wahl (ich preferiere vi ;-)) und man ändert alle vorkommen von **wheezy** in **jessie**. 
Das ganze lässt sich auch automatrisch mit `sed` machen.

{% highlight bash %} 
cp /etc/apt/sources.list{,.$(date +%F)} && sed -e 's/wheezy/jessie/g' -i /etc/apt/sources.list
{% endhighlight %}


Wenn man nicht weiß was man macht, dann sollte man die Datei lieber per Hand editieren. Bei mir gibt es nur
eine Zeile und diese sollte dann wie folgt aussehen:

{% highlight bash %} 
deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi
{% endhighlight %}


Und nun muss man nur noch den Raspberry Pi updaten:

{% highlight bash %} 
apt-get update && apt-get dist-upgrade
{% endhighlight %}

Das Update kann sehr lange dauern. Anschließend muss man den Raspberry Pi neu starten und das Update ist beendet!
