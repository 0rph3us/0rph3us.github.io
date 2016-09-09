---
title: Eigenschaften von Zonen
author: Michael Rennecke
type: post
date: 2010-04-22T19:57:28+00:00
url: /solaris/eigenschaften-von-zonen
categories:
  - Solaris
tags:
  - OpenSolaris
  - quotas
  - Virtualisierung
  - zfs
  - zone

---
Ich wurde in Bezug auf diesen [Blog-Eintrag][1] gefragt, was es f&uuml;r Zoneneigenschaften gibt, welche man f&uuml;r Regelmentierungen verwenden kann. 

Als ersten m&ouml;chte ich zeigen, wie man den Hauptspeicher limitieren kann. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666;">root@global$ </span>zonecfg <span style="color: #660033;">-z</span> myzone
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> add capped-memory
zonecfg:myzone:capped-memory<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">physical</span>=500m
zonecfg:myzone:capped-memory<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">swap</span>=1g
zonecfg:myzone:capped-memory<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">locked</span>=100m
zonecfg:myzone:capped-memory<span style="color: #000000; font-weight: bold;">&gt;</span> end
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #7a0874; font-weight: bold;">exit</span></pre>
      </td>
    </tr>
  </table>
</div>

physical
:   Hierbei handelt es sich um eine Limitierung des physischen Hauptspeicher. Wenn mehr Speicher angefordert wird, dann kann dieser ausgelagert werden.
       
    Eine Zone kann diesen Wert &uuml;berschreiten und mehr Speicher anfordern. 

swap
:   Das ist eine Begrenzung des virtuellen Speicher, d.h. eine Zone kann nicht mehr Speicher anfordern. Wenn ein Prozess in der Zone mehr Speicher anfordert, so schl&auml;gt diese Speicheranforderung fehl. 

locked
:   Der allokierte Speicher ein Zone kann bis auf diesen Wert ausgelagert werden 

Neben dem Hauptspeicher kann man auch die CPUs regelmentieren. Man dedizierter CPUs zuweisen oder das Scheduling ver&auml;ndern. [Hier][2] gibt eine gute &Uuml;bersicht, bzgl. der Definition der CPU Shares. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666;">root@global$ </span>zonecfg <span style="color: #660033;">-z</span> myzone
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> add dedicated-cpu
zonecfg:myzone:dedicated-cpu<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">ncpus</span>=<span style="color: #000000;">1</span>-<span style="color: #000000;">4</span>
zonecfg:myzone:dedicated-cpu<span style="color: #000000; font-weight: bold;">&gt;</span> end
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #7a0874; font-weight: bold;">exit</span></pre>
      </td>
    </tr>
  </table>
</div>

Was passiert nun?

  1. Beim booten der Zone werden die CPUs 1-4 werden aus dem default-Pool entfernt
  2. Es wird ein tempor&auml;er Pool erstellt mit den CPUs 1-4
  3. Beim stoppen der Zone werden die CPUs 1-4 wieder dem default-Pool zur verf&uuml;gung gestellt.

Man kann auch sagen, dass eine Zone z.B. maximal 2,5 CPUs benutzen kann. Das sieht wie folgt aus:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666;">root@global$ </span>zonecfg <span style="color: #660033;">-z</span> myzone
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> add capped-cpu
zonecfg:myzone:capped-cpu<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">ncpus</span>=<span style="color: #000000;">2.5</span>
zonecfg:myzone:capped-cpu<span style="color: #000000; font-weight: bold;">&gt;</span> end
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #7a0874; font-weight: bold;">exit</span></pre>
      </td>
    </tr>
  </table>
</div>

Nun m&ouml;chte ich zeigen, wie man eine Zone 200 CPU-Shares und die FSS (Fair Share Scheduling) Klasse zuweist

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666;">root@global$ </span>zonecfg <span style="color: #660033;">-z</span> myzone
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> cpu-shares=<span style="color: #000000;">200</span>
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> scheduling-class=FSS
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #7a0874; font-weight: bold;">exit</span></pre>
      </td>
    </tr>
  </table>
</div>

Als letztes Quota zum Thema CPU m&ouml;chte ich zeigen, wie man die Anzahl der Threads/Prozesse begrenzt. Die folgende Zone kann maximal 250 Threads ausf&uuml;hren. Ein einzelner Prozess ohne Thredas z&auml;hlt als ein Thread.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666;">root@global$ </span>zonecfg <span style="color: #660033;">-z</span> myzone
zonecfg:myzone<span style="color: #000000; font-weight: bold;">&gt;</span> add rctl
zonecfg:myzone:rctl<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">name</span>=zone.max-lwps
zonecfg:myzone:rctl<span style="color: #000000; font-weight: bold;">&gt;</span> add value <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #007800;">priv</span>=privileged,<span style="color: #007800;">limit</span>=<span style="color: #000000;">250</span>,<span style="color: #007800;">action</span>=deny<span style="color: #7a0874; font-weight: bold;">&#41;</span>
zonecfg:myzone:rctl<span style="color: #000000; font-weight: bold;">&gt;</span> end</pre>
      </td>
    </tr>
  </table>
</div>

Man kann auf diese Weise auch noch andere Resourcen kontrollieren. [Hier][3] findet man eine &Uuml;bersicher &uuml;ber die Resource Controls

F&uuml;r Zonen kann es auch interssant sein, den Plattenpatz zu begrenzen. Da in Open Solaris zfs das default-Dateisystem ist, kann man Quotas und Reservations &uuml;ber die entsprechenden zfs-Eigenschaften machen. Die Wurzel der Zone liegt auf dem Dateisystem <tt>zones/myzone</tt>

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666;">root@global$ </span>zonecfg <span style="color: #660033;">-z</span> myzone zfs <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">quota</span>=10g zones<span style="color: #000000; font-weight: bold;">/</span>myzone
<span style="color: #666666;">root@global$ </span>zonecfg <span style="color: #660033;">-z</span> myzone zfs <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">reservation</span>=5g zones<span style="color: #000000; font-weight: bold;">/</span>myzone</pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://0rpheus.net/solaris/eine-zone-in-10-minuten
 [2]: http://docs.sun.com/app/docs/doc/817-1592/rmfss-4?l=en&a=view
 [3]: http://docs.sun.com/app/docs/doc/820-2316/rmctrls-1?l=de&a=view