---
title: 'LaTeX: Bilder an eine bestimmte Stelle platzieren'
author: Michael Rennecke
type: post
date: 2010-08-27T11:31:17+00:00
wp_jd_wp:
  - http://0rpheus.net/?p=3862
wp_jd_target:
  - http://0rpheus.net/?p=3862
categories:
  - sonstiges
  - Tools
tags:
  - Bild
  - float
  - here
  - latex
  - platzieren
  - texlive

---
Wenn man bei   <img src='http://s0.wp.com/latex.php?latex=%5CLaTeX&#038;bg=ffffff&#038;fg=000000&#038;s=0' alt='\LaTeX' title='\LaTeX' class='latex' />Bilder einfügt, dann wundert man sich vielleicht, dass sie an einer anderden Stelle sind.   <img src='http://s0.wp.com/latex.php?latex=%5CLaTeX&#038;bg=ffffff&#038;fg=000000&#038;s=0' alt='\LaTeX' title='\LaTeX' class='latex' />setzt normal die Bilder so, dass man möglichst wenig weiße Fläche hat. Manchmal möchte man erzwingen, dass ein Bild an einer bestimmten Position ist. Dafür gibt es das alte Package **here**, welches inzwischen bei [TeX Live][1] durch **float** ersetzt wurde.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="latex" style="font-family:monospace;"><span style="color: #E02020; ">\</span><span style="color: #800000;">usepackage</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;">float</span><span style="color: #E02020; ">}</span> <span style="color: #2C922C; font-style: italic;">% lädt das Paket zum erzwingen der Grafikposition</span>
<span style="color: #2C922C; font-style: italic;">%\usepackage{here} auf älteren LaTeX Distributionen</span>
&nbsp;
<span style="color: #C00000; font-weight: normal;">\begin</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;"><span style="color: #0000D0; font-weight: normal;">document</span><span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #C00000; font-weight: normal;">\begin</span><span style="color: #E02020; ">{</span><span style="color: #0000D0; font-weight: normal;">figure</span></span><span style="color: #E02020; ">}[</span><span style="color: #C08020; font-weight: normal;">H</span><span style="color: #E02020; ">]</span>
   <span style="color: #2C922C; font-style: italic;">%mit dem großen H wird die Grafikposition auf HERE gesetzt</span>
   <span style="color: #E02020; ">\</span><span style="color: #800000;">centering</span>
   <span style="color: #E02020; ">\</span><span style="color: #800000;">fbox</span><span style="color: #E02020; ">{</span> <span style="color: #2C922C; font-style: italic;">%erzeugt einen Rahmen um die Grafik</span>
      <span style="color: #E02020; ">\</span><span style="color: #800000;">includegraphics</span><span style="color: #E02020; ">[</span><span style="color: #C08020; font-weight: normal;">angle=0,width=5cm</span><span style="color: #E02020; ">]{</span><span style="color: #2020C0; font-weight: normal;">Bild.png<span style="color: #E02020; ">}</span>
   <span style="color: #E02020; ">}</span>
<span style="color: #C00000; font-weight: normal;">\end</span><span style="color: #E02020; ">{</span><span style="color: #0000D0; font-weight: normal;">figure</span><span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #C00000; font-weight: normal;">\end</span><span style="color: #E02020; ">{</span><span style="color: #0000D0; font-weight: normal;">document</span></span><span style="color: #E02020; ">}</span></pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://tug.org/texlive/