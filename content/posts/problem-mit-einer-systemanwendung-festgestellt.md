---
title: "Problem mit einer Systemanwendung festgestellt"
date: 2019-12-23T15:39:52+01:00
draft: false
description:
categories:
 - Linux
tags:
 - Ubuntu
featured_image:
author: ""
---

Alle die Ubuntu und ähnliche Distributionen benutzen kennen sicherlich die schöne
Meldung nach beim grafischen Login: **Es wurde ein Problem mit einer Systemanwendung festgestellt**
Diese kann manchmal sehr hartnäckig sein und verschwindet nicht mehr. Das ganze kommt beim Einsatz von
Virtualbox *(gefühlt)* häuiger vor. Die Ursache sind Dateien/Reports
unter `/var/crash/`. Wenn man diese mittels `sudo rm /var/crash/*` löscht hat man wieder Ruhe.

Man kann die Reports auch gänzlich deinstallieren. Man muss dafür das Paket `apport` entfernen.
