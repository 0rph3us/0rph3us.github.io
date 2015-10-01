+++
Categories = ["Linux", "Tools"]
Description = ""
Tags = ["dd", "Backup", "Raspberry Pi", "SD-Karte"]
date = "2015-10-01T21:27:34+02:00"
title = "Images mit Partionstabellen mounten"

+++

Ein Vorteil vom Raspberry Pi ist, dass das Betriebssystem auf einer SD-Karte
ist. Dadurch kann man relativ einfach ein Backup vom gesamten System machen.
Ich gehe davon aus, dass man noch einen weiteren Rechner mit Linux zur
Verfügung hat.

Ein Backup bietet sich auf jeden Fall an, wenn man ein größeres Update plant
oder ein etwas Experimentiert und viel Software nachinstallieren muss. Im
zweiten Fall kann man schnell sein System verfriemeln und man weiß nicht nicht
mehr was man alles verändert hat.


## Backup erstellen

Am einfachsten kann man ein Backup der kompletten SD-Karte mit `dd` machen. Dabei
muss man die Karte in einen zweiten Rechner stecken und heraus finden, wie die SD-Karte heißt.

``` sh
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 232,9G  0 disk
├─sda1        8:1    0  46,6G  0 part /
└─sda3        8:3    0 186,3G  0 part /home
mmcblk0     179:0    0  14,7G  0 disk
├─mmcblk0p1 179:1    0   256M  0 part
└─mmcblk0p2 179:2    0  14,5G  0 part
```

Man sieht, dass das Device für die SD-Karte `mmcblk0` ist.
Das andere Device ist meine Festplatte.

Mit `dd` machen wir das eigenliche Backup. Dabei wird der
gesamte Inhalt von `/dev/mmcblk0` in die Datei `$HOME/backups/pi-backup-$(date +%F).img`
geschrieben. `$(date +%F)` fügt das aktuelle Datum in
den Dateinamen ein.

``` sh
sudo dd if=/dev/mmcblk0 of=$HOME/backups/pi-backup-$(date +%F).img bs=4096
```

Nun hat man ein Backup fertig.


## Backup ansehen

Beim Raspberry Pi ist eine Partionstabelle auf der
SD-Karte. Die Daten befinden sich in der 2. Partion.
Diese muss man mounten.


``` sh
$ sudo kpartx $HOME/backups/pi-backup-2015-09-30.img
[sudo] password for rennecke:
loop0p1 : 0 114688 /dev/loop0 8192
loop0p2 : 0 62211072 /dev/loop0 122880
loop deleted : /dev/loop0
```

Nun weiß man, dass die zweite Partion bei Block 62211072
beginnt. Das mounten geht jetzt wie folgt:


```
sudo mount -o loop,rw,offset=62914560 $HOME/backups/pi-backup-2015-09-30.img /mnt
```

Ich muss meistens das Abbild beim ersten mal ReadWrite `rw` mounten, da das Dateisystem überprüft werden muss.
Sonst kann man auch ReadOnly `ro` mounten. Das hat den Vorteil, dass man nichts aus versehen im Backup verändern kann.

Nachdem man die Partion gemountet hat, kann man mit `rsync` oder einfach kopieren einzelne Dateien bzw. ganze Verzeichnisse wieder herstellen. `rsync` kann man auch in verbindung mit ssh verwenden.
