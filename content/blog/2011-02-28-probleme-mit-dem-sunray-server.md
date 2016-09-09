---
title: Probleme mit dem SunRay-Server
author: Michael Rennecke
type: post
date: 2011-02-28T19:36:50+00:00
url: /solaris/probleme-mit-dem-sunray-server
categories:
  - Solaris
tags:
  - gdm
  - gnome
  - Java Desktop
  - Solaris
  - Sun Ray
  - SunRay
  - tmp

---
Ich habe heute etwas l&auml;nger geschlafen. Als erste Tagesaufgabe habe ich pflichtbewusst meine Mails gelesen und schon kam eine User-Mail, dass der [SunRay][1]-Server nicht l&auml;uft.

Ein Fehler war schnell gefunden: Der [gdm][2] lief nicht. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">sunray ~ <span style="color: #666666; font-style: italic;"># svcs -a | grep gdm</span>
disabled       <span style="color: #000000;">11</span>:<span style="color: #000000;">38</span>:<span style="color: #000000;">23</span> svc:<span style="color: #000000; font-weight: bold;">/</span>application<span style="color: #000000; font-weight: bold;">/</span>gdm2-login:default
sunray ~ <span style="color: #666666; font-style: italic;"># svcadm enable svc:/application/gdm2-login:default</span></pre>
      </td>
    </tr>
  </table>
</div>

Nun konnte man sich via [CDE][3] einloggen, aber nicht mit dem [Java Desktop][4], welcher auf [gnome][5] basiert. Nach nervigen Suchen hat sich auch [Rumpel][6] zu mir gesetzt. Dabei ist mir aufgefallen, dass in <tt>/tmp</tt> nur <tt>root</tt> schreiben darf, nachdem in <tt>/tmp</tt> wieder jeder schreiben durfte, lief wieder alles korrekt.

 [1]: http://www.sun-rays.org/
 [2]: http://projects.gnome.org/gdm/
 [3]: http://www.opengroup.org/cde/
 [4]: http://www.sun.com/software/solaris/javadesktopsystem.xml
 [5]: http://www.gnome.org/
 [6]: https://users.informatik.uni-halle.de/~ruttkies/RforRocks/