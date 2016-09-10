---
title: Optischer Randausgleich
author: Michael Rennecke
type: post
date: 2010-09-03T16:41:42+00:00
categories:
  - sonstiges
  - Tools
tags:
  - blocksatz
  - latex
  - optischer Randausgleich
  - Word

---
Ich schreibe meine Diplomarbeit mit <img src='http://s0.wp.com/latex.php?latex=%5CLaTeX&#038;bg=ffffff&#038;fg=000000&#038;s=0' alt='\LaTeX' title='\LaTeX' class='latex' />. Da bekommt man auch einen sch&ouml;nen Blocksatz hin. Der Blocksatz wird auf dem gesamten Absatz, unter beachtung m&ouml;glicher Worttrennungen berechnet. Deswegen sieht der Blocksatz besser aus als mit Word. Man kann den Blocksatz noch verbessern, indem man den _optischen Randausgleich_ nutzt. Das funktioniert wie normaler Blocksatz, mit dem unterschied, dass der Grauwert des linken Rand gleich ist. Ein Bindestrich ragt z.B. mehr in Rand hinein als ein m. da ein Bindestrich weniger schwarz enth&auml;lt als ein m. F&uuml;r das Auge sieht der linke Rand nun gerade aus. Man muss daf&uuml;r nur das Package **microtype** einbinden. [Hier][1] ist die Doku dazu. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="latex" style="font-family:monospace;">...
<span style="color: #2C922C; font-style: italic;">%optischer Randausgleich aktivieren</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">usepackage</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;">microtype</span><span style="color: #E02020; ">}</span>             <span style="color: #2C922C; font-style: italic;">% ist auf alten Installation nicht immer vorhanden</span>
<span style="color: #2C922C; font-style: italic;">% \usepackage[activate]{pdfcprot}  % wird nicht mehr weiter entwickelt</span>
...</pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://www.ctan.org/tex-archive/macros/latex/contrib/microtype/microtype.pdf