---
title: Java-Applet – eine sinnfreie Erfindung
author: Michael Rennecke
type: post
date: 2010-05-28T09:09:31+00:00
excerpt: |
  <p>
  Ich kam leider nicht herum einmal ein Java-Applet auszuführen. Mein <a href="http://www.mozilla-europe.org/de/firefox/">Firefox</a> hat sich geweigert und meinte, dass es kein entsprechendes Plugin gibt. Das ganze ist mir auf meinen aktuellen <a href="http://www.opensolaris.com/">Open Solaris</a> (64-Bit Intel) und meinem <a href="http://www.sun.com/software/solaris/10/">Solaris 10</a> auf <a href="http://en.wikipedia.org/wiki/SPARC">Ultrasparc</a> (64-Bit) passiert. Auf beiden Systemen ist das aktuelle <a href="http://java.sun.com/javase/">JDK</a> installiert. Auf meinen <a href="http://www.opensolaris.com/">Open Solaris</a>-System habe ich außerdem das Package <tt>web/browser/firefox/plugin/firefox-java</tt> installiert
  </p>
  
  <p>
  Die Lösung für das Problem findet man im Kleingedruckten auf der <a href="http://www.java.com/de/download/manual.jsp">Download-Seite</a> der JRE:
  <blockquote>
  Bitte verwenden Sie die 32-Bit-Version für Java-Applet- und Java Web Start-Support.
  </blockquote>
  Nachdem ich <strong>explizit</strong> die 32-Bit JRE installiert habe und einen symbolischen Link in das Plugin-Verzeichnis des Firefox gemacht habe gingen auch Java-Applets.
  <pre lang="bash">
  root@walhalla ~ % cd <Firefox-Installation>/plugins
  root@walhalla /usr/lib/firefox/plugins % ln -s <JRE>/plugin/<i386|sparc>/ns7/libjavaplugin_oji.so .
  </pre>
  Nun muss man den Firefox nur noch neu starten.
  </p>
  <p>
  Noch ein Wort zum Schluss: Wann hört dieser Java-Wahnsinn aus? Wenn es Sun/Oracle nicht hinbekommt eine 64-Bit JRE zu bauen, welche auch Applets ausführt? Man kann es auch <a href="http://en.wikipedia.org/wiki/Quick-and-dirty">quick&dirty</a> lösen: Einfach den 32-Bit Müll mit in das 64-Bit Paket packen, so wie ich es händisch mache.
  </p>
url: /solaris/java-applet-eine-sinnfreie-erfindung
categories:
  - Solaris
tags:
  - hack
  - Java
  - OpenSolaris
  - Solaris
  - Sparc

---
Ich kam leider nicht herum einmal ein Java-Applet auszuführen. Mein [Firefox][1] hat sich geweigert und meinte, dass es kein entsprechendes Plugin gibt. Das ganze ist mir auf meinen aktuellen [Open Solaris][2] (64-Bit Intel) und meinem [Solaris 10][3] auf [Ultrasparc][4] (64-Bit) passiert. Auf beiden Systemen ist das aktuelle [JDK][5] installiert. Auf meinen [Open Solaris][2]-System habe ich außerdem das Package <tt>web/browser/firefox/plugin/firefox-java</tt> installiert

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla <span style="color: #000000; font-weight: bold;">/</span>tmp <span style="color: #000000; font-weight: bold;">%</span> pkg info web<span style="color: #000000; font-weight: bold;">/</span>browser<span style="color: #000000; font-weight: bold;">/</span>firefox<span style="color: #000000; font-weight: bold;">/</span>plugin<span style="color: #000000; font-weight: bold;">/</span>firefox-java
          Name: web<span style="color: #000000; font-weight: bold;">/</span>browser<span style="color: #000000; font-weight: bold;">/</span>firefox<span style="color: #000000; font-weight: bold;">/</span>plugin<span style="color: #000000; font-weight: bold;">/</span>firefox-java
Zusammenfassung: Java runtime integration - plugin
  Beschreibung: Java runtime integration - plugin
     Kategorie: Applications<span style="color: #000000; font-weight: bold;">/</span>Plug-ins and Run-times
        Status: Installiert
   Herausgeber: opensolaris.org
       Version: 0.5.11
 Build-Release: <span style="color: #000000;">5.11</span>
         Zweig: <span style="color: #000000;">0.134</span>
Packaging-Datum:  <span style="color: #000000;">2</span>. März <span style="color: #000000;">2010</span>, 07:<span style="color: #000000;">19</span>:<span style="color: #000000;">23</span> Uhr
         Größe: <span style="color: #000000;">93.00</span> B
          FMRI: pkg:<span style="color: #000000; font-weight: bold;">//</span>opensolaris.org<span style="color: #000000; font-weight: bold;">/</span>web<span style="color: #000000; font-weight: bold;">/</span>browser<span style="color: #000000; font-weight: bold;">/</span>firefox<span style="color: #000000; font-weight: bold;">/</span>plugin<span style="color: #000000; font-weight: bold;">/</span>firefox-java<span style="color: #000000; font-weight: bold;">@</span>0.5.11,<span style="color: #000000;">5.11</span>-<span style="color: #000000;">0.134</span>:20100302T071923Z</pre>
      </td>
    </tr>
  </table>
</div>

Die Lösung für das Problem findet man im Kleingedruckten auf der [Download-Seite][6] der JRE: 

> Bitte verwenden Sie die 32-Bit-Version für Java-Applet- und Java Web Start-Support. 

Nachdem ich **explizit** die 32-Bit JRE installiert habe und einen symbolischen Link in das Plugin-Verzeichnis des Firefox gemacht habe gingen auch Java-Applets.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">root<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> <span style="color: #7a0874; font-weight: bold;">cd</span> <span style="color: #000000; font-weight: bold;">&lt;</span>Firefox-Installation<span style="color: #000000; font-weight: bold;">&gt;/</span>plugins
root<span style="color: #000000; font-weight: bold;">@</span>walhalla <span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>lib<span style="color: #000000; font-weight: bold;">/</span>firefox<span style="color: #000000; font-weight: bold;">/</span>plugins <span style="color: #000000; font-weight: bold;">%</span> <span style="color: #c20cb9; font-weight: bold;">ln</span> <span style="color: #660033;">-s</span> <span style="color: #000000; font-weight: bold;">&lt;</span>JRE<span style="color: #000000; font-weight: bold;">&gt;/</span>plugin<span style="color: #000000; font-weight: bold;">/&lt;</span>i386<span style="color: #000000; font-weight: bold;">|</span>sparc<span style="color: #000000; font-weight: bold;">&gt;/</span>ns7<span style="color: #000000; font-weight: bold;">/</span>libjavaplugin_oji.so .</pre>
      </td>
    </tr>
  </table>
</div>

Nun muss man den Firefox nur noch neu starten. 

Noch ein Wort zum Schluss: Wann hört dieser Java-Wahnsinn aus? Wenn es Sun/Oracle nicht hinbekommt eine 64-Bit JRE zu bauen, welche auch Applets ausführt? Man kann es auch [quick&dirty][7] lösen: Einfach den 32-Bit Müll mit in das 64-Bit Paket packen, so wie ich es händisch mache.

 [1]: http://www.mozilla-europe.org/de/firefox/
 [2]: http://www.opensolaris.com/
 [3]: http://www.sun.com/software/solaris/10/
 [4]: http://en.wikipedia.org/wiki/SPARC
 [5]: http://java.sun.com/javase/
 [6]: http://www.java.com/de/download/manual.jsp
 [7]: http://en.wikipedia.org/wiki/Quick-and-dirty