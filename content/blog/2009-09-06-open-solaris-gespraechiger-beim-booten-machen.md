---
title: Open Solaris gesprächiger beim booten machen
author: Michael Rennecke
type: post
date: 2009-09-05T22:16:15+00:00
url: /solaris/open-solaris-gespraechiger-beim-booten-machen
categories:
  - Solaris
tags:
  - grub
  - OpenSolaris
  - verbose

---
?Manchmal möchte man wissen, was Open Solaris beim booten eigenlich macht, vielleicht weil es Probleme gibt oder man einfach nur neugierig ist. Bei x86 kann man das ganze als Kerneloption mit geben. Es gib:

  1. <tt>-v</tt> zeigt die Devices an
  2. <tt>-m verbose</tt> zeigt an welche Dienste starten ([siehe smf][1])

Man kann die Kerneloptionen direkt beim booten mitgeben. Dazu muss man bei [grub][2] **e** drücken um den aktuellen Eintrag zu editieren. Alternativ kann man auch die <tt>/rpool/boot/grub/menu</tt> .lst anpassen:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="grub" style="font-family:monospace;">title Open Solaris snv-122
findroot (pool_rpool,0,a)
bootfs rpool/ROOT/snv-122
kernel$ /platform/i86pc/kernel/$ISADIR/unix -B $ZFS-BOOTFS -v
module$ /platform/i86pc/$ISADIR/boot_archive</pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://www.sun.com/bigadmin/content/selfheal/smf-quickstart.jsp
 [2]: http://www.gnu.org/software/grub/