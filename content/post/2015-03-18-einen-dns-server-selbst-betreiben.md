---
layout: post
title: "Einen DNS Server selbst betreiben"
date: 2015-03-18
description: ""
categories: 
 - linux
 - 'raspberry pi'
tags:
 - Linux
 - DNS
 - PowerDNS
 - MySQL
 - Raspbian

---


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

Nun muss  man sie noch schützen `sudo chmod 660 /etc/powerdns/pdns.d/pdns.local.gmysql.conf`. Nun
wurder Der Server nur lokal funktionieren und nur seine eigenen Zonen auflösen können. Damit man
er auch noch über alle anderen Zonen Auskunft geben kann und jedes Gerät im LAN ihn nutzen kann
muss man ein paar Zeilen in der `/etc/powerdns/pdns.conf` ändern 
(sie sind schön auskommentiert enthälten, ohne Parameter). 

```
recursor=8.8.8.8

allow-recursion=127.0.0.1,192.168.0.0/24
```

Ich gehe davon aus, dass Euer LAN ein 192.168.0.0/24 Netz ist, sonst anpassen ;-).

### Test

Wenn alles funktioniert, dann kann man den DNS Server wie folgt testen:

```
dig google.de @8.8.8.8  

; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> google.de @127.0.0.1
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 49993
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.de.                     IN      A

;; ANSWER SECTION:
google.de.              299     IN      A       173.194.32.255
google.de.              299     IN      A       173.194.32.248
google.de.              299     IN      A       173.194.32.239
google.de.              299     IN      A       173.194.32.247

;; Query time: 87 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Wed Mar 18 07:12:42 CET 2015
;; MSG SIZE  rcvd: 102
```

### Poweradmin installieren

Damit man den DNS Server einfach/schnell bedienen kann, installiert man [poweradmin]. Das ist
eine php-Anwendung mit der man seinen PowerDNS Server einfach konfigurieren kann.

Als erstes installiert man einen Webserver und php. Auf dem Raspberry Pi macht sich in meinen
Augen [Nginx] ganz gut. Wie man diesen installiert kann man in [diesem Artikel] nachlesen.

Um mit der eigenlichen Installation zu beginnen muss man nich php-mcrypt installieren.

```
sudo apt-get install php5-mcrypt
```

Nun beginnt die Installtion

```
sudo su
cd /var/www
wget https://github.com/poweradmin/poweradmin/archive/v2.1.7.zip
unzip v2.1.7.zip
rm v2.1.7.zip
mv poweradmin-2.1.7 poweradmin
cat << EOF > /etc/nginx/sites-available/powerdns
server {
    listen 80;
    server_name <IP des Raspberry Pi>;
    
    root /var/www/poweradmin;
    index index.html index.php;
    
    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ ^(.+\.php)(.*)$ {
        try_files $fastcgi_script_name =404;
        fastcgi_split_path_info  ^(.+\.php)(.*)$;
        fastcgi_pass   unix:/var/run/php5-fpm.sock;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_param  PATH_INFO        $fastcgi_path_info;
        include        /etc/nginx/fastcgi_params;
    }

    access_log      /var/log/nginx/poweradmin.access.log;
    error_log       /var/log/nginx/poweradmin.error.log;
}
EOF
ln -s /etc/nginx/sites-available/powerdns /etc/nginx/sites-enabled/powerdns
service nginx reload
```

Nun kann man seinen Server einfach konfigurieren. Dazu öffnet man http://<IP Raspberry Pi> im Browser
und konfiguriert erst einmal Poweradmin und dann kann man gleich loslegen mit dem anlegfen von neuen
Zonen. Das ganze ist recht selbsterklärend.


[DNS]: http://de.wikipedia.org/wiki/Domain_Name_System
[PowerDNS]: https://www.powerdns.com/
[MySQL]: http://de.wikipedia.org/wiki/MySQL
[poweradmin]: http://www.poweradmin.org/
[Zone]: http://de.wikipedia.org/wiki/Zone_%28DNS%29
[Raspberry Pi]: http://www.raspberrypi.org/help/what-is-a-raspberry-pi/
[Raspbian]: http://www.raspbian.org/
[diesem Artikel]: {{< ref "2014-07-31-webserver-auf-dem-raspberry-pi-installieren.md" >}}
[Nginx]: http://nginx.org/
[php-mcrypt]: http://php.net/manual/de/book.mcrypt.php
