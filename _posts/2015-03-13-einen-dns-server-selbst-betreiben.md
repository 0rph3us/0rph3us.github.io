---
layout: post
title: "Einen DNS Server selbst betreiben"
description: ""
category: 
 - linux
 - 'raspberry pi'
tags:
 - Linux
 - DNS
 - PowerDNS
 - MySQL
 - Raspbian

---
{% include JB/setup %}

Ich habe mir die Tage einen eigenen [DNS]-Server aufgesetzt. Er macht das Leben einfacher, wenn
man mehrere Dienste im eigenen Netzwerk betreibt. Dazu habe ich [PowerDNS] mit einem [MySQL]-Backend.
Das ganze lässt sich mit der Weboberfläche [poweradmin] sehr einfach bedienen. Man sollte aber bedenken,
dass jeder Fehler ein komisches Verhalten zur Folge haben kann, wenn man z.B. [Zone] im DNS überschreibt.

Die Installation auf dem [Raspberry Pi] mit [Raspbian] gestaltet sich realtiv einfach. Am besten macht macht
das ganze als `root`

### Installation von MySQL

``` bash
sudo apt-get install mysql-server mysql-client php5-mysql
```

Danach habt Ihr MySQL installiert und auch den php Client, welchen wir später noch brauchen. Während
der Installation werdet ihr nach dem `root`-Passwort für den MySQL Server gefragt.


### Installation von PowerDNS

Die Installation möchte Euch bei der Einrichtung der Datenbank behilflich sein. Aber wir konfigurieren
alles per Hand. Bei mir die automatische Konfiguration nicht so gut funktioniert.

``` bash
sudo su
apt-get install pdns-server pdns-backend-mysql dnsutils
```

### Einrichten der Datenbank

``` sql
CREATE DATABASE powerdns;
GRANT ALL ON powerdns.* TO powerdns@127.0.0.1 IDENTIFIED BY 'GeheimesPasswort';
FLUSH PRIVILEGES;
```

Das muss man in die `mysql` Konsole eintragen. Zu dieser gelangt man so:

``` bash
mysql -uroot -p
```

Nun importieren wir das Datenbank-Schema für PowerDNS

``` bash
mysql -uroot -p powerdns < /usr/share/doc/pdns-backend-mysql/nodnssec-3.x_to_3.4.0_schema.mysql.sql
```


### PowerDNS konfigurieren

Die Datei `/etc/powerdns/pdns.d/pdns.local.gmysql.conf` muss wie folgt verändert werden:

``` bash
# MySQL Configuration
#
# Launch gmysql backend
launch+=gmysql

# gmysql parameters
gmysql-host=127.0.0.1
gmysql-port=3306
gmysql-dbname=powerdns
gmysql-user=powerdns
gmysql-password=GeheimesPasswort
gmysql-dnssec=yes
# gmysql-socket=
```

Nun muss 


[DNS]: http://de.wikipedia.org/wiki/Domain_Name_System
[PowerDNS]: https://www.powerdns.com/
[MySQL]: http://de.wikipedia.org/wiki/MySQL
[poweradmin]: http://www.poweradmin.org/
[Zone]: http://de.wikipedia.org/wiki/Zone_%28DNS%29
[Raspberry Pi]: http://www.raspberrypi.org/help/what-is-a-raspberry-pi/
[Raspbian]: http://www.raspbian.org/
