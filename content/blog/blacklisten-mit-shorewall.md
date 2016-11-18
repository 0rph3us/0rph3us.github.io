+++
author = "Michael Rennecke"
categories = ["Sicherheit"]
date = "2016-11-18T21:40:09+01:00"
description = ""
featured = ""
featuredalt = ""
featuredpath = ""
linktitle = ""
title = "Blacklisten mit Shorewall"
type = "post"
tags = ["shorewall", "Firewall"]

+++


## Was ist Shorewall? ##

Man kann mit [shorewall] einfach [netfilter], aus dem Linux-Kernel, nutzen. Shorewall an sich st keine
Firewall. Es werden iptables-Regeln generiert.


## Backlisten von Spamhaus und DShield nutzen ##

[Spamhaus] und [DShield] veröffentlichen Blacklisten mit IP-Blöcken, welche von Spammern und Cyberkriminellen
verwendet werden. Mit dem folgenden Skript kann man sie sehr einfach in shorewall als statische Blacklist
nutzen.

{{< highlight sh >}}
#!/bin/sh

cat << EOF > /tmp/blrules
#ACTION         SOURCE                  DEST                    PROTO   DEST
#                                                                       PORTS(S)
EOF

wget -q -O - http://feeds.dshield.org/block.txt      | awk --posix '/^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.0/          { print "DROP    net:" $1 "/24    all";}' >> /tmp/blrules
wget -q -O - https://www.spamhaus.org/drop/drop.txt  | awk --posix '/^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}/ { print "DROP    net:" $1 "    all";}' >> /tmp/blrules
wget -q -O - https://www.spamhaus.org/drop/edrop.txt | awk --posix '/^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}/ { print "DROP    net:" $1 "    all";}' >> /tmp/blrules
mv /tmp/blrules /etc/shorewall/blrules

/sbin/shorewall refresh
{{< /highlight >}}

In der `/etc/shorewall/shorewall.conf` muss *BLACKLIST_DISPOSITION* auf *DROP* stehen. Bei Ubuntu 16.04 ist das nach der
Installation von shorewall schon der Fall.

### Achtung! ###

Man muss auf jeden Fall das Skript beim ersten mal ohne `/sbin/shorewall refresh` testen. Wenn ich eine neue
Konfiguration für shorewall teste, dann gehe ich wie folgt vor:


    shorewall check
    shorewall try /etc/shorewall/ 30s



[shorewall]: http://shorewall.net/
[netfilter]: http://www.netfilter.org/
[Spamhaus]: https://www.spamhaus.org/
[DShield]: http://www.dshield.org/

