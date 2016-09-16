+++
author = ""
categories = ["Linux", "Datenbank"]
tags = ["MySQL", "Ubuntu", "Debian"]
date = "2016-09-16T19:55:16+02:00"
description = ""
featured = ""
featuredalt = ""
featuredpath = ""
linktitle = ""
title = "debian-sys-maint MySQL user wiederherstellen"
type = "post"

+++

Wenn man MySQL unter Ubuntu oder Debian per Hand komplett neu installiert, dann muss
man den User *debian-sys-maint* anlegen, sonst gibt es Probleme den orginalen 
Start-Skripen und bei Updates.

Zuerst muss man das Passwort auslesen bzw. neu setzen. Man findet es in der Datei 
`/etc/mysql/debian.cnf`.

{{< highlight ini >}}
# Automatically generated for Debian scripts. DO NOT TOUCH!
[client]
host     = localhost
user     = debian-sys-maint
password = GEHEIMES_PASSWORT
socket   = /var/run/mysqld/mysqld.sock
[mysql_upgrade]
host     = localhost
user     = debian-sys-maint
password = GEHEIMES_PASSWORT
socket   = /var/run/mysqld/mysqld.sock
{{< /highlight >}}

Wenn man das Passwort hat, dann kann man den Nutzr neu anlegen:

{{< highlight sql >}}
CREATE USER IF NOT EXISTS 'debian-sys-maint'@'localhost' IDENTIFIED BY 'GEHEIMES_PASSWORT';
GRANT ALL ON *.* TO 'debian-sys-maint'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
{{< /highlight >}}
