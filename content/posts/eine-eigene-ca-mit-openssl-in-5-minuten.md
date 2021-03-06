---
type: post
title: "Eine eigene CA mit OpenSSL in 5 Minuten"
date: 2015-07-07
description: ""
categories: 
 - Sicherheit
tags:
 - SSL
 - TLS
 - OpenSSL
 - CA
 - Nginx
---


Wenn man seine eigenen Dienste mit SSL/[TLS] absichern möchte benötigt man Zertifikate. Inzwischen
gibt es auch kostenlose Zertifikate, diese haben aber Einschränkungen. Wenn man dynDNS verwendet bekommt
man keine offizellen Zertifikate, da man nicht der Eigentümer der Domain ist. Oft hat jeder Dienst, den man
anbietet auch einen eigene Subdomain. Wenn man mehrere Subdomains auf dem selben Port benötigt man ein
Wildcard-Zertifikat[^1]. Dieses ist nach meinen Kenntnisstand nicht kostenlos zu bekommen.

Wenn man nicht nur einen Webserver, sondern auch einen Jabber-Server betreibt lohnt es sich eine eigene
CA (Certificate Authority) betreiben, mit der man alle seine Zertifikate unterschreibt. Damit alle Clients
der CA vertrauen muss diese nur bekannt machen. Danach wird allen Zertifikaten vertraut, welche von der CA
unterschrieben wurden.

Ein weiterer Vorteil: Mit der eigenen CA ist man im Zweifel auf der sicheren Seite. In den letzten Jahren
ist es öfter vorgekommen, dass gefälschte Zertifikate im Umlauf waren. Es gibt also Gründe den großen
CAs zu misstrauen[^2].

## Certificate Authority erstellen

Als erstes muss man einen geheimen privaten Schlüssel generieren:

``` sh
openssl genrsa -aes256 -out ca-key.pem 4096
```

Der Schlüssel wird in der Datei `ca-key.pem` gespeichert und hat eine Länge von 4096 Bit. Man kann auch einen
längeren bzw. kürzeren Schlüssel erzeugen. 2048 Bit sehe ich als absolutes Minimum an. Durch Verwendung der
Option `-aes256` wird der Schküssel mit einem Passwort geschützt. Der Schlüssel der CA muss besonderst 
geschützt werden, denn mit ihm könnte sich ein Angreifer beliebige Zertifikate ausstellen. Die Verschlüsselung
mit einem Passwort bietet einen zusätzlichen Schutz. Das Passwort muss man bei jeder Verwendung des Schlüssels
eingeben.


Als nächstes muss man das root-Zertifikat der CA erzeugen. Dieses kann man dann in die Browser und in die
Betriebssysteme importieren. Das Zertifikat wird wie folgt generiert:

``` sh
openssl req -x509 -new -nodes -extensions v3_ca -key ca-key.pem -days 3650 -out ca-root.pem -sha512
```

Dieses Zertifikat hat eine Gültigkeit von 10 Jahren (3650 Tage). Die Attribute der CA können wie folgt sein:

``` sh
Country Name (2 letter code) [AU]:DE
State or Province Name (full name) [Some-State]:Saxony-Anhalt
Locality Name (eg, city) []:Halle (Saale)
Organization Name (eg, company) [Internet Widgits Pty Ltd]:bude
Organizational Unit Name (eg, section) []:IT
Common Name (eg, YOUR name) []:example.net
Email Address []:meine.email-adresse.net
``` 

## Root-Zertifikat auf den Clients importieren


### Debian / Ubuntu

``` sh
sudo cp ca-root.pem /usr/share/ca-certificates/myca-root.crt
sudo dpkg-reconfigure ca-certificates
```

### Mozilla Firefox / Thunderbird

Mozilla Firefox verwaltet Zertifikate selbst. Ein neues Zertifikat wird importiert unter *Einstellungen* => *Erweitert* => *Zertifikate* => *Zertifikate anzeigen* => *Zertifizierungsstellen* => *Importieren*. Wählt die Datei `ca-root.pem` aus. Wählt die Option *Dieser CA vertrauen, um Websites zu identifizieren*.

### Chromium / Google Chrome

*Einstellungen* => *Erweiterte Einstellungen anzeigen* (unten) => *HTTPS/SSL* => *Zertifikate verwalten* => *Zertifizierungsstellen* => *Importieren* => `ca-root-pem` auswählen => *Diesem Zertifikat zur Identifizierung von Websites vertrauen*


## Ein neues Zertifikat ausstellen

Als erstes muss man sich wieder einen privaten Schlüssel erzeuge.

``` sh
openssl genrsa -out cert-key.pem 4096
```

Bei den Zertifikaten sollte man in den meisten Fällen kein Passwort setzten. Wenn man es z.B. für einen Webserver benötigt,
dann müsste man das Passwort bei jedem Start eingeben.

Nun muss man eine Zertifikatsanfrage erstellen. Ganz wichtig ist der __Common Name__ dieses Attribut *muss* so lauten, wie der Hostname
des Servers, auf den es ausgestellt ist. Wenn man nur via IP zugreifen möchte, dann ist der Common Name die IP, mit den man den Dienst
ansprechen möchte. Es sind auch Wildcard-zertifikate möchte *.example.com gilt für foo.example.com bar.example.com, aber nicht für foo.bar.example.com.


``` sh
openssl req -new -key cert-key.pem -out cert.csr -sha512
```

Wenn man fertig ist, dann erhält man die Zertifikatsanfrage in `cert.csr`, die kann von CA weiter verarbeitet werden. Dabei wird der öffentliche
Schlüssel des angefragten Zertifikats. 


Mit der root-CA, deren Schlüssel und der Zertifikatsanfrage erstellt man ein signiertes Zertifikat, welches 1 Jahr gültig ist.

```sh
openssl x509 -req -in cert.csr -CA ca-root.pem -CAkey ca-key.pem -CAcreateserial -out cert-pub.pem -days 365 -sha512
```

Openssl fragt nach dem dem Passwort der root-CA. Wenn dan signierte Zertifikat erstellt wurde kann man die Zertifikatsanfrage `cert.csr` löschen. 
Das öffentliche Zertifikat befindet sich in der Datei `cert-pub.pem`.


## Das Zertifikat benutzen

Für einen Webserver benötigt man die folgenden 3 Teile:

- Privater Schlüssel des Zertifikats `cert-key.pem`
- Öffentlicher Schlüssel des Zertifikats `cert-pub.pem`
- Öffentlicher Schlüssel der CA `ca-root.pem`

Je nach Server ist es nötig die CA und den öffentlichen Schlüssel in einer Datei zu haben. Das kann man wie folgt machen:

``` sh
cat ca-root.pem >> cert-pub.pem
```


[^1]: Seit TLS 1.0 kann man auch durch [SNI] mehrere Zertifikate nutzen. SNI unterstützen ältere Browser noch nicht, evtl. hat man auch mit Apps Probleme,
wenn sie SNI nicht unterstützen. Eine weitere Alternative sind SAN-Zertifikate (diese sind auf mehrere Subdomains ausgestellt), diese gibt es auch nicht für lau.

[^2]: Dazu muss sie aber aus seinen Browser und Betriebssystem löschen. Das ist nicht unbedingt sehr sinnvoll.

[TLS]: https://de.wikipedia.org/wiki/Transport_Layer_Security
[SNI]: https://de.wikipedia.org/wiki/Server_Name_Indication
