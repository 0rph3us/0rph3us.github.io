---
title: svn und Proxy-Server
author: Michael Rennecke
type: post
date: 2010-04-12T17:14:14+00:00
categories:
  - Tools
tags:
  - Netzwerk
  - OpenSolaris
  - proxy
  - svn

---
Ich sitze dummerweise hinter einem Proxyserver. Als ich ein Repository auschecken wollte hat sich sehr lange nichts getan. Bis ich auf die zündete Idee gekommen bin, dass es vielleicht am Proxy liegt. Einen Proxyserver kann man global in der Datei <tt>/etc/subversion/servers</tt> oder im Home <tt>.subversion</tt> konfigurieren

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #7a0874; font-weight: bold;">&#91;</span>global<span style="color: #7a0874; font-weight: bold;">&#93;</span>
http-proxy-host=proxyhost
http-proxy-port=<span style="color: #000000;">3128</span></pre>
      </td>
    </tr>
  </table>
</div>

Bei den meisten Linux-Distributionen ist das nicht n&ouml;tig, aber bei (Open) Solaris