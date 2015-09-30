---
layout: post
title: "Webserver auf dem Raspberry Pi installieren"
date: 2014-07-31
description: ""
categories: 
 - Raspberry Pi
 - Linux
tags:
 - Raspberry Pi
 - Linux
 - Raspbian
 - Nginx
 - php
---


Da man auf dem [Raspberry Pi] nicht sehr viele Ressourcen zur Verfügung hat, scheidet [Apache] als
Webserver für mich aus. Ich habe [lighttpd] und [Nginx] ausprobiert. Von [lighttpd] war ich am 
Anfang sehr überzeugt. Er kann alles was man benötigt. Als mein Setup komplizierter wurde, war
ich nicht mehr in Lage in die Ideen mit [lighttpd] umzusetzen. Die Ursache liegt weniger im
Funktionsumfang, sondern an den zur Verfügung stehenden Tutorials, Beispielkonfigurationen sowie der
Default-Konfiguration wenn man [lighttpd] bei Raspbian installiert. Den endgültigen *Todesstoß* hat
[lighttpd] bekommen, als ich [Passanger] ausprobieren wollte. Für [Apache] und [Nginx] gibt es fertige
[Passanger]-Module bzw. funktionierenden Install-Skripte. Ich möchte nicht sagen, dass [lighttpd] schlechter
als [Nginx] ist, aber ich bin bei "komplexen" Setups mit mehreren virtuellen Hosts und rewrite-Magie
besser mit [Nginx] zurecht gekommen.

Im folgenden werde ich mich auf [Nginx] *Engine-X* konzentrieren. da es für ihn sehr viele Tutorials
gibt und er sehr ressourcenschonend ist, ist er meiner Meinung nach die erste Wahl für den [Raspberry Pi].

Viele werden mit nur einen Webserver nicht glücklich, weil ein Webserver nur statische Inhalte ausliefert.
Damit Nginx php ausliefern kann benötigt man php auf seinen Rechner sowie den 
PHP Fast CGI Process Manager. Dieser verwaltet php-Prozesse, welche wiederum statisches HTML generieren
und an den Nginx weiter geben.

## Nginx mit php installieren und einrichten ##

Vor der Installation von neuen Pakten sollte man nachsehen, ob es Updates gibt. Ein 
sicherheitsbewusster Admin aktualisiert jeden Tag seine Systeme,
gerade wenn sie öffentlich erreichbar sind.

```
# zu root werden
sudo su -

apt-get update
apt-get upgrade

apt-get install nginx php5-fpm php5-cgi php5-cli php5-common
```

### Nginx konfigurieren ####

Wenn man nur einen virtuellen Host einrichten möchte, kann man die gesamte Konfiguration in der
`/etc/nginx/ningx.conf` erledigen. Das Aufteilen der Konfiguration in mehrere Dateien macht diese
übersichtlicher. Somit ist es auch möglich virtuelle Host zu aktivieren und zu deaktivieren.

Meine Empfehlung ist, dass jede Applikation/Seite ein eigener Host ist. So hat jede Applikation
ihr eigenes Log-File und eine übersichtliche Konfiguration.
Der Nachteil ist, dass man mehrere (Sub) Domains benötigt. Das ist nicht
mit allen Dyndns Anbietern möglich.

Konfigurationen, welche global gültig sind, schreibe ich auch
in die `/etc/nginx/ningx.conf`. Das sind z.B. ssl-Offloading, Redirekt zu https und die 
ssl-Konfiguration.


Das ist eine exemplarische Konfiguration eines Host, welcher php ausführt und auf Port 80 lauscht.
Der Host lauscht auf die Namen *localhost* und *awesomephp.example.com*. Port 80 ist der
Standardport für http. Wenn ihr nur einen Host konfiguriert habt (nur ein server-Abschnitt), dann
wird dieser immer genommen, unabhängig davon was im host-Header der Anfrage steht.

```
server {
    listen 80;
    server_name localhost awesomephp.example.com;
    
    root /var/www/awesomephp;
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

    access_log      /var/log/nginx/awesome.access.log;
    error_log       /var/log/nginx/awesome.error.log;
}
```

Nachdem der Nginx konfiguriert ist muss man die Konfiguration nur noch neu laden.

```
service nginx reload
```

### Test der Konfiguration ###

Nachdem der Nginx fehlerfrei seine Konfiguration neu geladen hat bzw. neu gestartet wurde kann man sie mit dem
folgenden Minimalbeispiel testen: 

```
mkdir -p /var/www/awesomephp
echo "<? phpinfo(); />" > /var/www/awesomephp/info.php
```

Wenn nur ein Host konfiguriert ist, dann kann man jetzt Browser `http://192.168.1.100/info.php` aufrufen
und es erscheint eine Übersicht der php-Einstellungen. Ich gehe davon aus, dass der Raspberry Pi die IP
192.168.1.100 hat.

[Apache]: http://httpd.apache.org/
[lighttpd]: http://www.lighttpd.net/
[Nginx]: http://nginx.org
[Passanger]: https://www.phusionpassenger.com/
[Raspberry Pi]: http://www.raspberrypi.org/
