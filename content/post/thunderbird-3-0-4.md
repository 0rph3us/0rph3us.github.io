---
title: Thunderbird 3.0.4
author: Michael Rennecke
type: post
date: 2010-05-26T18:15:16+00:00
categories:
  - Solaris
tags:
  - Solaris
  - Sparc
  - thunderbird

---
F&uuml;r Solaris 10 gibt es auch den Thunderbird 3.0.4, da ich meine Einstellungen unter Open Solaris und Solaris 10 nutzen m&ouml;chte. Auf meiner Solaris 10 Installation habe ich nur einen 2.0er Thunderbird. Dieser vertr&auml;gt nicht alle Einstellungen von einem 3er Thunderbird von Open Solaris 

Bei [Sunfreeware][1] gibt ein Pakage f&uuml;r den [Thunderbird][2]. Ich hatte nach dem Starten von Thunderbird den folgenden Fehler

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>odysseus ~ $ <span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span>sfw<span style="color: #000000; font-weight: bold;">/</span>bin<span style="color: #000000; font-weight: bold;">/</span>thunderbird
ld.so.1: thunderbird-bin: fatal: relocation error: <span style="color: #c20cb9; font-weight: bold;">file</span> <span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span>sfw<span style="color: #000000; font-weight: bold;">/</span>lib<span style="color: #000000; font-weight: bold;">/</span>thunderbird<span style="color: #000000; font-weight: bold;">/</span>thunderbird-bin: symbol g_slice_set_config: referenced symbol not found
<span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span>sfw<span style="color: #000000; font-weight: bold;">/</span>lib<span style="color: #000000; font-weight: bold;">/</span>thunderbird<span style="color: #000000; font-weight: bold;">/</span>run-mozilla.sh: line <span style="color: #000000;">131</span>:   <span style="color: #000000;">551</span> Killed                  <span style="color: #ff0000;">"<span style="color: #007800;">$prog</span>"</span> <span style="color: #800000;">${1+"$@"}</span></pre>
      </td>
    </tr>
  </table>
</div>

Das ganze kann man einfach fixen indem man den <tt>LD_LIBRARY_PATH</tt> um <tt>/opt/sfw/lib/</tt> erweitert. Ich habe au&szlig;erdem die folgende Zeile in der Datei <tt>/opt/sfw/lib/thunderbird/thunderbird</tt> hinzugef&uuml;gt:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">LD_LIBRARY_PATH</span>=<span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span>sfw<span style="color: #000000; font-weight: bold;">/</span>lib<span style="color: #000000; font-weight: bold;">/</span>:<span style="color: #007800;">$LD_LIBRARY_PATH</span></pre>
      </td>
    </tr>
  </table>
</div>

So funktioniert auch der thunderbird, falls ein User seinen <tt>LD_LIBRARY_PATH</tt> selbstst&auml;ndig &auml;ndert.

 [1]: http://www.sunfreeware.com
 [2]: ftp://ftp.sunfreeware.com/pub/freeware/mozilla/thunderbird-3.0.4.en-US.opensolaris-sparc-pkg.bz2