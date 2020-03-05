---
title: "Basic Auth mit HAProxy"
date: 2020-03-05T20:04:07+01:00
draft: false
description:
categories:
 - Linux
tags:
 - haproxy
featured_image:
author: ""
---

Ich habe öft das Problem, dass Dienste keine Authentifizierung haben und bequem per Internet erreichbar sein müssen oder
man möchte bestimmte Ressourcen schützen. Weiterhin möchte man aus Bequemlichkeit ein Whitelisting für bestimmte IP-Netze
oder IPs. Es gibt auch ein LDAP oder Active Directory. Im folgenden Beispiel gilt das Netz 192.88.99.0/24 und die 
IP 203.0.113.42 als vertrauenswürdig. Wir haben die Domains foo.example, bar.example, geheim.example und streng.geheim.example.
Die Dienste geheim.example und streng.geheim.example müssen geschützt werden.

## Umsetzung

Ich benutze wieder mein persönliches Schweizer Taschenmesser: [HAProxy] mit [map-Files]. Der HAProxy nimmt auf Port 80
undn 443 Verbindungen entgegen. Den Port 81 verwende ich nur für internen Traffic. Dieser ist nicht
extern erreichbar. Alle HTTP Verbindungen von bekannten Domains bekommen einen Redirect zu HTTPS. Man sollte keine
unbekannten Domains umleiten, da man für diese kein Zertifikat hat. Aus diesem Grund werden diese Anfragen zum Backend
**bk_error** weitergeleitet. Dabei kann es sich um eine Fehlerseite oder eine Umleitung auf die eigene Homepage handeln.

Es gibt 2 Map-Files. In der Datei `/etc/haproxy/hosts_for_basisauth.map` befinden sich alle Domains, welche eine
Authentifizierung benötigen. Die Datei `/etc/haproxy/hostname2backend.map` ist ein klassisches Map-File, welches einer
Domain ein Backend zuordnet. Für die Authentifizierung kann man einen Apache mit einer Basic Auth und Reverse Proxy verwenden.
Dieser lauscht auf Port 127.0.0.1:8080 und leitet alles an den HAProxy zu 127.0.0.1:81 weiter. Das Whielisting wird über die
ACL **intern** gesteuert, wobei **dst_port 81** Pflicht ist. Sonst hat man eine Schleife gebaut.

### /etc/haproxy/hosts_for_basisauth.map

{{< highlight config >}}
geheim.example
streng.geheim.example
{{< /highlight >}}

### /etc/haproxy/hostname2backend.map

{{< highlight config >}}
foo.example             foo_example
bar.example             bar_example
geheim.example          geheim_example
streng.geheim.example   streng_geheim_example
{{< /highlight >}}

### Ausschnitt aus der haproxy.cfg

{{< highlight config >}}
...

frontend http
    bind *:80  name http
    bind *:443 name https ssl crt /etc/haproxy/certs/star.pem
    bind 127.0.0.1:81  name intern

    # HSTS (31536000 seconds = 1 year)
    http-response set-header Strict-Transport-Security       max-age=31536000

    # set protocoll headers to  https 
    # works only if all https redirects happens in HAProxy
    http-request set-header  X-Forwarded-Proto              https

    # trusted sources
    acl intern               src 192.88.99.0/24
    acl intern               src 203.0.113.42
    acl intern               dst_port 81

    # force https for known domains
    acl hostname_has_backend hdr(Host),lower,map(/etc/haproxy/hostname2backend.map) -m found
    http-request redirect scheme https code 301  if !{ ssl_fc } hostname_has_backend !{ dst_port 81 }

    # routing with basic auth and whitelisting for ACL intern
    acl basic-auth_domain hdr(Host),lower,map(/etc/haproxy/hosts_for_basisauth.map) -m found
    use_backend bk_basic-auth                        if basic-auth_domain !intern

    # routing for known domains
    use_backend bk_%[hdr(Host),lower,map(/etc/haproxy/hostname2backend.map)]   if hostname_has_backend

    default_backend bk_error


backend bk_basic-auth
    server apache 127.0.0.1:8080 check

...
{{< /highlight >}}

## Fazit

Mit diesem Ansatz kann man bequem eine Basic Auth realisieren. Man muss nur 2 Map-Files pflegen, was die Wartung und
die Generierung der Konfiguration mit Puppet oder Ansible sehr einfach macht.

[HAProxy]: http://www.haproxy.org/
[map-Files]: {{< ref "map-files-mit-haproxy.md" >}}