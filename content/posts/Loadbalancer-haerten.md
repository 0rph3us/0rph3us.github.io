+++
title = "Loadbalancer und Webserver härten"
date = "2017-07-31T15:16:24+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["security", "haproxy"]
categories = ["Infrastruktur", "Sicherheit"]
+++

Im Artikel [Cracking the Lens: Targeting HTTP's Hidden Attack-Surface] wird unter anderem gezeigt, welche
Auswirkungen nicht valider Host-Header auf die eigene Infrastruktur haben können. Man kann sich vor derartigen
Angriffen relativ leicht schützen. Als erstes muss man entscheiden, ob man pfad- oder hostbasiert Routingentscheidungen
trifft. Man sollte pro Loadbalancer/Reverseproxy/Webserver nur ein Unterscheidungsmerkmal nutzen. 

Wenn man beides zulässt, dann **muss** festlegen und auch sicherstellen, dass z.B. immer zuerst der Pfad 
*/.well-known/acme-challenge/* auf den Webserver für die Let's Encrypt Challenge geroutet wird.
Anschließend routet man nur noch anhand von Hostnamen. Wenn man keine Reihenfolge sicher stellt baut man
evtl. eine Backdoor ein.

## Apache und Nginx

Mit [Apache] und [Nginx] lässt sich ein auch ein hostbasiertes Routing bauen. Wenn man die folgenden Punkte beachtet,
gibt es auch weniger Überraschungen:

* Default-vhost in der Datei `000_default` einrichten
* ein vhost pro Datei
* interne vhosts lauschen nur auf internen Interfaces
* bei Hostnames bzw. Aliases Wildcards vermeiden und lieber alles Domains aufschreiben

Der Default-vhost gibt entweder immer einen Status 500 zurück oder eine nette Fehlerseite. So erhält man immer
einen Fehler. Sonst kommt es vor, dass nicht erwünschte Requests vom *ersten* vhost bearbeitet werden.
Gerade die letzte Regel ist wichtig, sowie man Wildcards verwendet verhalten sich die Webserver anders als
man denkt. Es gewinnt in der Regel der First-Match und nicht der Best-Match. Ich habe schon einige *kreative*
Konstruktionen gesehen, die offen wie ein Scheunentor waren.

### Fallstrick

Die Host-Header werden in Zusammenhang [mit Ports] nicht immer richtig ausgewert, d.h. es findet mitunter
keine Unterscheidung zwichen *expample.com*, *example.com:80* und *example.com:8080* statt.

## HAProxy

Ich muss zugeben, dass ich ein [HAProxy]-Fanboy bin, aber wenn man es mit *Routingfasching* zu tun hat, dann
gibt es kein besseres Tool. Wenn man bei HAProxy nur nach Hostnames routen möchte, dann hat sich die folgende
Syntax, mit Map-Files, bewährt:

{{< highlight text >}}
use_backend bk_%[req.hdr(host),lower,map(/etc/haproxy/host2backends.map,error)]
{{< /highlight >}}

Die Datei `/etc/haproxy/host2backends.map` besteht aus Key-Value Paaren. Der Key ist der Hostname und der Value
ist der Name des HAProxy-Backends ohne den Prefix *bk_*

{{< highlight text >}}
cat /etc/haproxy/host2backends.map
# Hostname     backend name
example.com    example.com
example.de     example.com
foo.org        foo.org
foo.net        foo.net
{{< /highlight >}}

Die Backends nach dem Beispiel haben die Namen `bk_example.com`, `foo.org` und `foo.net`. Diese Map-Dateien sind
auch performanter, als einzelne `use_backend`-Anweisungen, da beim Start ein [Präfixbaum] aus der Datei generiert
wird. Wenn kein Treffer gefunden wurde, dann wird das Backend `bk_error` genommen. Falls es kein Default-Backend
gibt, dann gibt HAProxy den Status-Code 500 zurück.

[Nginx]: https://nginx.org
[Apache]: https://httpd.apache.org/
[HAProxy]: http://www.haproxy.org/
[mit Ports]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.23
[Präfixbaum]: https://de.wikipedia.org/wiki/Trie
[Cracking the Lens: Targeting HTTP's Hidden Attack-Surface]: http://blog.portswigger.net/2017/07/cracking-lens-targeting-https-hidden.html