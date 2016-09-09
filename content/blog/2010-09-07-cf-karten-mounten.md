---
title: CF-Karten mounten
author: Michael Rennecke
type: post
date: 2010-09-07T18:34:51+00:00
excerpt: |
  <p>
  Wie ihr gelesen habt, bin ich unter die Digitalfotografen gegangen. Nun weiß ich endlich wozu der CF-Slot in meinen Notebook gut ist. Da muss man <a href="http://de.wikipedia.org/wiki/CompactFlash">Compact Flash</a>-Karten hineinstecken und solche stecken in meiner Kamera. Das dumme ist nur, dass mein Debian die CF-Karten nicht automatisch mountet. Zuerst habe ich nachgesehen, welches Device die CF-Karten haben. Anschließend erstellt man ein Verzeichnis in das die CF-Karten gemountet werden sollen.</p>
url: /linux/cf-karten-mounten
categories:
  - Linux
tags:
  - blkid
  - Compact Flash
  - Debian
  - fstab
  - mount

---
Wie ihr gelesen habt, bin ich unter die Digitalfotografen gegangen. Nun weiß ich endlich wozu der CF-Slot in meinen Notebook gut ist. Da muss man [Compact Flash][1]-Karten hineinstecken und solche stecken in meiner Kamera. Das dumme ist nur, dass mein Debian die CF-Karten nicht automatisch mountet. Zuerst habe ich nachgesehen, welches Device die CF-Karten haben. Anschließend erstellt man ein Verzeichnis in das die CF-Karten gemountet werden sollen.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ <span style="color: #000000; font-weight: bold;">%</span> blkid
<span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>sda1: <span style="color: #007800;">UUID</span>=<span style="color: #ff0000;">"5C8CF5697CA93BD8"</span> <span style="color: #007800;">TYPE</span>=<span style="color: #ff0000;">"ntfs"</span>
<span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>sda5: <span style="color: #007800;">UUID</span>=<span style="color: #ff0000;">"f1b2836f-81bf-4f75-9ae0-f2c284871891"</span> <span style="color: #007800;">TYPE</span>=<span style="color: #ff0000;">"swap"</span>
<span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>sda6: <span style="color: #007800;">LABEL</span>=<span style="color: #ff0000;">"debian-root"</span> <span style="color: #007800;">UUID</span>=<span style="color: #ff0000;">"c00a4da53-1763-42e1-878d-3e096cad760b"</span> <span style="color: #007800;">TYPE</span>=<span style="color: #ff0000;">"ext4"</span>
<span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>sda7: <span style="color: #007800;">UUID</span>=<span style="color: #ff0000;">"60eca5b7-09ef-4b82-bf59-1a8360c8c6c1"</span> <span style="color: #007800;">TYPE</span>=<span style="color: #ff0000;">"crypto_LUKS"</span>
<span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>mapper<span style="color: #000000; font-weight: bold;">/</span>home: <span style="color: #007800;">UUID</span>=<span style="color: #ff0000;">"6cbebba6-e725-4549-bafe-8809ff73f27f"</span> <span style="color: #007800;">TYPE</span>=<span style="color: #ff0000;">"ext4"</span>
<span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>hda1: <span style="color: #007800;">SEC_TYPE</span>=<span style="color: #ff0000;">"msdos"</span> <span style="color: #007800;">LABEL</span>=<span style="color: #ff0000;">"EOS_DIGITAL"</span> <span style="color: #007800;">TYPE</span>=<span style="color: #ff0000;">"vfat"</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ <span style="color: #000000; font-weight: bold;">%</span> <span style="color: #c20cb9; font-weight: bold;">su</span>
Passwort:
root<span style="color: #000000; font-weight: bold;">@</span>trantor <span style="color: #000000; font-weight: bold;">/</span>home<span style="color: #000000; font-weight: bold;">/</span>rennecke $ <span style="color: #c20cb9; font-weight: bold;">mkdir</span> <span style="color: #000000; font-weight: bold;">/</span>media<span style="color: #000000; font-weight: bold;">/</span>flash</pre>
      </td>
    </tr>
  </table>
</div>

Nun weiß ich, dass meine CF-Karten das Device <tt>/dev/hda1</tt> haben. Nun füge ich die folgende Zeile der <tt>/etc/fstab</tt> hinzu:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="config" style="font-family:monospace;">/dev/hda1       /media/flash    auto        rw,user,noauto,exec     0       0</pre>
      </td>
    </tr>
  </table>
</div>

Nun kann man als normaler User mittels 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ <span style="color: #000000; font-weight: bold;">%</span> <span style="color: #c20cb9; font-weight: bold;">mount</span> <span style="color: #000000; font-weight: bold;">/</span>media<span style="color: #000000; font-weight: bold;">/</span>flash
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ <span style="color: #000000; font-weight: bold;">%</span> <span style="color: #c20cb9; font-weight: bold;">umount</span> <span style="color: #000000; font-weight: bold;">/</span>media<span style="color: #000000; font-weight: bold;">/</span>flash</pre>
      </td>
    </tr>
  </table>
</div>

die CF-Karte mounten und abmounten. Alternativ kann man das ganz nun auch grafisch mounten. Wo man klicken muss hängt vom Window-Manager ab.

 [1]: http://de.wikipedia.org/wiki/CompactFlash