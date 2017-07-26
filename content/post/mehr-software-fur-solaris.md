---
title: mehr Software für Solaris
author: Michael Rennecke
type: post
date: 2010-05-16T18:30:36+00:00
excerpt: |
  |
    <p>
    Manchmal ärgert man sich, dass es das ein oder andere Package nicht für (Open)Solaris gibt. Man kann ohne Probleme die Pakages von <a href="http://www.blastwave.org/">Blastwave</a> bzw. <a href="http://www.opencsw.org/">OpenCSW</a> nutzen. Es sind noch die "alten" SystemV-Pakages von Solaris 10 und älter. Man kann sie jedoch ohne Einschänkungen unter OpenSolaris nutzen.
    </p>
    <p>
    Ich habe das Gefühl, das in <a href="http://csw.informatik.uni-erlangen.de/csw">Erlangen</a> die meisten Pakages zu finden sind. Deswegen habe ich in meine <tt>/opt/csw/etc/pkgutil.conf</tt> die folgende Zeile eingetragen:
    mirror=http://csw.informatik.uni-erlangen.de/csw/unstable/
    
    Wenn man <a href="http://www.blastwave.org/">Blastwave</a> bzw. <a href="http://www.opencsw.org/">OpenCSW</a> noch nicht nutzt, dann kann man <a href="http://csw.informatik.uni-erlangen.de/csw/README">hier</a> nachlesen, wie man sich diese Packages zugänglich macht. Auf jeden Fall sollte man in der  <tt>/opt/csw/etc/pkgutil.conf</tt> nachsehen, ob <a href="http://csw.informatik.uni-erlangen.de/csw/unstable/">http://csw.informatik.uni-erlangen.de/csw/unstable/</a> als mirror eingetragen ist.
    </p>
categories:
  - Solaris
tags:
  - blastwave
  - csw
  - OpenSolaris
  - pkg
  - Sparc

---
Manchmal ärgert man sich, dass es das ein oder andere Package nicht für (Open)Solaris gibt. Man kann ohne Probleme die Pakages von [Blastwave][1] bzw. [OpenCSW][2] nutzen. Es sind noch die &#8220;alten&#8221; SystemV-Pakages von Solaris 10 und älter. Man kann sie jedoch ohne Einschänkungen unter OpenSolaris nutzen. 

Ich habe das Gefühl, das in [Erlangen][3] die meisten Pakages zu finden sind. Deswegen habe ich in meine <tt>/opt/csw/etc/pkgutil.conf</tt> die folgende Zeile eingetragen:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666; font-style: italic;"># Mirror to use for downloads</span>
<span style="color: #666666; font-style: italic;"># See http://www.blastwave.org/mirrors.php for alternative mirrors</span>
<span style="color: #666666; font-style: italic;"># Default: http://blastwave.network.com/csw/unstable</span>
<span style="color: #666666; font-style: italic;">#mirror=http://blastwave.network.com/csw/unstable</span>
<span style="color: #007800;">mirror</span>=http:<span style="color: #000000; font-weight: bold;">//</span>csw.informatik.uni-erlangen.de<span style="color: #000000; font-weight: bold;">/</span>csw<span style="color: #000000; font-weight: bold;">/</span>unstable<span style="color: #000000; font-weight: bold;">/</span></pre>
      </td>
    </tr>
  </table>
</div>

Wenn man [Blastwave][1] bzw. [OpenCSW][2] noch nicht nutzt, dann kann man [hier][4] nachlesen, wie man sich diese Packages zugänglich macht. Auf jeden Fall sollte man in der <tt>/opt/csw/etc/pkgutil.conf</tt> nachsehen, ob <http://csw.informatik.uni-erlangen.de/csw/unstable/> als mirror eingetragen ist.

 [1]: http://www.blastwave.org/
 [2]: http://www.opencsw.org/
 [3]: http://csw.informatik.uni-erlangen.de/csw
 [4]: http://csw.informatik.uni-erlangen.de/csw/README