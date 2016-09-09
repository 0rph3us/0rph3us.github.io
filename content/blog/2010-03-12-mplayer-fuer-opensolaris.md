---
title: mplayer für OpenSolaris
author: Michael Rennecke
type: post
date: 2010-03-12T21:28:33+00:00
url: /solaris/mplayer-fuer-opensolaris
categories:
  - Solaris
tags:
  - mplayer
  - OpenSolaris

---
Es gibt [hier][1] schon eine Anleitung, wie man den mplayer mit einer GUI übersetzt. Diese Anleitung funktioniert ganz gut, aber [mencoder][2] arbeitet nicht richtig.

Aus diesem Grund kommt hier meine Anleitung. Diese sieht wie folgt aus:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla tmp $ pfexec pkg <span style="color: #c20cb9; font-weight: bold;">install</span> SUNWgcc SUNWgmake SUNWxorg-headers SUNWGtk SUNWsfwhea gcc-dev-<span style="color: #000000;">4</span> gcc-runtime-<span style="color: #000000;">4</span></pre>
      </td>
    </tr>
  </table>
</div>

Nachdem man sich den Code heruntergeladen und entpackt hat setzt man noch ein paar Umgebungsvariablen:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla mplayer-export-<span style="color: #000000;">2010</span>-02-<span style="color: #000000;">18</span> $ <span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">CC</span>=<span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>bin<span style="color: #000000; font-weight: bold;">/</span>gcc-4.3.2 bzw. <span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">CC</span>=<span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>gcc<span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">4.3</span><span style="color: #000000; font-weight: bold;">/</span>bin<span style="color: #000000; font-weight: bold;">/</span><span style="color: #c20cb9; font-weight: bold;">gcc</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla mplayer-export-<span style="color: #000000;">2010</span>-02-<span style="color: #000000;">18</span> $ <span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">PATH</span>=<span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>gnu<span style="color: #000000; font-weight: bold;">/</span>bin<span style="color: #000000; font-weight: bold;">/</span>:<span style="color: #007800;">$PATH</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla mplayer-export-<span style="color: #000000;">2010</span>-02-<span style="color: #000000;">18</span> $ .<span style="color: #000000; font-weight: bold;">/</span>configure  <span style="color: #660033;">--prefix</span>=<span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span><span style="color: #c20cb9; font-weight: bold;">mplayer</span> <span style="color: #660033;">--enable-gui</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla mplayer-export-<span style="color: #000000;">2010</span>-02-<span style="color: #000000;">18</span> $ <span style="color: #c20cb9; font-weight: bold;">make</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla mplayer-export-<span style="color: #000000;">2010</span>-02-<span style="color: #000000;">18</span> $ pfexec <span style="color: #c20cb9; font-weight: bold;">make</span> <span style="color: #c20cb9; font-weight: bold;">install</span></pre>
      </td>
    </tr>
  </table>
</div>

Der Rest funktioniert, wird [hier][1] beschrieben.

 [1]: http://blogs.sun.com/observatory/entry/compiling_mplayer_on_opensolaris_this
 [2]: http://de.wikipedia.org/wiki/MEncoder