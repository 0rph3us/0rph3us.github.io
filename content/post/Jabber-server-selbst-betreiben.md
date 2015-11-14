+++
Categories = ["Tools", "Linux", "Raspberry Pi"]
Description = ""
Tags = ["xmpp", "jabber", "prosody"]
date = "2015-11-04T06:55:11+01:00"
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
Das Paket `lua-sec-prosody` wird für TLS benötigt. Wenn man die aktuellste Version
installieren möchte, dann muss man das `prosody-0.10` statt `prosody` installieren.
Ich habe bis jetzt keine Probleme mit den nighly Builds gehabt.


## Konfiguration

Die Konfiguration wird in `/etc/prosody/prosody.cfg.lua` erledigt. Als erstes
In der Zeile `admins = { "admin@jabber.0rpheus.net" }` kann gleich
ein entsprechender Admin eingetragen werden. Um zusätzliche User
anzulegen gibt es zwei Möglichkeiten. Entweder direkt über einen
Jabber Client oder auf Zuruf durch einen Administrator. Ersteres
würde bedeuteten, dass sich jeder, der den Server kennt,
registrieren kann. Dazu muss die Zeile `allow_registration = false;`
auf `allow_registration = true;` geändert werden. Einen Nutzer
legt so an:

``` sh
prosodyctl adduser foo@jabber.0rpheus.net
```

Als nächstes wird die Domain konfiguriert.

```
VirtualHost "jabber.0rpheus.net"
        enabled = true

        -- Assign this host a certificate for TLS, otherwise it would use the one
        -- set in the global section (if any).
        -- Note that old-style SSL on port 5223 only supports one certificate, and will always
        -- use the global one.
        ssl = {
                ciphers     = "AES256+EECDH:AES256+EDH:AES128+EECDH:AES128+EDH";
                key         = "/etc/prosody/certs/jabber.0rpheus.net.key";
                certificate = "/etc/prosody/certs/jabber.0rpheus.net.crt";
                dhparam     = "/etc/prosody/certs/dh-4096.pem";
                protocol    = "tlsv1_2";
        }
```

Die globalen SSL Einstellungen können entweder entfernt oder
ebenfalls mit denselben Werten nochmal befüllt werden.

Per Default speichert Prosody die Passwörter im Klartext ab,
um mit alten Clients kompatibel zu sein. Wer das nicht möchte bzw.
nicht braucht, kann die Passwörter gehashed abspeichern.
Dazu muss eine zusätzliche Zeile hinzugefügt werden.

``` lua
authentication = "internal_hashed"
```

Um die Änderungen zu aktivieren, muss der Prosody Dienst
einmal durchgestartet werden.

```sh
systemctl restart prosody
```

Folgende Portfreischaltungen werden für einen reibungslosen Betrieb noch benötigt.

* Port 5222 eingehend (Clientverbindungen)
* Port 5280 eingehend (Clientverbindungen) (http-bind)
* Port 5281 eingehend (Clientverbindungen) (https-bind)
* Port 5269 ein- und ausgehend Verbindung zu fremden Servern


[2 Tage nicht verfügbar]: https://ccc.de/de/updates/2015/jabbercccde
[XMPP]: https://de.wikipedia.org/wiki/Extensible_Messaging_and_Presence_Protocol
[XML]: https://de.wikipedia.org/wiki/Extensible_Markup_Language
[Prosody]: http://prosody.im/
[ejabberd]: https://www.ejabberd.im/
[TLS]: https://de.wikipedia.org/wiki/Transport_Layer_Security
