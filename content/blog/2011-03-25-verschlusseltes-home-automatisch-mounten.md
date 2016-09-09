---
type: post
title: verschlüsseltes home automatisch mounten
date: 2011-03-25
categories:
 - Linux
tags:
 - crypt
 - Debian
 - dm-crypt
 - login
 - pam-mount
---
Ich bin inzwischen auf [Debian](http://www.debian.org/) umgestiegen. Mein home sollte natürlich verschlüsselt sein. Wenn man zum verschlüsseln
[dm-crypt](http://www.saout.de/misc/dm-crypt/)/[LUKS](http://linux.die.net/man/8/cryptsetup) nutzt und die Dateisysteme in der `/etc/crypttab` einbindet,
muss man beim booten das Passwort eingeben (Ich setzte voraus, dass man via Passwort verschlüsselt und nicht mit einem Keyfile). Es ist viel
interessanter, wenn das home beim anmelden automatisch gemountet wird. Das geht, wenn man [pam_mount](http://pam-mount.sourceforge.net/) benutzt. 
Im folgenden beschreibe ich wie man ein verschlüsseltes home anlegt, welches automatisch gemountet wird.


## Vorbereitung: Anlegen eines Volume (ich nutze lvm) ##

~~~ sh
cryptsetup luksFormat --cipher aes-cbc-essiv:sha256 /dev/data-group/home_rennecke
cryptsetup luksOpen /dev/data-group/home_rennecke data--group--home_rennecke_crypt
mkfs.ext4 /dev/mapper/data--group--home_rennecke_crypt
cryptsetup luksClose /dev/mapper/data--group--home_rennecke_crypt
~~~

Damit das home automatisch gemountet wird muss man in der `/etc/security/pam_mount.conf.xml` das folgende einfügen:

~~~ xml
<!-- Volume definitions -->
<volume user="rennecke" fstype="crypt" path="/dev/mapper/data--group-home--rennecke" mountpoint="/home/rennecke" options="fsck,noatime" />
~~~

Das Passwort vom verschlüsselten home und das Passwort vom login müssen gleich sein! Wenn man sich nun einloggt, dann wird das home automatisch eingehangen.


## Hinweis:###
Das `pam_mount`-Modul arbeitet nicht ganz transparent! mount zeigt nicht die wirklichen mount-Punkte an. Diese werden aber mit `cat /proc/mount` angezeigt.
