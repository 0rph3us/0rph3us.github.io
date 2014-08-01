---
layout: post
title: "Webserver auf dem Raspberry Pi installieren"
description: ""
category: 
 - Raspberry Pi
 - Linux
tags:
 - Raspberry Pi
 - Linux
 - Raspbian
 - Nginx
 - php
---
{% include JB/setup %}

Da man auf dem [Raspberry Pi] nicht sehr viele Ressourcen zur Verfügung hat, scheidet [Apache] als
Webserver für mich aus. Ich habe [lighttpd] und [Nginx] ausprobiert. Von [lighttpd] war ich am 
Anfang sehr überzeugt. Er kann alles was man benötigt. Als mein Setup komplizierter wurde, war
ich nicht mehr in Lage in die Ideen mit [lighttpd] umzusetzten. Die Ursache liegt weniger im
Funktionsumfang, sondern an den zur Verfügung stehenden Tutorials, Beispielkonfigurationen sowie der
Default-Konfiguration wenn man [lighttpd] bei Raspbian installiert. Den entgültigen *Todesstoß* hat
[lighttpd] bekommen, als ich [Passenger] ausprobieren wollte. Für [Apache] und [Nginx] gibt es fertige
[Passanger]-Module bzw. funktionierenden Install-Skripte. Ich möchte nicht sagen, dass [lighttpd] schlechter
als [Nginx] ist, aber ich bin bei "komplexen" Setups mit mehreren virtuellen Hosts und rewrite-Magie
besser mit [Nginx] zurecht gekommen.

Im folgenden werde ich mich auf [Nginx] ("Engine-X") konzentrieren. da es für ihn sehr viele Tutorials
gibt und er sehr ressourcenschonend ist, ist er meiner Meinung nach die erste Wahl für den [Raspberry Pi].

Viele werden mit nur einen Webserver nicht glücklich, weil ein Webserver nur statiche Inhalte ausliefert.
Damit Nginx php ausliefern kann benötigt man php auf seinen Rechner sowie den 
PHP Fast CGI Process Manager. Dieser verwaltet php-Prozesse, welche wiederrum statisches HTML generieren
und an den Nginx weiter geben.

## Installation von Nginx ##

Vor der Installtion von neuen Pakten sollte man nachsehen, ob es Updates gibt. Ich jeden dazu täglich
sein System zu aktualisieren, gerade, wenn der Rechner öffentlich erreichbar ist.

{% highlight bash %}
# zu root werden
sudo su -

apt-get update
apt-get upgrade

apt-get install nginx php5-fpm php5-cgi php5-cli php5-common
{% endhighlight %}x



[Apache]: http://apache.org
[lighttpd]: 
[Nginx]: http://nginx.org
[Passanger]: 
[Raspberry Pi]: http://raspberrypi.org
