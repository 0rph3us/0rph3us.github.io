---
title: Zonen retten
author: Michael Rennecke
type: post
date: 2010-02-19T11:21:26+00:00
url: /solaris/zonen-retten
categories:
  - Solaris
tags:
  - OpenSolaris
  - zone

---
Ich habe mir vor einigen Wochen meine Systemplatten zerstört. Das hat mich noch nicht sonderlich gestört. Denn man kann OpenSolaris sehr schnell wieder installieren. Von den ganzen Konfigurationen hatte ich ein Backup. Ein kleineres Problem hatte ich mit den Zonen. Sie ließen sich nicht ohne weiteres im neuen System importieren. Ein möglicher Grund ist, dass ich sie nicht detachet hatte und die Zoneroots hatte ich auch nicht mehr.
   
Der Fehler hat sich wie folgt geäußert:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ pfexec zoneadm <span style="color: #660033;">-z</span> <span style="color: #7a0874; font-weight: bold;">test</span> attach <span style="color: #660033;">-u</span>
Log File: <span style="color: #000000; font-weight: bold;">/</span>var<span style="color: #000000; font-weight: bold;">/</span>tmp<span style="color: #000000; font-weight: bold;">/</span>test.attach_log.KvayPK
ERROR: no active dataset.
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ pfexec zoneadm <span style="color: #660033;">-z</span> <span style="color: #7a0874; font-weight: bold;">test</span> attach
Log File: <span style="color: #000000; font-weight: bold;">/</span>var<span style="color: #000000; font-weight: bold;">/</span>tmp<span style="color: #000000; font-weight: bold;">/</span>test.attach_log.X4aOcK
ERROR: no active dataset.
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ pfexec <span style="color: #c20cb9; font-weight: bold;">cat</span> <span style="color: #000000; font-weight: bold;">/</span>var<span style="color: #000000; font-weight: bold;">/</span>tmp<span style="color: #000000; font-weight: bold;">/</span>test.attach_log.X4aOcK
<span style="color: #7a0874; font-weight: bold;">&#91;</span>Montag, <span style="color: #000000;">15</span>. Februar <span style="color: #000000;">2010</span>, <span style="color: #000000;">12</span>:<span style="color: #000000;">45</span>:<span style="color: #000000;">18</span> Uhr CET<span style="color: #7a0874; font-weight: bold;">&#93;</span> Log File: <span style="color: #000000; font-weight: bold;">/</span>var<span style="color: #000000; font-weight: bold;">/</span>tmp<span style="color: #000000; font-weight: bold;">/</span>test.attach_log.X4aOcK
<span style="color: #7a0874; font-weight: bold;">&#91;</span>Montag, <span style="color: #000000;">15</span>. Februar <span style="color: #000000;">2010</span>, <span style="color: #000000;">12</span>:<span style="color: #000000;">45</span>:<span style="color: #000000;">18</span> Uhr CET<span style="color: #7a0874; font-weight: bold;">&#93;</span> ERROR: no active dataset.</pre>
      </td>
    </tr>
  </table>
</div>

Also habe ich etwas gebastelt und habe die Zonen wieder importiert.

  1. Das Backup von <tt>/etc/zones</tt> eingespielt
  2. Den zpool mit den zonen importiert, mit der Option **-f**
  3. ID des Parent Bootenvironment auslesen: <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ zfs get <span style="color: #660033;">-r</span> org.opensolaris.libbe:uuid rpool<span style="color: #000000; font-weight: bold;">/</span>ROOT
...                                  -
rpool<span style="color: #000000; font-weight: bold;">/</span>ROOT<span style="color: #000000; font-weight: bold;">/</span>opensolaris          org.opensolaris.libbe:uuid  642ced7d-55a2-cc3b-fbdf-fbdda1c33ebc  <span style="color: #7a0874; font-weight: bold;">local</span>
...</pre>
          </td>
        </tr>
      </table>
    </div>

  4. Das höchste Bootenvironment der Zone bestimmen. Das ist die höchste Nummer: <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ zfs get <span style="color: #660033;">-r</span> org.opensolaris.libbe:parentbe
...
daten<span style="color: #000000; font-weight: bold;">/</span>zone<span style="color: #000000; font-weight: bold;">/</span>test<span style="color: #000000; font-weight: bold;">/</span>ROOT<span style="color: #000000; font-weight: bold;">/</span>zbe-<span style="color: #000000;">10</span>                      org.opensolaris.libbe:parentbe  5741bca6-d793-454e-ad53-84c2cf7c630b  <span style="color: #7a0874; font-weight: bold;">local</span>
...</pre>
          </td>
        </tr>
      </table>
    </div>

  5. ID des Parent Bootenvironment setzten: <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ pfexec zfs <span style="color: #000000; font-weight: bold;">set</span> org.opensolaris.libbe:<span style="color: #007800;">parentbe</span>=642ced7d-55a2-cc3b-fbdf-fbdda1c33ebc daten<span style="color: #000000; font-weight: bold;">/</span>zone<span style="color: #000000; font-weight: bold;">/</span>test<span style="color: #000000; font-weight: bold;">/</span>ROOT<span style="color: #000000; font-weight: bold;">/</span>zbe-<span style="color: #000000;">10</span></pre>
          </td>
        </tr>
      </table>
    </div>

  6. Status der Zone in der Datei <tt>/etc/zones/index</tt> auf **configured** setzten
  7. Zone neu installieren: <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ pfexec zoneadm <span style="color: #660033;">-z</span> <span style="color: #7a0874; font-weight: bold;">test</span> <span style="color: #c20cb9; font-weight: bold;">install</span></pre>
          </td>
        </tr>
      </table>
    </div>

  8. Testen, ob die Zone sich **nicht** booten lässt: <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ pfexec zoneadm <span style="color: #660033;">-z</span> <span style="color: #7a0874; font-weight: bold;">test</span> boot</pre>
          </td>
        </tr>
      </table>
    </div>
    
    Es sollte ein Fehler kommen, dass es mehrere aktive Datasets gibt.

  9. Das neu angelegte Bootenvironment der Zone löschen: <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ $ pfexec zfs destroy daten<span style="color: #000000; font-weight: bold;">/</span>zone<span style="color: #000000; font-weight: bold;">/</span>test<span style="color: #000000; font-weight: bold;">/</span>ROOT<span style="color: #000000; font-weight: bold;">/</span>zbe-<span style="color: #000000;">11</span></pre>
          </td>
        </tr>
      </table>
    </div>

 10. Fertig, nun kann man die Zone wieder normal booten

Diese Unschönheit kommt bei Solaris 10 nicht vor. Es kann sein, dass sie auch nur bei den, von mir verwendten Build 131 vorkommt. Man sollte bei dieser Bastelei wissen was man tut, also bitte nicht wild darauf los tippen, wenn ihr den selben Fehler habt.