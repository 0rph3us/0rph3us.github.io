+++
Categories = ["privat", "Sicherheit"]
Description = ""
Tags = ["HAProxy", "SSL"]
date = "2015-09-15T05:50:08+02:00"
title = "Guten Morgen"
type = "post"

+++

Ich habe schon länger keinen neuen Post hinterlassen. Es
lag unter anderen daran, dass ich umgezogen bin. Der größte
Teil des Umzuges ist inzwischen geschafft und alles ist an
seinen Platz.

In der Zwischenzeit war nicht untätig, Ich habe mit [HAProxy]
etwas experimentiert. Ziel war es Zertifikate mit RSA und [Elliptische Kurven][^1] für den selben Hostname/FQDN anzubieten.

Weswegen möchte man das eigenlich machen? Zertifikate mit
RSA sind sehr lang (größergleich 4096 Bit), wenn man
paranoit ist. Diese langen Zertifikate kosten Zeit bei der Übertragung und Rechenkraft beim Handshake. Aus diesem Grud liegt es nahe Zertifikate mit Elliptischen Kurven zu nutzen. Die größten Kurven haben eine Länge von 571 Bit. Dabei wird eine sehr höhere Sicherheit erreicht, als mit 8096 Bit langen RSA Schlüssel und sie lassen schneller berechnen.

Da ich auf meinen Raspberry Pi zahlreiche Dienste betreibe, welche per SSL abgesichert sind, habe ich Stern-Zertifiake generiert. Wenn HAProxy eine eigene (Sub)[CA] hat, dann ist es möglich, dass bei jeder Anfrage mit einen neuen Hostname ein neues Zertifikat generiert wird.


## Umsetzung ##

In den aktuellen Developer Builds von HAProxy, aktuell 1.6-dev4 ist möglich ECC und RSA Zertifikate auf der selben IP und Port zu betreiben. Weiherhin ist es möglich Zertifikate zu generieren. Das dumme war nur, dass es nicht richtig mit Elliptischen Kurven funktioniert. Nach einiger Diskussion über den Sinn dieses Setups hat mit Christopher Faulet einen Patch geschieben, welcher funktioniert. Da der Patch auch bei mir funktioniert, gibt Christopher upstream.

### Testconfig ###

```
global
        daemon
        maxconn 256

        ssl-default-bind-ciphers AES256+EECDH:AES256+EDH
        ssl-default-bind-options force-tlsv12
        tune.ssl.default-dh-param 4096
        tune.ssl.lifetime 600


defaults
        mode http
        timeout connect 5000ms
        timeout client 50000ms
        timeout server 50000ms


frontend ssl-relay
        mode tcp
        bind 0.0.0.0:443

        use_backend ssl-ecc if { req.ssl_ec_ext 1 }
        default_backend ssl-ecc


backend ssl-ecc
        mode tcp

        server ecc unix@/var/run/haproxy_ssl_ecc.sock send-proxy-v2


backend ssl-rsa
        mode tcp

        server rsa unix@/var/run/haproxy_ssl_rsa.sock send-proxy-v2


listen webfarm
        bind unix@/var/run/haproxy_ssl_ecc.sock accept-proxy ssl crt /etc/haproxy/ecc_test.rennecke.dyndns.dk.pem tls-ticket-keys /etc/haproxy/ticket_keys ca-sign-file /etc/haproxy/ecc_subca.pem user nobody generate-certificates ecdhe secp521r1
        bind unix@/var/run/haproxy_ssl_rsa.sock accept-proxy ssl crt /etc/haproxy/rsa_star.rennecke.dyndns.dk.pem tls-ticket-keys /etc/haproxy/ticket_keys ecdhe secp521r1 user nobody
        mode http

        acl admin               path_beg /haproxy
        use_backend admin       if admin

        server nginx 127.0.0.1:88 check

backend admin
        stats enable
        stats hide-version
        stats show-legends
        stats realm Haproxy\ Statistics
        stats uri /haproxy?stats
        stats refresh 30s
```

In dieser Config generiere ich nur die ECC-Zertifikate für alle Hosts, außer `test.rennecke.dyndns.dk`. Das ganze Setup funktioniert, aber es läuft noch nicht ganz rund.

[HAProxy]: http://www.haproxy.org/
[Elliptische Kurven]: http://www.cs.uni-potsdam.de/ti/lehre/05-Kryptographie/slides/Elliptische_Kurven.pdf
[CA]: https://de.wikipedia.org/wiki/Zertifizierungsstelle
[^1]: Man schreibt auch oft [ECC](https://de.wikipedia.org/wiki/Elliptic_Curve_Cryptography) (Elliptic Curve) Cryptography
