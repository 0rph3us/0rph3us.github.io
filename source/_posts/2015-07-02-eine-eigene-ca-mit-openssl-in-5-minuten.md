---
layout: post
title: "Eine eigene CA mit OpenSSL in 5 Minuten"
description: ""
category: 
 - sicherheit
tags:
 - SSL
 - TLS
 - OpenSSL
 - CA
 - Nginx
---
{% include JB/setup %}

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

# Certificate Authority erstellen

Als erstes muss man einen geheimen privaten Schlüssel generieren:

``` sh
openssl genrsa -aes256 -out ca-key.pem 4096
```

Der Schlüssel wird in der Datei `ca-key.pem` gespeichert und hat eine Länge von 4096 Bit. Man kann ihn
auch länger machen.


[^1]: Seit TLS 1.0 kann man auch durch [SNI] mehrere Zertifikate nutzen. SNI unterstützen ältere Browser noch nicht, evtl. hat man auch mit Apps Probleme,
wenn sie SNI nicht unterstützen. Eine weitere Alternative sind SAN-Zertifikate (diese sind auf mehrere Subdomains ausgestellt), diese gibt es auch nicht für lau.

[^2]: Dazu muss sie aber aus seinen Browser und Betriebssystem löschen. Das ist nicht unbedingt sehr sinnvoll.

[TLS]: https://de.wikipedia.org/wiki/Transport_Layer_Security
[SNI]: https://de.wikipedia.org/wiki/Server_Name_Indication
