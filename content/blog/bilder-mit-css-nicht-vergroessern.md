---
title: Bilder mit css nicht vergrößern
author: Michael Rennecke
type: post
date: 2011-03-01T13:13:39+00:00
categories:
  - Programmieren
tags:
  - css
  - hack
  - nextgen-gallery
  - wordpress

---
Ich habe in meinen Blog inzwischen auch Bilder und ich nutze die [NextGEN Gallery][1]. Aus Platzgründen verkleinere ich die Bilder. Die Bilder, welche im Hochformat sind sehen einfach grausam aus, da sie stark vergrößert werden. Durch den folgenden Hack im [css][2] werden die Bilder nicht mehr vergrößert. Dazu muss man die Datei <tt>nextgen-gallery/css/nggallery.css</tt> wie folgt ändern:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="css" style="font-family:monospace;"><span style="color: #6666ff;">.ngg-imagebrowser</span> img <span style="color: #00AA00;">&#123;</span>
    <span style="color: #000000; font-weight: bold;">border</span><span style="color: #00AA00;">:</span> <span style="color: #933;">1px</span> <span style="color: #993333;">solid</span> <span style="color: #cc00cc;">#A9A9A9</span><span style="color: #00AA00;">;</span>
    <span style="color: #000000; font-weight: bold;">display</span><span style="color: #00AA00;">:</span> <span style="color: #993333;">block</span> !important<span style="color: #00AA00;">;</span>
    <span style="color: #000000; font-weight: bold;">margin</span><span style="color: #00AA00;">:</span> <span style="color: #933;">10px</span> <span style="color: #993333;">auto</span><span style="color: #00AA00;">;</span>
    <span style="color: #000000; font-weight: bold;">max-width</span><span style="color: #00AA00;">:</span> <span style="color: #933;">100%</span><span style="color: #00AA00;">;</span>
    <span style="color: #000000; font-weight: bold;">padding</span><span style="color: #00AA00;">:</span> <span style="color: #933;">5px</span><span style="color: #00AA00;">;</span>
<span style="color: #00AA00;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Achtung: Die Änderung geht bei einen automatischen Update des Plugins verloren!

 [1]: http://nextgen-gallery.com/
 [2]: http://www.w3.org/TR/2002/WD-CSS21-20020802/