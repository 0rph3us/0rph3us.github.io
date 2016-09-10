---
title: Update-Probleme bei Open Solaris
author: Michael Rennecke
type: post
date: 2010-02-04T05:32:56+00:00
categories:
  - Solaris
tags:
  - OpenSolaris
  - pkg

---
Mein neuer Blog ist noch nicht so lange online und ich arbeite noch daran. Deswegen kommt diese Meldung etwas verspätet. Ich konnte bei meinen Rechnern nicht auf Build 131 updaten. Der Fehler äußerte sich wie folgt:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"> root<span style="color: #000000; font-weight: bold;">@</span>walhalla Videos $ pkg <span style="color: #c20cb9; font-weight: bold;">install</span> <span style="color: #660033;">-q</span> SUNWipkg</pre>
      </td>
    </tr>
  </table>
</div>

pkg: Angeforderter &#8220;install&#8221;-Vorgang würde sich auf Dateien auswirken, die im Live-Abbild nicht geändert werden können.
  
Versuchen Sie diesen Vorgang in einer alternativen Startumgebung erneut.
  
Der Grund sind &#8220;falsche&#8221; Pakte im [contrib-Repository][1]. Diese Pakte haben einen nicht korrekten Verweis auf das Paket entire, welche Pakte das sind kann man wie folgt raus finden:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">root<span style="color: #000000; font-weight: bold;">@</span>walhalla Videos $ pkg contents <span style="color: #660033;">-Ho</span> pkg.name,action.raw <span style="color: #660033;">-t</span> depend <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">grep</span> <span style="color: #007800;">fmri</span>=entire<span style="color: #000000; font-weight: bold;">@</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">cut</span> <span style="color: #660033;">-f1</span>
<span style="color: #c20cb9; font-weight: bold;">wine</span></pre>
      </td>
    </tr>
  </table>
</div>

Nun habe ich das entsprechnende Paket mit

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">root<span style="color: #000000; font-weight: bold;">@</span>walhalla Videos $ pkg uninstall <span style="color: #c20cb9; font-weight: bold;">wine</span></pre>
      </td>
    </tr>
  </table>
</div>

destinstalliert. Dadnach ging das update ohne Probleme

 [1]: http://pkg.opensolaris.org/contrib