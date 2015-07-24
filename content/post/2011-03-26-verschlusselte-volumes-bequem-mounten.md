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
published: true
meta:
  _jd_tweet_this: ''
  _jd_twitter: ''
  _wp_jd_clig: ''
  _wp_jd_bitly: ''
  _wp_jd_wp: ''
  _wp_jd_yourls: http://0rpheus.net/?p=5611
  _wp_jd_url: ''
  _wp_jd_target: http://0rpheus.net/?p=5611
  _jd_wp_twitter: ''
  _jd_post_meta_fixed: 'true'
  _edit_last: '2'
author:
  login: rennecke
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
---
<p>
Ich habe mein home verschlüsselt. Dieses wird automatisch, beim anmelden gemountet. Da ich in mein home noch ein paar andere verschlüsselte Dateisysteme einhänge funktionieren die Standard-Mittel, wie <tt>/etc/crypttab</tt> nicht. Dabei ergibt sich das folgende Problem: Die Volumes werden beim booten eingehangen und zu diesen Zeitpunkt existiert mein home noch nicht.</p>
<p> Da ich <em>faul</em> bin möchte ich auch möglichst wenig Passwörter eingeben, weiterhin soll meine Freundin auch den Rechner anmachen können und nicht an meinen Passwort scheitern. Deswegen wird nur mein home via Passwort entschlüsselt, für die anderen Dateisysteme kommen <em>key-files</em> zum Einsatz. Diese liegen in meinen <strong>verschlüsselten</strong> home.</p>
<p>
Da ich mir selbst nicht vertraue, möchte ich den <a href="http://linux.die.net/man/8/sudo">sudo</a>-Mechanismus oder <a href="http://linux.die.net/man/2/setuid">suid</a>-Bits nicht benutzten. Deswegen habe ich mir die beiden Skripte <tt>cryptdisks_start</tt> und <tt>cryptdisks_stop</tt> genauer angesehen. In einen ersten Schritt habe ich mir eine <tt>/etc/user_crypttab</tt> erzeugt.</p>
<pre lang="bash">
root@walhalla ~ # cat /etc/user_crypttab
# definition             volume                        key                                   options      mountpoint                mountoptions
data--group-video_crypt  /dev/mapper/data--group-video /home/rennecke/key-files/video-key    luks         /home/rennecke/Videos     noatime
</pre>
<p>
Die ersten vier Parameter entsprechen denen, der <tt><a href="http://linux.die.net/man/5/crypttab">crypttab</a></tt>, <em>mountpoint</em> und <em>mountoptions</em> sind entsprechen den gleichnamigen Optionen von <tt><a href="http://linux.die.net/man/8/mount">mount</a></tt>.</p>
<p>Mein <tt>user_cryptdisks_start</tt>-Skript sieht wie folgt aus:</p>
<pre lang="bash">
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
</name></name></pre>
<p>Zum Schluss noch mein  <tt>user_cryptdisks_stop</tt>-Skript:</p>
<pre lang="bash">
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
</name></name></pre>
<p>
Die beiden Skripte kann nun <tt>root</tt> ausführen, um Dateisysteme einzuhängen. Bei jeden einhängen wird geschaut, ob ein <tt><a href="http://linux.die.net/man/8/fsck">fsck</a></tt> nötig ist. Mein Dank gilt <a href="http://blog.meet-unix.org/">meet-unix</a>, er hat stand mit mit Rat zu Seite, da ich noch etwas <em>Solaris</em>-geschädigt bin. Anmerkungen, bitte als Kommentar hinterlassen.</p>
