---
title: Mercurial
author: Michael Rennecke
type: post
date: 2011-02-21T23:32:47+00:00
url: /tools/mercurial
categories:
  - Tools
tags:
  - hg
  - mercurial

---
Ich wollte eben, mal schnell ein [Mercurial][1]-Repository einen Bekannten zur Verfügung stellen. Also habe ich es auf seinen Server kopiert. Nun kam die Überraschung: Es ging nicht mehr. Es gibt die typischen dubiosen Fehlermeldungen von [Mercurial][1], bei denen niemand weiß was los ist. Da ich schon sehr lange unter Solaris mit [Mercurial][1] arbeite kenne ich so ein paar Fallstricke.

In diesem Fall war die [Mercurial][1]-Versionen verschieden. In vielen Fällen, kann man das wie folgt beheben:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666; font-style: italic;"># remote-Server</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>odin <span style="color: #000000; font-weight: bold;">/</span>export<span style="color: #000000; font-weight: bold;">/</span>repos <span style="color: #000000; font-weight: bold;">%</span> hg init newrepo
<span style="color: #666666; font-style: italic;"># local host</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~<span style="color: #000000; font-weight: bold;">/</span>repo <span style="color: #7a0874; font-weight: bold;">&#40;</span>hg<span style="color: #7a0874; font-weight: bold;">&#41;</span>-<span style="color: #7a0874; font-weight: bold;">&#91;</span>default<span style="color: #7a0874; font-weight: bold;">&#93;</span> <span style="color: #000000; font-weight: bold;">%</span> hg push ssh:<span style="color: #000000; font-weight: bold;">//</span>rennecke<span style="color: #000000; font-weight: bold;">@</span>odin<span style="color: #000000; font-weight: bold;">//</span>export<span style="color: #000000; font-weight: bold;">/</span>repos<span style="color: #000000; font-weight: bold;">/</span>newrepo</pre>
      </td>
    </tr>
  </table>
</div>

Nachdem man auf dem Server ein leeren Repo angelegt hat, kann man die Inhalte rein pushen. Wenn man hinter einem Proxy-Server ist, kann man diesen gleich mit angeben:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ <span style="color: #000000; font-weight: bold;">%</span> hg <span style="color: #660033;">--config</span> http_proxy.host=my-proxy.org:<span style="color: #000000;">3128</span> clone  ssh:<span style="color: #000000; font-weight: bold;">//</span>rennecke<span style="color: #000000; font-weight: bold;">@</span>odin<span style="color: #000000; font-weight: bold;">//</span>export<span style="color: #000000; font-weight: bold;">/</span>repos<span style="color: #000000; font-weight: bold;">/</span>newrepo</pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://mercurial.selenic.com/