---
title: "Btrfs erweitern"
date: 2020-09-04T20:16:24+02:00
draft: false
description:
categories:
 - Linux
tags:
 - btrfs
 - backup
featured_image:
author: ""
---

## Hinweis

Das ganze ist im Grunde ein Kopie und meine Meinung aus dem [Btrfs-Wiki vom Kernel]. Das Wiki ist sehr zu empfehlen, wenn sich mit Btrfs beschäftigen möchte.

## Ausgangspunkt

Vor über einen Jahr habe ich nach einer Lösung für mein Backup- und Archivproblem gesucht. Die alte Hardware ging nicht mehr, aber die Platten waren noch gut.
Zum Schluss sind die Platten hinter einen mechanischen Ausschalter in meinen Desktop gekommen.

![mechanischer Schalter für Festplatten](/img/schalter.png)

Die Platten kann ich bequem bei Bedarf einschalten. Als Dateisystem habe ich mich für Btrfs entschieden, obwohl ich schon ein Fanboy von zfs bin. Der Vorteil
von Btrfs ist, dass man Platten für ein RAID 1 "beliebig" mischen kann. Es sollen wirklich nur Backups und Daten, welche man schon 20 Jahre nicht angefasst hat
gespeichert werden. Aus diesem Grund ist Performance zweitrangig. Am Anfang hatte ich 2 2 TB Platten im RAID 1:

{{< highlight sh >}}
mkfs.btrfs -m raid1 -d raid1 /dev/sda /dev/sdb
{{< /highlight >}}

Wobei die eine Platte eigentlich ins Museum müsste, da es meine erste 2 TB ist. Bei solchen Setups verzichte ich prinziell auf Partionstabellen. Nun kam der
Punkt an dem mir der Platz ausging und nun musste sich zeigen, ob Btrfs die richtige Wahl war.

## Platte kaufen

Ich wollte eine günstige 4 TB Platte kaufen. Dann hätte ich mit den 3 Platten und RAID 1 ca. 4 TB Gesamtkapazität. Ich habe aber keine Platte gefunden, welche
ich kaufen wollte. 6 TB Platten sahen günstiger bzw. sinnvoller aus. Ich habe zum Schluss noch mehr gespart, weil ich eine externe 6 TB Platte gekauft habe. In
diesen Gehäusen sind klassische Festplatten verbaut. Bei einen bekannten Hersteller werden auch die "normalen" Platten in den Gehäusen verbaut.

## Btrfs erweitern

Ich gehe davon aus, dass das Btrfs-Dateisystem unter `/mnt` eingehangen ist. Ich nutze gerne `lsblk`, wenn ich herausfinden möchte wie meine Platten gerade heißen.

### Hinzufügen der neuen Platte

{{< highlight sh >}}
btrfs device add /dev/sdc /mnt
{{< /highlight >}}

### Platte nutzen und Daten neu verteilen

{{< highlight sh >}}
btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt
{{< /highlight >}}

In meinen Fall hätte ein `btrfs filesystem balance /mnt` ausreichen müssen. Da ich nicht mehr wusste was ich mit den Dateisystem schon für Experimente gemacht
habe, habe ich Daten, welche nicht gespiegelt sind dadurch noch einmal gespiegelt. Dieser Schritt hat für gut 1,7 TB Daten ca. 6 Stunden gedauert.

## Fazit

Das ganze hat unproblematisch geklappt. Ich habe im Anschluss auch noch ein paar "böse" Experimente gemacht. Danach musste ich das RAID einmal neu bauen. Btrfs
hat mich an der Stelle überzeugt. Wenn man verschiedene Platten für ein Backup nutzen möchte, dann funktioniert das mit Btrfs recht gut. So kann ich weiter meine
Bilder sichern.

### Backup von meinen Bildern

Alle Bilder von meiner Kamera liegen auf einer SSD. Diese sichere mit den folgenden Skript auf meinen Btrfs-Backup. Das ganze ist definiv nicht ideal, aber
dieses Vorgehen funktioniert super. Die Bilder nehmen mehr als 1 TB Platz in Anspruch.

{{< highlight sh >}}
#!/bin/bash

set -e

# copy all files
rsync -rtv /media/SanDisk/bilder/ /media/backup/bilder

# make read only snapshot
pushd /media/backup/
sudo btrfs subvolume snapshot -r bilder snapshots_bilder/$(date +%F_%H:%S)_bilder
popd
{{< /highlight >}}

[Btrfs-Wiki vom Kernel]: https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices