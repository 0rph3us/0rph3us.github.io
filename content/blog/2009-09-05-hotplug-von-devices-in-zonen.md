---
title: Hotplug von Devices in Zonen
author: Michael Rennecke
type: post
date: 2009-09-04T22:20:37+00:00
url: /solaris/hotplug-von-devices-in-zonen
categories:
  - Solaris
tags:
  - hotplug
  - OpenSolaris
  - zone

---
Manchmal ist erforderlich, dass man einer Zone den Zugriff auf ein Device gewährt. Ich habe z.B. einer Zone mein externes LTO-2 Bandlaufwerk gegeben. Dieses ist über [SCSI][1] mit dem Rechner verbunden. Da ich Strom sparen möchte und [SCSI][1] [hotplugfähig][2] ist, schalte ich das Bandlaufwerk nur ein wenn ich es benötige.

Damit man das Device unter Solaris in der global-Zone ansprechen kann, muss es wie folgt einbinden (mein Laufwerk ist an Controller c17 angeschlossen):

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">root<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ cfgadm <span style="color: #660033;">-c</span> configure c17
root<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ cfgadm <span style="color: #660033;">-a</span> c17<span style="color: #000000; font-weight: bold;">&lt;/</span>tt<span style="color: #000000; font-weight: bold;">&gt;</span>
p_Id                          Type         Receptacle   Occupant     Condition
c17                            scsi-bus     connected    configured   unknown
c17::rmt<span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;"></span>                     tape         connected    configured   unknown</pre>
      </td>
    </tr>
  </table>
</div>

Wenn man in einer nonglobal-Zone ist geht dieses Verfahren nicht. Solaris sagt aber einen woran es liegt:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">cfgadm: Configuration administration not supported: cfgadm can only be run from the global zone</pre>
      </td>
    </tr>
  </table>
</div>

Also muss man Devices, die eine nonglobal-Zone benötigt **immer** in der global-Zone einbinden bzw. tauschen. Ich vertrete die Auffassung, das man in einer nonglobal-Zone, so weit es möglich ist, keine Devices gibt. Das kann unter Umständen zu Probleme bei der Migration der Zonen führen.

 [1]: http://de.wikipedia.org/wiki/Small_Computer_System_Interface
 [2]: http://de.wikipedia.org/wiki/Hot_Swapping