---
layout: post
title: verschlüsselte Volumes bequem mounten
date: 2011-03-26
categories:
- Linux
- Programmieren
tags:
- crypt
- crypttab
- Debian
- dm-crypt
- Security
status: publish
type: post
---

Ich habe mein home verschlüsselt. Dieses wird automatisch, beim anmelden gemountet.
Da ich in mein home noch ein paar andere verschlüsselte Dateisysteme einhänge funktionieren die Standard-Mittel,
wie `/etc/crypttab` nicht. Dabei ergibt sich das folgende Problem: Die Volumes werden beim booten eingehangen
und zu diesen Zeitpunkt existiert mein home noch nicht.

Da ich _faul_ bin möchte ich auch möglichst wenig Passwörter eingeben, weiterhin soll meine Freundin
auch den Rechner anmachen können und nicht an meinen Passwort scheitern. Deswegen wird nur mein
home via Passwort entschlüsselt, für die anderen Dateisysteme kommen _key-files_ zum Einsatz. Diese
liegen in meinen __verschlüsselten__ home.


Da ich mir selbst nicht vertraue, möchte ich den [sudo](http://linux.die.net/man/8/sudo)-Mechanismus
oder [suid](http://linux.die.net/man/2/setuid)-Bits nicht benutzten. Deswegen habe ich mir die beiden
Skripte `cryptdisks_start` und `cryptdisks_stop` genauer angesehen. In einen ersten Schritt habe ich mir eine
`/etc/user_crypttab` erzeugt.

~~~sh
root@walhalla ~ # cat /etc/user_crypttab
# definition             volume                        key                                   options      mountpoint                mountoptions
data--group-video_crypt  /dev/mapper/data--group-video /home/rennecke/key-files/video-key    luks         /home/rennecke/Videos     noatime
~~~

Die ersten vier Parameter entsprechen denen, der [crypttab](http://linux.die.net/man/5/crypttab),
_mountpoint_ und _mountoptions_ sind entsprechen den gleichnamigen Optionen von
[mount](http://linux.die.net/man/8/mount).

Mein `user_cryptdisks_start`-Skript sieht wie folgt aus:

~~~ sh
#!/bin/sh

# user_cryptdisks_start - wrapper around cryptsetup which parses
# /etc/user_crypttab, just like mount parses /etc/fstab.

# Initial code stolen from cryptdisks_start by Jon Dowland <jon@alcopop.org>
# Copyright (C) 2011 by Michael Rennecke <michael_rennecke@gmx.net>
# License: GNU General Public License, v2 or any later
# (http://www.gnu.org/copyleft/gpl.html)

CRYPTTAB="/etc/user_crypttab"

set -e

if [ $# -lt 1 ]; then
	echo "usage: $0 <name>" >&2
	echo >&2
	echo "reads $CRYPTTAB and starts the mapping corresponding to <name>" >&2
	exit 1
fi

. /lib/cryptsetup/cryptdisks.functions

INITSTATE="manual"
DEFAULT_LOUD="yes"

if [ -x "/usr/bin/id" ] && [ "$(/usr/bin/id -u)"  != "0" ]; then
	log_warning_msg "$0 needs root privileges"
	exit 1
fi

log_action_begin_msg "Starting crypto disk"
mount_fs


count=0
tablen="$(egrep -vc "^[[:space:]]*(#|$)" "$CRYPTTAB")"
egrep -v "^[[:space:]]*(#|$)" "$CRYPTTAB" | while read dst src key opts mnt mopts; do
	count=$(( $count + 1 ))
	echo ""
	if [ "$1" = "$dst" ]; then
		ret=0
		handle_crypttab_line_start "$dst" "$src" "$key" "$opts" <&3 || ret=$?
		echo ""
		fsck -pv /dev/mapper/$dst
		echo ""
		mount -o $mopts /dev/mapper/$dst $mnt
	elif [ $count -ge $tablen ]; then
		ret=1
		device_msg "$1" "failed, not found in user_crypttab"
	else
		continue
	fi
	umount_fs
	log_action_end_msg $ret
	exit $ret
done 3<&1
~~~

Zum Schluss noch mein  `user_cryptdisks_stop`-Skript:

~~~ sh
#!/bin/sh

# user_cryptdisks_stop - wrapper around cryptsetup which parses
# /etc/user_crypttab, just like mount parses /etc/fstab.

# Initial code stolen from cryptdisks_stop by Jonas Meurer <jonas@freesources.org>
# Copyright (C) 2011 by Michael Rennecke <michael_rennecke@gmx.net>
# License: GNU General Public License, v2 or any later
# (http://www.gnu.org/copyleft/gpl.html)

CRYPTTAB=/etc/user_crypttab

set -e

if [ $# -lt 1 ]; then
	echo "usage: $0 <name>" >&2
	echo >&2
	echo "reads $CRYPTTAB and stops the mapping corresponding to <name>" >&2
	exit 1
fi

. /lib/cryptsetup/cryptdisks.functions

INITSTATE="manual"
DEFAULT_LOUD="yes"

if [ -x "/usr/bin/id" ] && [ "$(/usr/bin/id -u)"  != "0" ]; then
	log_warning_msg "$0 needs root privileges"
	exit 1
fi

log_action_begin_msg "Stopping crypto disk"
echo ""

count=0
tablen="$(egrep -vc "^[[:space:]]*(#|$)" "$CRYPTTAB")"
egrep -v "^[[:space:]]*(#|$)" "$CRYPTTAB" | while read dst src key opts mnt mopts; do
	count=$(( $count + 1 ))
	if [ "$1" = "$dst" ]; then
		umount $mnt

		ret=0
		handle_crypttab_line_stop "$dst" "$src" "$key" "$opts" <&3 || ret=$?
	elif [ $count -ge $tablen ]; then
		ret=1
		device_msg "$1" "failed, not found in user_crypttab"
	else
		continue
	fi
	log_action_end_msg $ret
	exit $ret
done 3<&
~~~


Die beiden Skripte kann nun `root` ausführen, um Dateisysteme einzuhängen. Bei jeden einhängen
wird geschaut, ob ein [fsck] nötig ist.
Mein Dank gilt [meet-unix], er hat stand mit mit Rat zu
Seite, da ich noch etwas _Solaris_-geschädigt bin.

[fsck]: http://linux.die.net/man/8/fsck
[meet-unix]: https://blog.meet-unix.org/
