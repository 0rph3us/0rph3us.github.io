---
title: unison
author: Michael Rennecke
type: post
date: 2010-03-22T22:42:56+00:00
categories:
  - Solaris
  - Tools
tags:
  - Backup
  - OpenSolaris
  - Synchronisation
  - unison

---
Mit dem Tool [unison][1] kann man sehr gut Verzeichnisse synchronisieren. Es gibt auch ein Package für Open Solaris. Es heißt **SUNWunison**. Wenn man via ssh-Verbindung synchronisiert muss man vor dem Ziel-Verzeichnis 2 Backslash schreiben, wenn man nur lokal synchronisiert ist das nicht nötig. Ein Profil könnte dann wie folgt aussehen:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ $ <span style="color: #c20cb9; font-weight: bold;">cat</span> .unison<span style="color: #000000; font-weight: bold;">/</span>default.prf
<span style="color: #666666; font-style: italic;"># Unison preferences file</span>
root = <span style="color: #000000; font-weight: bold;">/</span>export<span style="color: #000000; font-weight: bold;">/</span>home<span style="color: #000000; font-weight: bold;">/</span>rennecke
root = ssh:<span style="color: #000000; font-weight: bold;">//</span>rennecke<span style="color: #000000; font-weight: bold;">@</span>zeus<span style="color: #000000; font-weight: bold;">//</span>home<span style="color: #000000; font-weight: bold;">/</span>rennecke</pre>
      </td>
    </tr>
  </table>
</div>

Das Tool ist sehr intuitiv zu bedienen und ein Blick wert.

 [1]: http://www.cis.upenn.edu/%7Ebcpierce/unison/
