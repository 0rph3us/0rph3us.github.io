---
title: verschlüsseltes home automatisch mounten
author: Michael Rennecke
type: post
date: 2011-03-25T20:14:07+00:00
categories:
  - Linux
tags:
  - crypt
  - Debian
  - dm-crypt
  - login
  - pam-mount

---
Ich bin inzwischen auf [Debian][1] umgestiegen. Mein home sollte natürlich verschlüsselt sein. Wenn man zum verschlüssel [dm-crypt][2]/[LUKS][3] nutzt und die Dateisysteme in der <tt>/etc/crypttab</tt> einbindet, muss man beim booten das Passwort eingeben (Ich setzte voraus, dass man via Passwort verschlüsselt und nicht mit einem Keyfile). Es ist viel interessanter, wenn das home beim anmelden automatisch gemountet wird. Das geht, wenn man [pam_mount][4] benutzt. Im folgenden beschreibe ich wie man ein verschlüsseltes home anlegt, welches automatisch gemountet wird. 

Vorbereitung: Anlegen eines Volume (ich nutze lvm)

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">cryptsetup luksFormat <span style="color: #660033;">--cipher</span> aes-cbc-essiv:sha256 <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>data-group<span style="color: #000000; font-weight: bold;">/</span>home_rennecke
cryptsetup luksOpen <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>data-group<span style="color: #000000; font-weight: bold;">/</span>home_rennecke data--group--home_rennecke_crypt
mkfs.ext4 <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>mapper<span style="color: #000000; font-weight: bold;">/</span>data--group--home_rennecke_crypt
cryptsetup luksClose <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>mapper<span style="color: #000000; font-weight: bold;">/</span>data--group--home_rennecke_crypt</pre>
      </td>
    </tr>
  </table>
</div>

Damit das home automatisch gemountet wird muss man in der <tt>/etc/security/pam_mount.conf.xml</tt> das folgende einfügen:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="xml" style="font-family:monospace;"><span style="color: #808080; font-style: italic;">&lt;!-- Volume definitions --&gt;</span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;volume</span> <span style="color: #000066;">user</span>=<span style="color: #ff0000;">"rennecke"</span> <span style="color: #000066;">fstype</span>=<span style="color: #ff0000;">"crypt"</span> <span style="color: #000066;">path</span>=<span style="color: #ff0000;">"/dev/mapper/data--group-home--rennecke"</span> <span style="color: #000066;">mountpoint</span>=<span style="color: #ff0000;">"/home/rennecke"</span> <span style="color: #000066;">options</span>=<span style="color: #ff0000;">"fsck,noatime"</span> <span style="color: #000000; font-weight: bold;">/&gt;</span></span></pre>
      </td>
    </tr>
  </table>
</div>

Das Passwort vom verschlüsselten home und das Passwort vom login müssen gleich sein! Wenn man sich nun einloggt, dann wird das home automatisch eingehangen. 

**Hinweis:**
  
Das <tt>pam_mount</tt>-Modul arbeitet nicht ganz transparent! mount zeigt nicht die wirklichen mount-Punkte an. Diese werden aber mit <tt>cat /proc/mount</tt> angezeigt.

 [1]: http://www.debian.org/
 [2]: http://www.saout.de/misc/dm-crypt/
 [3]: http://linux.die.net/man/8/cryptsetup
 [4]: http://pam-mount.sourceforge.net/