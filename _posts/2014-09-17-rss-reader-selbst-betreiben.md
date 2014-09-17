---
layout: post
title: "RSS Reader selbst betreiben"
description: ""
category: 
 - Raspberry Pi
 - Linux 
tags:
 - Nginx
 - Security
 - Feed
 - RSS
 - Smartphone
 - MySQL
 - Raspbian
 - Raspberry Pi
---
{% include JB/setup %}

Nach meinen Wissen gab es eine Zeit, in der RSS-Feeds als Old-School und damit
als nicht mehr zeitgemäß galten. Ich finde, dass sie zur Zeit immer beliebter
werden. Ich möchte meine Feeds immer dabei und nicht viele Apps auf dem Smartphone
installieren, nur um meinen 20 News-Seiten zu folgen. Das ganze im Browser zu
lesen kann auf mobilen Devices nervig werden, entweder ist die mobile Seite nicht
wirklich brauchbar oder man hat zu viele Seite, welche man lesen möchte.

Da viele Seiten einen [Feed] anbieten, kann man diese abonieren und in einen
Feed-Reader zusammen führen. Es gibt Menschen, wie mich, die keinen Reader wie
[Feedly] nutzen möchten. 

Mit einem [Raspberry Pi] kann man einfach selbst einen RSS-Reader an der heimischen
DSL-Leitung betreiben. Dazu benutze ich [Nginx] als Webserver, [MySQL] als Datenbank
sowie [Tiny Tiny RSS] als Reader. Als Betriebssystem nutze ich Raspbian.

## Nginx installieren ##
Wie man [Nginx] installiert, habe ich in [diesem Artikel] schon erklärt. 
Je nach dem wie paranoid bzw. nerdig man ist, sollte man die Verbindung noch
mit SSL/TLS absichern.

## MySQL installieren ##

Die grundlegende Installation von MySQL geht leicht von der Hand. Da man nur einige
Pakte installieren muss. Die nötige Datenbank ist auch schnell eingerichtet.

{% highlight bash %}
# zu root werden
sudo su -

apt-get update
apt-get install mysql-server mysql-client php5-mysql php5-curl

# Datenbanken einrichten
mysql -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
[...]
mysql> CREATE DATABASE ttrss;
Query OK, 1 row affected (0.01 sec)
 
mysql> GRANT ALL ON ttrss.* TO ttrss@localhost IDENTIFIED BY 'GeheimesPasswort';
Query OK, 0 rows affected (0.02 sec)
 
mysql> exit
Bye
{% endhighlight %}

### MySQL härten ###

Mit dem folgenden Tool kann man seine MySQL noch härten. Dazu löscht
es die Test-Datenbanken und anonyme Benutzer. Weiterhin ist ein
Remote Login für den Benutzer `root` nicht mehr möglich. 

{% highlight bash %}
# zu root werden
sudo su -
mysql_secure_installation
{% endhighlight %}

## Tiny Tiny RSS installieren ##

Man läd sich die [aktuellste Version] von [Tiny Tiny RSS] in das Document Root-Verzeichnis
von Nginx und entpackt es

{% highlight bash %}
# zu root werden
sudo su -
cd /usr/share/nginx/www
wget https://github.com/gothfox/Tiny-Tiny-RSS/archive/1.13.tar.gz
tar xfvz 1.13.tar.gz
mv Tiny-Tiny-RSS-1.13/ tt-rss/
chown -R www-data:www-data tt-rss/
rm 1.13.tar.gz
{% endhighlight %}

Nachdem man das alles gemacht hat, führt man die Installation von Tiny Tiny RSS im Browser fort. Dazu
`http(s)://IP/tt-rss/install/`
Dort wählen wir MySQL in dem Feld *Database type*, geben als *Username* und *Database name* 
*ttrss* an und geben das Passwort, welches dür den MySQL Benutzer *ttrss* angelegt hat, 
in das Feld *Password* ein. Der Port ist 3306. In das Feld *Host name* schreiben wir 127.0.0.1 
Anschließend klicken wir auf *Test configuration*.

Wenn alles richtig war, dann erscheint *Database test succeeded*. Nach einem Klick auf 
*Initialize database* können wir aus der Textbox die Konfiguration kopieren.

{% highlight bash %}
sudo su -
cat << EOF > /usr/share/nginx/www/tt-rss/config.php
kopierten Text hier einfügen
EOF  
{% endhighlight %}

### Feeds aktualisieren ###

Dazu muss man die folgende Zeile in die `crontab` von `root` eintragen:

{% highlight bash %}
*/30 * * * * su www-data -s /bin/bash -c '/usr/bin/php /var/www/tt-rss/update.php --feeds --quiet'
{% endhighlight %}

## Tiny Tiny RSS für das Smartphone ##

Es gibt zwei Android Clients für Tiny Tiny RSS. Diese haben beide den Nachteil, dass sie unter Umständen
Probleme mit den Ciphers der SSL Verschlüsselung haben. Da das bei mir der Fall war bin ich auf eine HTML
App umgestiegen, welche auch noch auf meinen Raspberry Pi läuft. Dazu muss man nur [dieses Archiv] herunter
laden und entpacken, alternativ kann man auch das [dazugehörige git-Repository] clonen.

Man muss vorher sicherstellen, dass der API-Zugriff zu Tiny Tiny RSS erlaubt ist. Man loggt sich als ersten
in TT-RSS ein und klickt dann auf *Aktionen* -> *Einstellungen* und *Aktiviere API-Zugang* muss ein grünes
Häkchen haben (wenn nicht anklicken).

{% highlight bash %}
sudo su -
cd /usr/share/nginx/www
wget https://github.com/mboinet/ttrss-mobile/archive/1.0-1.tar.gz
tar xfvz 1.0-1.tar.gz
mv ttrss-mobile-1.0-1 mobile
cp mobile/scripts/conf.js{-dist,}
{% endhighlight %}

Nun kann man unter `http(s)://IP/mobile/` die HTML5 Anwendung für das Smartphone erreichen.


## Schlussbemerkung ##
Soll der soeben installierte Dienst auch außerhalb des eigenen Netzwerkes verfügbar sein, so müssen 
folgende Ports (80 und 443) im Router freigegeben werden.


[dazugehörige git-Repository]: https://github.com/mboinet/ttrss-mobile
[Feed]: http://de.wikipedia.org/wiki/Web-Feed
[Feedly]: http://feedly.com/
[Raspberry Pi]: http://www.raspberrypi.org/
[Tiny Tiny RSS]: http://tt-rss.org/
[MySQL]: http://www.mysql.de/
[Nginx]: http://nginx.org/
[diesem Artikel]: {% post_url 2014-07-31-webserver-auf-dem-raspberry-pi-installieren %}
[aktuellste Version]: https://github.com/gothfox/Tiny-Tiny-RSS/releases
[dieses Archiv]: https://github.com/mboinet/ttrss-mobile/archive/1.0-1.tar.gz
