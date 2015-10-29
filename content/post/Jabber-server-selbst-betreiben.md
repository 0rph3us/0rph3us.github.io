+++
Categories = ["Tools", "Linux", "Raspberry Pi"]
Description = ""
Tags = ["xmpp", "jabber", "prosody"]
date = "2015-10-25T14:55:11+01:00"
title = "Einen Jabber Server selbst betreiben"

+++

Am 30.09.2015 war `jabber.ccc.de` für [2 Tage nicht verfügbar].
Das hat mich motiviert endlich einen eigenen jabber-Server zu
betreiben.

Hinter Jabber steckt das offene Protokoll [XMPP]
(Extensible Messaging and Presence Protocol), welches dem
[XML] Standard folgt und für Instant Messaging (Chats) genutzt wird.
Ich habe mich für [Prosody] als Jabber-Server entschieden. Für
Prosody sprechen, aus meiner Sicht, seine einefache Konfiguration
sowie seine Schlankheit. Eine Alternatibe ist [ejabberd].

## Installation
Damit man Prosody installieren kann, sollte man das Repository
der Entwickler einbinden. Ich nehme auch bei `jessie` als
Distribution `whezzy`, weil [TLS] mit mit den `jessie` Paketen
nicht funktioniert.

``` sh
# zu root werden bzw. sudo vor echo und tee schreiben
echo deb http://packages.prosody.im/debian wheezy main | tee -a /etc/apt/sources.list.d/prosody.list
wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -
```
Nun kann man Prosody installieren

``` sh
apt-get update && apt-get install prosody lua-sec-prosody
```
Das Paket `lua-sec-prosody` wird für TLS benötigt.


[2 Tage nicht verfügbar]: https://ccc.de/de/updates/2015/jabbercccde
[XMPP]: https://de.wikipedia.org/wiki/Extensible_Messaging_and_Presence_Protocol
[XML]: https://de.wikipedia.org/wiki/Extensible_Markup_Language
[Prosody]: http://prosody.im/
[ejabberd]: https://www.ejabberd.im/
[TLS]: https://de.wikipedia.org/wiki/Transport_Layer_Security
