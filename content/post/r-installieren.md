---
title: R, die Statistiksoftware installieren
author: Michael Rennecke
type: post
date: 2010-06-03T07:58:42+00:00
categories:
  - Solaris
tags:
  - blastwave
  - build
  - gcc
  - OpenSolaris
  - R
  - Solaris
  - Sparc
  - sunfreeware

---
Ich wollte vor ein paar Tagen die aktuelle Version 2.11.1 von [R][1] installieren. Es gibt leider kein aktuelles R-Pakage für Solaris. Auf [sunfreeware][2] gibt es ein [R-Package][3] in der Version 2.7.2. Also blieb mir nichts anderes übrig, als [R][1] selbst zu übersetzten. Leider ging das nicht auf Anhieb. Ich habe folgende Fehlermeldung bekommen:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">checking <span style="color: #000000; font-weight: bold;">for</span> iconv.h... <span style="color: #c20cb9; font-weight: bold;">yes</span>
checking <span style="color: #000000; font-weight: bold;">for</span> iconv... <span style="color: #c20cb9; font-weight: bold;">yes</span>
checking whether iconv accepts <span style="color: #ff0000;">"UTF-8"</span>, <span style="color: #ff0000;">"latin1"</span>, <span style="color: #ff0000;">"ASCII"</span> and <span style="color: #ff0000;">"UCS-*"</span>... no
configure: error: a suitable iconv is essential</pre>
      </td>
    </tr>
  </table>
</div>

Ich habe von [blastwave][4] **libiconv** installiert und bei meiner Solaris 10 Box noch denn gcc 4. Bei OpenSolaris habe ich das Pakage **pkg:/developer/gcc/gcc-43** installiert. Es gibt CGLAGS für [Sparc][5] und für [x86][6]

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla <span style="color: #000000; font-weight: bold;">/</span>tmp<span style="color: #000000; font-weight: bold;">/</span>R-2.11.1 <span style="color: #000000; font-weight: bold;">%</span> .<span style="color: #000000; font-weight: bold;">/</span>configure <span style="color: #007800;">CFLAGS</span>=-I<span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span>csw<span style="color: #000000; font-weight: bold;">/</span>include \
<span style="color: #000000; font-weight: bold;">`&gt;</span> <span style="color: #007800;">LDFLAGS</span>=-L<span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span>csw<span style="color: #000000; font-weight: bold;">/</span>lib \
<span style="color: #000000; font-weight: bold;">`&gt;</span> <span style="color: #007800;">GCC</span>=<span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>gcc<span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">4.3</span><span style="color: #000000; font-weight: bold;">/</span>bin<span style="color: #000000; font-weight: bold;">/</span><span style="color: #c20cb9; font-weight: bold;">gcc</span>\
<span style="color: #000000; font-weight: bold;">`&gt;</span> <span style="color: #007800;">CFLAGS</span>=<span style="color: #ff0000;">'&lt;falg 1&gt; &lt;flag 2&gt; &lt;flag 3&gt;'</span> \
<span style="color: #000000; font-weight: bold;">`&gt;</span> <span style="color: #660033;">--prefix</span>=<span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span>R
....
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla <span style="color: #000000; font-weight: bold;">/</span>tmp<span style="color: #000000; font-weight: bold;">/</span>R-2.11.1 <span style="color: #000000; font-weight: bold;">%</span> <span style="color: #c20cb9; font-weight: bold;">gmake</span></pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://www.r-project.org/
 [2]: http://www.sunfreeware.com/
 [3]: http://www.sunfreeware.com/programlistsparc10.html#R
 [4]: http://www.blastwave.org/
 [5]: http://gcc.gnu.org/onlinedocs/gcc/SPARC-Options.html
 [6]: http://gcc.gnu.org/onlinedocs/gcc/i386-and-x86_002d64-Options.html