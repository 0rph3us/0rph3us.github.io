---
title: korrekte Uhrzeit
author: Michael Rennecke
type: post
date: 2010-04-13T06:10:40+00:00
categories:
  - Solaris
  - Tools
tags:
  - ntp
  - OpenSolaris
  - synchronisation

---
Für manche Dinge wie [nfs][1] ist es wichtig eine korrekte Uhrzeit auf allen Rechnern zu haben. Dies kann man durch die Sychronisation mit einem Zeit-Server erreichen. Unter Open Solaris müssen in der Datei <tt>/etc/inet/ntp.conf</tt> die Zeitserver stehen mit den man sich synchronisieren möchte. Anschließend muss man den [ntp][2]-Server neu starten. Unten steht meine Konfiguration:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">root<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ <span style="color: #c20cb9; font-weight: bold;">cat</span> <span style="color: #000000; font-weight: bold;">/</span>etc<span style="color: #000000; font-weight: bold;">/</span>inet<span style="color: #000000; font-weight: bold;">/</span>ntp.conf
server <span style="color: #000000;"></span>.pool.ntp.org
server <span style="color: #000000;">1</span>.pool.ntp.org
server <span style="color: #000000;">2</span>.pool.ntp.org
server <span style="color: #000000;">3</span>.pool.ntp.org
root<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ svcadm restart svc:<span style="color: #000000; font-weight: bold;">/</span>network<span style="color: #000000; font-weight: bold;">/</span>ntp:default
root<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ ntpq <span style="color: #660033;">-p</span>
remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
+wikisquare.de   129.69.1.153     <span style="color: #000000;">2</span> u   <span style="color: #000000;">58</span>   <span style="color: #000000;">64</span>  <span style="color: #000000;">377</span>   <span style="color: #000000;">28.259</span>  -<span style="color: #000000;">20.970</span>   <span style="color: #000000;">2.549</span>
<span style="color: #000000; font-weight: bold;">*</span>dexter.wzw.tum. 130.149.17.21    <span style="color: #000000;">2</span> u   <span style="color: #000000;">63</span>   <span style="color: #000000;">64</span>  <span style="color: #000000;">377</span>   <span style="color: #000000;">13.108</span>  -<span style="color: #000000;">17.224</span>   <span style="color: #000000;">1.370</span>
+dnscache-frankf 131.188.3.222    <span style="color: #000000;">2</span> u   <span style="color: #000000;">56</span>   <span style="color: #000000;">64</span>  <span style="color: #000000;">377</span>   <span style="color: #000000;">25.993</span>  -<span style="color: #000000;">20.031</span>   <span style="color: #000000;">2.900</span>
-draco.fivemile. 192.53.103.108   <span style="color: #000000;">2</span> u   <span style="color: #000000;">63</span>   <span style="color: #000000;">64</span>  <span style="color: #000000;">377</span>   <span style="color: #000000;">20.565</span>  -<span style="color: #000000;">15.292</span>   <span style="color: #000000;">1.181</span></pre>
      </td>
    </tr>
  </table>
</div>

[Hier][3] findet man noch einige Information über die verwendeten Zeitserver.

 [1]: http://de.wikipedia.org/wiki/Network_File_System
 [2]: http://de.wikipedia.org/wiki/Network_Time_Protocol
 [3]: http://de.wikipedia.org/wiki/NTP-Pool