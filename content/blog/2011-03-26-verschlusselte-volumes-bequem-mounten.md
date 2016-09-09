---
title: verschlüsselte Volumes bequem mounten
author: Michael Rennecke
type: post
date: 2011-03-26T12:51:27+00:00
url: /linux/verschlusselte-volumes-bequem-mounten
categories:
  - Linux
  - Programmieren
tags:
  - crypt
  - crypttab
  - Debian
  - dm-crypt
  - Security

---
Ich habe mein home verschlüsselt. Dieses wird automatisch, beim anmelden gemountet. Da ich in mein home noch ein paar andere verschlüsselte Dateisysteme einhänge funktionieren die Standard-Mittel, wie <tt>/etc/crypttab</tt> nicht. Dabei ergibt sich das folgende Problem: Die Volumes werden beim booten eingehangen und zu diesen Zeitpunkt existiert mein home noch nicht.

Da ich _faul_ bin möchte ich auch möglichst wenig Passwörter eingeben, weiterhin soll meine Freundin auch den Rechner anmachen können und nicht an meinen Passwort scheitern. Deswegen wird nur mein home via Passwort entschlüsselt, für die anderen Dateisysteme kommen _key-files_ zum Einsatz. Diese liegen in meinen **verschlüsselten** home.

Da ich mir selbst nicht vertraue, möchte ich den [sudo][1]-Mechanismus oder [suid][2]-Bits nicht benutzten. Deswegen habe ich mir die beiden Skripte <tt>cryptdisks_start</tt> und <tt>cryptdisks_stop</tt> genauer angesehen. In einen ersten Schritt habe ich mir eine <tt>/etc/user_crypttab</tt> erzeugt. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">root<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #666666; font-style: italic;"># cat /etc/user_crypttab</span>
<span style="color: #666666; font-style: italic;"># definition             volume                        key                                   options      mountpoint                mountoptions</span>
data--group-video_crypt  <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>mapper<span style="color: #000000; font-weight: bold;">/</span>data--group-video <span style="color: #000000; font-weight: bold;">/</span>home<span style="color: #000000; font-weight: bold;">/</span>rennecke<span style="color: #000000; font-weight: bold;">/</span>key-files<span style="color: #000000; font-weight: bold;">/</span>video-key    luks         <span style="color: #000000; font-weight: bold;">/</span>home<span style="color: #000000; font-weight: bold;">/</span>rennecke<span style="color: #000000; font-weight: bold;">/</span>Videos     noatime</pre>
      </td>
    </tr>
  </table>
</div>

Die ersten vier Parameter entsprechen denen, der <tt><a href="http://linux.die.net/man/5/crypttab">crypttab</a></tt>, _mountpoint_ und _mountoptions_ sind entsprechen den gleichnamigen Optionen von <tt><a href="http://linux.die.net/man/8/mount">mount</a></tt>. 

Mein <tt>user_cryptdisks_start</tt>-Skript sieht wie folgt aus:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666; font-style: italic;">#!/bin/sh</span>
&nbsp;
<span style="color: #666666; font-style: italic;"># user_cryptdisks_start - wrapper around cryptsetup which parses</span>
<span style="color: #666666; font-style: italic;"># /etc/user_crypttab, just like mount parses /etc/fstab.</span>
&nbsp;
<span style="color: #666666; font-style: italic;"># Initial code stolen from cryptdisks_start by Jon Dowland &lt;jon@alcopop.org&gt;</span>
<span style="color: #666666; font-style: italic;"># Copyright (C) 2011 by Michael Rennecke &lt;michael_rennecke@gmx.net&gt;</span>
<span style="color: #666666; font-style: italic;"># License: GNU General Public License, v2 or any later</span>
<span style="color: #666666; font-style: italic;"># (http://www.gnu.org/copyleft/gpl.html)</span>
&nbsp;
<span style="color: #007800;">CRYPTTAB</span>=<span style="color: #ff0000;">"/etc/user_crypttab"</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">set</span> <span style="color: #660033;">-e</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #007800;">$#</span> <span style="color: #660033;">-lt</span> <span style="color: #000000;">1</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
	<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"usage: $0 &lt;name&gt;"</span> <span style="color: #000000; font-weight: bold;">&gt;&</span><span style="color: #000000;">2</span>
	<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #000000; font-weight: bold;">&gt;&</span><span style="color: #000000;">2</span>
	<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"reads <span style="color: #007800;">$CRYPTTAB</span> and starts the mapping corresponding to &lt;name&gt;"</span> <span style="color: #000000; font-weight: bold;">&gt;&</span><span style="color: #000000;">2</span>
	<span style="color: #7a0874; font-weight: bold;">exit</span> <span style="color: #000000;">1</span>
<span style="color: #000000; font-weight: bold;">fi</span>
&nbsp;
. <span style="color: #000000; font-weight: bold;">/</span>lib<span style="color: #000000; font-weight: bold;">/</span>cryptsetup<span style="color: #000000; font-weight: bold;">/</span>cryptdisks.functions
&nbsp;
<span style="color: #007800;">INITSTATE</span>=<span style="color: #ff0000;">"manual"</span>
<span style="color: #007800;">DEFAULT_LOUD</span>=<span style="color: #ff0000;">"yes"</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #660033;">-x</span> <span style="color: #ff0000;">"/usr/bin/id"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span> <span style="color: #000000; font-weight: bold;">&&</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #ff0000;">"<span style="color: #007800;">$(/usr/bin/id -u)</span>"</span>  <span style="color: #000000; font-weight: bold;">!</span>= <span style="color: #ff0000;">"0"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
	log_warning_msg <span style="color: #ff0000;">"$0 needs root privileges"</span>
	<span style="color: #7a0874; font-weight: bold;">exit</span> <span style="color: #000000;">1</span>
<span style="color: #000000; font-weight: bold;">fi</span>
&nbsp;
log_action_begin_msg <span style="color: #ff0000;">"Starting crypto disk"</span>
mount_fs
&nbsp;
&nbsp;
<span style="color: #007800;">count</span>=<span style="color: #000000;"></span>
<span style="color: #007800;">tablen</span>=<span style="color: #ff0000;">"<span style="color: #007800;">$(egrep -vc "^[[:space:]]*(#|$)</span>"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$CRYPTTAB</span>"</span><span style="color: #7a0874; font-weight: bold;">&#41;</span><span style="color: #ff0000;">"
egrep -v "</span>^<span style="color: #7a0874; font-weight: bold;">&#91;</span><span style="color: #7a0874; font-weight: bold;">&#91;</span>:space:<span style="color: #7a0874; font-weight: bold;">&#93;</span><span style="color: #7a0874; font-weight: bold;">&#93;</span><span style="color: #000000; font-weight: bold;">*</span><span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #666666; font-style: italic;">#|$)" "$CRYPTTAB" | while read dst src key opts mnt mopts; do</span>
	<span style="color: #007800;">count</span>=$<span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #7a0874; font-weight: bold;">&#40;</span> <span style="color: #007800;">$count</span> + <span style="color: #000000;">1</span> <span style="color: #7a0874; font-weight: bold;">&#41;</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>
	<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">""</span>
	<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #ff0000;">"$1"</span> = <span style="color: #ff0000;">"<span style="color: #007800;">$dst</span>"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
		<span style="color: #007800;">ret</span>=<span style="color: #000000;"></span>
		handle_crypttab_line_start <span style="color: #ff0000;">"<span style="color: #007800;">$dst</span>"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$src</span>"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$key</span>"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$opts</span>"</span> <span style="color: #000000; font-weight: bold;">&lt;&</span><span style="color: #000000;">3</span> <span style="color: #000000; font-weight: bold;">||</span> <span style="color: #007800;">ret</span>=<span style="color: #007800;">$?</span>
		<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">""</span>
		fsck <span style="color: #660033;">-pv</span> <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>mapper<span style="color: #000000; font-weight: bold;">/</span><span style="color: #007800;">$dst</span>
		<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">""</span>
		<span style="color: #c20cb9; font-weight: bold;">mount</span> <span style="color: #660033;">-o</span> <span style="color: #007800;">$mopts</span> <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>mapper<span style="color: #000000; font-weight: bold;">/</span><span style="color: #007800;">$dst</span> <span style="color: #007800;">$mnt</span>
	<span style="color: #000000; font-weight: bold;">elif</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #007800;">$count</span> <span style="color: #660033;">-ge</span> <span style="color: #007800;">$tablen</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
		<span style="color: #007800;">ret</span>=<span style="color: #000000;">1</span>
		device_msg <span style="color: #ff0000;">"$1"</span> <span style="color: #ff0000;">"failed, not found in user_crypttab"</span>
	<span style="color: #000000; font-weight: bold;">else</span>
		<span style="color: #7a0874; font-weight: bold;">continue</span>
	<span style="color: #000000; font-weight: bold;">fi</span>
	umount_fs
	log_action_end_msg <span style="color: #007800;">$ret</span>
	<span style="color: #7a0874; font-weight: bold;">exit</span> <span style="color: #007800;">$ret</span>
<span style="color: #000000; font-weight: bold;">done</span> <span style="color: #000000;">3</span><span style="color: #000000; font-weight: bold;">&lt;&</span><span style="color: #000000;">1</span></pre>
      </td>
    </tr>
  </table>
</div>

Zum Schluss noch mein <tt>user_cryptdisks_stop</tt>-Skript:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666; font-style: italic;">#!/bin/sh</span>
&nbsp;
<span style="color: #666666; font-style: italic;"># user_cryptdisks_stop - wrapper around cryptsetup which parses</span>
<span style="color: #666666; font-style: italic;"># /etc/user_crypttab, just like mount parses /etc/fstab.</span>
&nbsp;
<span style="color: #666666; font-style: italic;"># Initial code stolen from cryptdisks_stop by Jonas Meurer &lt;jonas@freesources.org&gt;</span>
<span style="color: #666666; font-style: italic;"># Copyright (C) 2011 by Michael Rennecke &lt;michael_rennecke@gmx.net&gt;</span>
<span style="color: #666666; font-style: italic;"># License: GNU General Public License, v2 or any later</span>
<span style="color: #666666; font-style: italic;"># (http://www.gnu.org/copyleft/gpl.html)</span>
&nbsp;
<span style="color: #007800;">CRYPTTAB</span>=<span style="color: #000000; font-weight: bold;">/</span>etc<span style="color: #000000; font-weight: bold;">/</span>user_crypttab
&nbsp;
<span style="color: #000000; font-weight: bold;">set</span> <span style="color: #660033;">-e</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #007800;">$#</span> <span style="color: #660033;">-lt</span> <span style="color: #000000;">1</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
	<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"usage: $0 &lt;name&gt;"</span> <span style="color: #000000; font-weight: bold;">&gt;&</span><span style="color: #000000;">2</span>
	<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #000000; font-weight: bold;">&gt;&</span><span style="color: #000000;">2</span>
	<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"reads <span style="color: #007800;">$CRYPTTAB</span> and stops the mapping corresponding to &lt;name&gt;"</span> <span style="color: #000000; font-weight: bold;">&gt;&</span><span style="color: #000000;">2</span>
	<span style="color: #7a0874; font-weight: bold;">exit</span> <span style="color: #000000;">1</span>
<span style="color: #000000; font-weight: bold;">fi</span>
&nbsp;
. <span style="color: #000000; font-weight: bold;">/</span>lib<span style="color: #000000; font-weight: bold;">/</span>cryptsetup<span style="color: #000000; font-weight: bold;">/</span>cryptdisks.functions
&nbsp;
<span style="color: #007800;">INITSTATE</span>=<span style="color: #ff0000;">"manual"</span>
<span style="color: #007800;">DEFAULT_LOUD</span>=<span style="color: #ff0000;">"yes"</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #660033;">-x</span> <span style="color: #ff0000;">"/usr/bin/id"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span> <span style="color: #000000; font-weight: bold;">&&</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #ff0000;">"<span style="color: #007800;">$(/usr/bin/id -u)</span>"</span>  <span style="color: #000000; font-weight: bold;">!</span>= <span style="color: #ff0000;">"0"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
	log_warning_msg <span style="color: #ff0000;">"$0 needs root privileges"</span>
	<span style="color: #7a0874; font-weight: bold;">exit</span> <span style="color: #000000;">1</span>
<span style="color: #000000; font-weight: bold;">fi</span>
&nbsp;
log_action_begin_msg <span style="color: #ff0000;">"Stopping crypto disk"</span>
<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">""</span>
&nbsp;
<span style="color: #007800;">count</span>=<span style="color: #000000;"></span>
<span style="color: #007800;">tablen</span>=<span style="color: #ff0000;">"<span style="color: #007800;">$(egrep -vc "^[[:space:]]*(#|$)</span>"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$CRYPTTAB</span>"</span><span style="color: #7a0874; font-weight: bold;">&#41;</span><span style="color: #ff0000;">"
egrep -v "</span>^<span style="color: #7a0874; font-weight: bold;">&#91;</span><span style="color: #7a0874; font-weight: bold;">&#91;</span>:space:<span style="color: #7a0874; font-weight: bold;">&#93;</span><span style="color: #7a0874; font-weight: bold;">&#93;</span><span style="color: #000000; font-weight: bold;">*</span><span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #666666; font-style: italic;">#|$)" "$CRYPTTAB" | while read dst src key opts mnt mopts; do</span>
	<span style="color: #007800;">count</span>=$<span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #7a0874; font-weight: bold;">&#40;</span> <span style="color: #007800;">$count</span> + <span style="color: #000000;">1</span> <span style="color: #7a0874; font-weight: bold;">&#41;</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>
	<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #ff0000;">"$1"</span> = <span style="color: #ff0000;">"<span style="color: #007800;">$dst</span>"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
		<span style="color: #c20cb9; font-weight: bold;">umount</span> <span style="color: #007800;">$mnt</span>
&nbsp;
		<span style="color: #007800;">ret</span>=<span style="color: #000000;"></span>
		handle_crypttab_line_stop <span style="color: #ff0000;">"<span style="color: #007800;">$dst</span>"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$src</span>"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$key</span>"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$opts</span>"</span> <span style="color: #000000; font-weight: bold;">&lt;&</span><span style="color: #000000;">3</span> <span style="color: #000000; font-weight: bold;">||</span> <span style="color: #007800;">ret</span>=<span style="color: #007800;">$?</span>
	<span style="color: #000000; font-weight: bold;">elif</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #007800;">$count</span> <span style="color: #660033;">-ge</span> <span style="color: #007800;">$tablen</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
		<span style="color: #007800;">ret</span>=<span style="color: #000000;">1</span>
		device_msg <span style="color: #ff0000;">"$1"</span> <span style="color: #ff0000;">"failed, not found in user_crypttab"</span>
	<span style="color: #000000; font-weight: bold;">else</span>
		<span style="color: #7a0874; font-weight: bold;">continue</span>
	<span style="color: #000000; font-weight: bold;">fi</span>
	log_action_end_msg <span style="color: #007800;">$ret</span>
	<span style="color: #7a0874; font-weight: bold;">exit</span> <span style="color: #007800;">$ret</span>
<span style="color: #000000; font-weight: bold;">done</span> <span style="color: #000000;">3</span><span style="color: #000000; font-weight: bold;">&lt;&</span></pre>
      </td>
    </tr>
  </table>
</div>

Die beiden Skripte kann nun <tt>root</tt> ausführen, um Dateisysteme einzuhängen. Bei jeden einhängen wird geschaut, ob ein <tt><a href="http://linux.die.net/man/8/fsck">fsck</a></tt> nötig ist. Mein Dank gilt [meet-unix][3], er hat stand mit mit Rat zu Seite, da ich noch etwas _Solaris_-geschädigt bin. Anmerkungen, bitte als Kommentar hinterlassen.

 [1]: http://linux.die.net/man/8/sudo
 [2]: http://linux.die.net/man/2/setuid
 [3]: http://blog.meet-unix.org/