---
title: Systemmails per Thunderbird abrufen
author: Michael Rennecke
type: post
date: 2010-04-19T06:57:24+00:00
categories:
  - Solaris
tags:
  - admin
  - OpenSolaris
  - thunderbird

---
Manchmal ist sch&ouml;n, wenn man die Systemmail abrufen kann. Bei OpenSolaris gibt es per default keinen Nutzer root und ein normaler Nutzer darf nicht auf Mails von root zugreifen. Die saubere L&ouml;sung ist, dass man einen Alias einrichtet. Dazu f&uuml;gt man der <tt>/etc/aliases</tt> die folgende Zeilen hinzu. Anschlie&szlig;end werden alle Mails von root an jack weiter geleitet. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666; font-style: italic;">#######################</span>
<span style="color: #666666; font-style: italic;"># Local aliases below #</span>
<span style="color: #666666; font-style: italic;">#######################</span>
&nbsp;
root: jack</pre>
      </td>
    </tr>
  </table>
</div>

Nachdem man das nun gemacht hat muss man die <tt>/etc/aliases</tt> neu einlesen.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">jack<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec newaliases
<span style="color: #000000; font-weight: bold;">/</span>etc<span style="color: #000000; font-weight: bold;">/</span>mail<span style="color: #000000; font-weight: bold;">/</span>aliases: <span style="color: #000000;">13</span> aliases, longest <span style="color: #000000;">10</span> bytes, <span style="color: #000000;">150</span> bytes total</pre>
      </td>
    </tr>
  </table>
</div>

Nun schicken wir root eine Testmail. Dazu verwenden wir das Kommando <tt>mailx</tt>. Um es zu beenden muss man **.** dr&uuml;cken.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">jack<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> mailx root
Subject: Hallo
Hallo Welt<span style="color: #000000; font-weight: bold;">!</span>
.
EOT</pre>
      </td>
    </tr>
  </table>
</div>

Nun estellt man einen Symlink vom Mailverzeichnis, damit man die Mails auch im Thunderbird lesen kann. Es geht auch jeder ander Mailclient, welcher mit dem [mbox][1]-Format umgehen kann

<tt>1ss1e32i.default</tt> ist das aktuelle Profil, das ist auf jeden Rechner anders. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">jack<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> <span style="color: #c20cb9; font-weight: bold;">ln</span> <span style="color: #660033;">-s</span> <span style="color: #000000; font-weight: bold;">/</span>var<span style="color: #000000; font-weight: bold;">/</span>mail<span style="color: #000000; font-weight: bold;">/</span>jack .thunderbird<span style="color: #000000; font-weight: bold;">/</span>1ss1e32i.default<span style="color: #000000; font-weight: bold;">/</span>Mail<span style="color: #000000; font-weight: bold;">/</span>Local\ Folders<span style="color: #000000; font-weight: bold;">/</span>System</pre>
      </td>
    </tr>
  </table>
</div>

Fertig! Nun hat man nach dem Neustart von Thunderbird ein Unterverzeichnis <tt>System</tt> im Verzeichnis <tt>Lokale Ordner</tt>

 [1]: http://www.qmail.org/man/man5/mbox.html