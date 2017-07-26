---
title: OpenIndiana und erste Erfahrungen
author: Michael Rennecke
type: post
date: 2010-09-17T09:04:31+00:00
excerpt: |
  <p>
  Ich habe es endlich geschafft: ein Update auf <strong><a href="http://openindiana.org/">OpenIndiana</a></strong> Im gro&szlig;en und ganzen kann man es einigerma&szlig;en benutzen. Die Lokalisierung ist mehr als schlecht. Das meiste kann man irgendwie fixen</p>
categories:
  - Solaris
tags:
  - enigmail
  - hack
  - Illumos
  - OpenIndiana
  - OpenSolaris
  - pkg
  - problem
  - Tastatur
  - thunderbird
  - update
  - upgrade

---
Ich habe es endlich geschafft: ein Update auf **[OpenIndiana][1]** Im großen und ganzen kann man es einigermaßen benutzen. Die Lokalisierung ist mehr als schlecht. Das meiste kann man irgendwie fixen

#### Update auf OpenIndiana

Man findet [hier][2] auch die orginale Anleitung zum Update.

  1. update auf Build 134 bzw. Build 134 booten (wie man bootet zeige ich nicht 😉 ) <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg <span style="color: #c20cb9; font-weight: bold;">install</span> SUNWipkg SUNWipkg-um SUNWipkg-gui
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg set-publisher <span style="color: #660033;">-O</span> http:<span style="color: #000000; font-weight: bold;">//</span>pkg.openindiana.org<span style="color: #000000; font-weight: bold;">/</span>legacy opensolaris.org
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg image-update</pre>
          </td>
        </tr>
      </table>
    </div>

  2. Update auf OpenIndiana <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg set-publisher <span style="color: #660033;">--non-sticky</span> opensolaris.org
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg set-publisher <span style="color: #660033;">-p</span> http:<span style="color: #000000; font-weight: bold;">//</span>pkg.openindiana.org<span style="color: #000000; font-weight: bold;">/</span>dev
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg set-publisher <span style="color: #660033;">-P</span> openindiana.org
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg uninstall entire
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg uninstall thunderbird <span style="color: #666666; font-style: italic;"># das Paket konnte ich nicht updaten</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg uninstall songbird    <span style="color: #666666; font-style: italic;"># das Paket konnte ich nicht updaten</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg image-update</pre>
          </td>
        </tr>
      </table>
    </div>

#### Troubleshooting

  * Ich bekomme folgende Fehler <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg image-update
DOWNLOAD                                  PKGS       FILES    XFER <span style="color: #7a0874; font-weight: bold;">&#40;</span>MB<span style="color: #7a0874; font-weight: bold;">&#41;</span>
mail<span style="color: #000000; font-weight: bold;">/</span>thunderbird                       <span style="color: #000000;">183</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">838</span>  <span style="color: #000000;">8825</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">40200</span>  <span style="color: #000000;">120.2</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">648.9</span>  
&nbsp;
Fehler beim Abrufen von Paket oder Dateidaten für
den angeforderten Vorgang.
Details folgen:
&nbsp;
Invalid content path usr<span style="color: #000000; font-weight: bold;">/</span>lib<span style="color: #000000; font-weight: bold;">/</span>thunderbird<span style="color: #000000; font-weight: bold;">/</span>thunderbird-bin: chash failure: expected: 64fd9c1561c244e0563dfc675dbd3a8c3c86f469 computed: 9179b65e28cc293105c6368ee818f1729eb7f991. <span style="color: #7a0874; font-weight: bold;">&#40;</span>happened <span style="color: #000000;">4</span> <span style="color: #7a0874; font-weight: bold;">times</span><span style="color: #7a0874; font-weight: bold;">&#41;</span></pre>
          </td>
        </tr>
      </table>
    </div>
    
    oder
    
    <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pkg image-update
DOWNLOAD                                  PKGS       FILES    XFER <span style="color: #7a0874; font-weight: bold;">&#40;</span>MB<span style="color: #7a0874; font-weight: bold;">&#41;</span>
mail<span style="color: #000000; font-weight: bold;">/</span>thunderbird                       <span style="color: #000000;">190</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">838</span>  <span style="color: #000000;">7945</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">40200</span>  <span style="color: #000000;">131.8</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">648.9</span>  
&nbsp;
Errors were encountered <span style="color: #000000; font-weight: bold;">while</span> attempting to retrieve package or <span style="color: #c20cb9; font-weight: bold;">file</span> data <span style="color: #000000; font-weight: bold;">for</span>
the requested operation.
Details follow:
&nbsp;
Framework error: code: <span style="color: #000000;">18</span> reason: transfer closed with <span style="color: #000000;">13603900</span> bytes remaining to <span style="color: #c20cb9; font-weight: bold;">read</span>
URL: <span style="color: #ff0000;">'http://pkg.openindiana.org/dev/file/0/c5df73fea1fb6f63f0f17cf5e996e8525fc1a4f4'</span>. <span style="color: #7a0874; font-weight: bold;">&#40;</span>happened <span style="color: #000000;">4</span> <span style="color: #7a0874; font-weight: bold;">times</span><span style="color: #7a0874; font-weight: bold;">&#41;</span></pre>
          </td>
        </tr>
      </table>
    </div>
    
    Dann einfach das betreffende Paket deinstallieren und später wieder installieren.

  * Firefox und Thunderbird gehen nicht. Das Problem ist die Lokalisierung. 
    <br class="spacer_" />
    
    <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> <span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">LANG</span>=C
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> firefox <span style="color: #000000; font-weight: bold;">&</span>amp;</pre>
          </td>
        </tr>
      </table>
    </div>

  * Ich habe das falsche Tastaturlayout <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ $ setxkbmap de           <span style="color: #666666; font-style: italic;"># setzt das persönlich Layout auf de</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ $ <span style="color: #c20cb9; font-weight: bold;">cat</span> .Xkbmap            <span style="color: #666666; font-style: italic;"># Datei wird ausgewertet, beim starten der Sitzung</span>
de</pre>
          </td>
        </tr>
      </table>
    </div>
    
    Die ganzen anderen Möglichkeiten (welche solaristypisch sind) haben bei mir nicht funktioniert.

  * Enigmail bei Thunderbird funktioniert nicht mehr. Einfach auf der [Webseite][3] das Plugin herunter laden und installieren

 [1]: http://openindiana.org/
 [2]: http://wiki.openindiana.org/oi/Installing+or+Upgrading#InstallingorUpgrading-UpgradingfromOpenSolaris
 [3]: http://enigmail.mozdev.org/download/download-static.php