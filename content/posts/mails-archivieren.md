---
type: post
title: "Emails automatisch archivieren"
date: 2023-06-26
description: ""
author: "Michael Rennecke"
categories:
 - Infrastruktur
tags:
 - mail
 - postfix
---

Aus verschiedenen Gründen müssen wir bei meinen Arbeitgeber aus automatisch
generierte Mails archivieren. Das Problem ist, dass diese Mails zum Teil nur
per [SMTP] verschickt werden. Dadurch laden sie auch nicht in einer INBOX.

Ich habe mich gefragt, wie man das quick&dirty umsetzen könnte. Dabei bin ich
auf die Idee gekommen, dass der [postfix] die Mails noch einmal an sich selbst
senden könnte. Die Mails landen dann in einem lokalen [maildir]. Der Vorteil vom
maildir-Format ist, dass man die archivieren Mails sehr einfach löschen kann.

* Nutzer erstellen
```shell
adduser --system --home /var/archive/mail/ --no-create-home --disabled-password mailarchive
```
* maildir anlegen
```shell
mkdir -p /var/archive/mail/tmp
mkdir -p /var/archive/mail/cur
mkdir -p /var/archive/mail/new
chown -R nobody:nogroup /var/archive
```
* *mailarchive* alias anlegen
```shell
echo "mailarchive: /var/archive/mail/" >> /etc/aliases
newaliases
```
* postfix soll **alle** Mails ans *mailarchive* senden
```shell
postconf -e always_bcc=mailarchive@localhost
systemctl reload postfix
```
* Mails, die älter 90 Tage sind löschen
```shell
find /var/archive/mail/ -type f -mtime +90 -delete
```

Nun werden **alle** ein- und ausgehenden Mails auch ans *mailarchive* via BCC geschickt.
Die Mails kann man sich direkt im Dateisystem ansehen oder man benutzt [mutt]: `mutt -f /var/archive/mail/`.

Das ganze ist keine perfekte Lösung, sie ist aber recht einfach. Falls man eine ähnliche
Anforderung hat, dann kann man mit diesen "BCC-Tick" auch eine produktive Lösung bauen. Das schöne ist,
dass man eine entsprechende Regel auch bein einigen Anbietern konfigurieren kann. Dann sendet man
die Mails natürtlich zu einen anderen Account. Dieser kann auch bei einen anderen Anbieter/Server sein.

[SMTP]: https://de.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol
[postfix]: https://www.postfix.org/
[maildir]: https://de.wikipedia.org/wiki/Maildir
[mutt]: http://www.mutt.org/