---
title: OpenSolaris auf einer V880 installieren
author: Michael Rennecke
type: post
date: 2010-02-24T19:44:18+00:00
url: /solaris/opensolaris-auf-einer-v880-installieren
categories:
  - Solaris
tags:
  - Netzwerk
  - OpenSolaris
  - Sparc

---
Ich habe heute OpenSolaris auf einer [SunFire V880][1] installiert. Das ganze war nicht ganz so trivial wie ich mir das gedacht habe. Ich habe dazu den [Textinstaller][2] benutzt. Diese basiert auf Build 131. Man kann sich das Image z.B. von [genunix.org][3] herunter laden.
  
Hier war mein erster Fehler, ich hatte nich geprüft ob die Checksumme stimmt. Aber irgendwie wollte die Installation auch bei dem 3. Versuch nicht klappen. Die rettende Idee, war einmal die Checksumme vom Image zu bestimmen. Nun habe ich gesehen, dass diese nicht gestimmt hat.
  
Nachdem ich ein ganze Image auf eine DVD gebrannt ließ sich OpenSolaris auch installieren. Das Netzwerk kann man zur Zeit nur via DHCP konfigurieren, was ich nicht wollte. Nachdem die Installation fertig war, habe ich mit [Martin][4] das Netzwerk konfiguriert.   Das macht man wie folgt:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">jack<span style="color: #000000; font-weight: bold;">@</span>dijkstra ~ $  <span style="color: #c20cb9; font-weight: bold;">cat</span> <span style="color: #000000; font-weight: bold;">/</span>etc<span style="color: #000000; font-weight: bold;">/</span>nwam<span style="color: #000000; font-weight: bold;">/</span>llp
eri0 dhcp
ge0 static 192.168.1.100<span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">25</span></pre>
      </td>
    </tr>
  </table>
</div>

Die default-Route setzt man in der /etc/defaultrouter:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">jack<span style="color: #000000; font-weight: bold;">@</span>dijkstra ~ $  <span style="color: #c20cb9; font-weight: bold;">cat</span> <span style="color: #000000; font-weight: bold;">/</span>etc<span style="color: #000000; font-weight: bold;">/</span>defaultrouter
192.168.1.126</pre>
      </td>
    </tr>
  </table>
</div>

Als nächstes stand das spiegeln des rpool auf den Plan. Dazu habe ich mit format -e der 2. Platte ein SMI-Label verpasst und die ganze Platte in Slice 0 gepackt.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">jack<span style="color: #000000; font-weight: bold;">@</span>dijkstra ~ $ pfexec zpool attach <span style="color: #660033;">-f</span> rpool c1t0d0s0 c1t1d0s0</pre>
      </td>
    </tr>
  </table>
</div>

Abschließend muss man noch die Platte bootbar machen:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">jack<span style="color: #000000; font-weight: bold;">@</span>dijkstra ~ $ pfexec installboot <span style="color: #660033;">-F</span> zfs <span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>platform<span style="color: #000000; font-weight: bold;">/`</span><span style="color: #c20cb9; font-weight: bold;">uname</span> -i<span style="color: #000000; font-weight: bold;">`/</span>lib<span style="color: #000000; font-weight: bold;">/</span>fs<span style="color: #000000; font-weight: bold;">/</span>zfs<span style="color: #000000; font-weight: bold;">/</span>bootblk <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>rdsk<span style="color: #000000; font-weight: bold;">/</span>c1t1d0s0</pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://sunsolve.sun.com/handbook_pub/validateUser.do?target=Systems/SunFire880/SunFire880
 [2]: http://hub.opensolaris.org/bin/view/Project+caiman/TextInstallerProject
 [3]: http://www.genunix.org/
 [4]: https://blog.binfalse.de/