---
title: bunter Host in der Codeumgebung
author: Michael Rennecke
type: post
date: 2010-04-18T11:58:35+00:00
categories:
  - sonstiges
  - Tools
tags:
  - hack
  - Syntaxhighlighting
  - wordpress

---
Ich wurde gefragt, wie ich den user und den hostname in meinen Code-Umgebungen bunt bekomme. Ich benutze für das Syntaxhighlighting das Plugin [WP-Syntax][1]. Dieses wiederrum nutzt [GeSHi][2] im Hintergrund.

Damit der Hostname bunt wird, habe ich die Syntax der bash etwas erweitert. Dazu habe ich in der Datei <tt>wp-content/plugins/wp-syntax/geshi/geshi</tt> ein paar Zeilen hinzu gef&uuml;gt:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="php" style="font-family:monospace;">language_data <span style="color: #339933;">=</span> <span style="color: #990000;">array</span> <span style="color: #009900;">&#40;</span>
    <span style="color: #0000ff;">'LANG_NAME'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'Bash'</span><span style="color: #339933;">,</span>
    <span style="color: #666666; font-style: italic;">// Bash DOES have single line comments with # markers. But bash also has</span>
    <span style="color: #666666; font-style: italic;">// the  $# variable, so comments need special handling (see sf.net</span>
    <span style="color: #666666; font-style: italic;">// 1564839)</span>
    <span style="color: #0000ff;">'COMMENT_SINGLE'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #990000;">array</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">'#'</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">,</span>
    <span style="color: #0000ff;">'COMMENT_MULTI'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #990000;">array</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">,</span>
    <span style="color: #0000ff;">'COMMENT_REGEXP'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #990000;">array</span><span style="color: #009900;">&#40;</span>
        <span style="color: #666666; font-style: italic;">//Variables</span>
        <span style="color: #cc66cc;">1</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">"/<span style="color: #000099; font-weight: bold;">\\</span>$<span style="color: #000099; font-weight: bold;">\\</span>{[^<span style="color: #000099; font-weight: bold;">\\</span>n<span style="color: #000099; font-weight: bold;">\\</span>}]*?<span style="color: #000099; font-weight: bold;">\\</span>}/i"</span><span style="color: #339933;">,</span>
        <span style="color: #666666; font-style: italic;">//BASH-style Heredoc</span>
        <span style="color: #cc66cc;">2</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'/&lt;&lt;-?\s*?(\'?)([a-zA-Z0-9]+)\1\\n.*\\n\\2(?![a-zA-Z0-9])/siU'</span><span style="color: #339933;">,</span>
        <span style="color: #666666; font-style: italic;">//Escaped String Starters</span>
        <span style="color: #cc66cc;">3</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">"/<span style="color: #000099; font-weight: bold;">\\</span><span style="color: #000099; font-weight: bold;">\\</span>['<span style="color: #000099; font-weight: bold;">\"</span>]/siU"</span><span style="color: #339933;">,</span>
	<span style="color: #cc66cc;">4</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">"/(root@[a-z]+)/i"</span><span style="color: #339933;">,</span>          <span style="color: #666666; font-style: italic;">// root hat sich angemeldet</span>
	<span style="color: #cc66cc;">5</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">"/([a-z]+@[a-z]+)/i"</span>         <span style="color: #666666; font-style: italic;">// ein normaler User hat sich angemeldet</span>
        <span style="color: #009900;">&#41;</span><span style="color: #339933;">,</span>
        <span style="color: #339933;">....</span>
<span style="color: #0000ff;">'STYLES'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #990000;">array</span><span style="color: #009900;">&#40;</span>
        <span style="color: #0000ff;">'KEYWORDS'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #990000;">array</span><span style="color: #009900;">&#40;</span>
            <span style="color: #cc66cc;">1</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #000000; font-weight: bold;'</span><span style="color: #339933;">,</span>
            <span style="color: #cc66cc;">2</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #c20cb9; font-weight: bold;'</span><span style="color: #339933;">,</span>
            <span style="color: #cc66cc;">3</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #7a0874; font-weight: bold;'</span>
            <span style="color: #009900;">&#41;</span><span style="color: #339933;">,</span>
        <span style="color: #0000ff;">'COMMENTS'</span> <span style="color: #339933;">=&gt;</span> <span style="color: #990000;">array</span><span style="color: #009900;">&#40;</span>
            <span style="color: #cc66cc;"></span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #666666; font-style: italic;'</span><span style="color: #339933;">,</span>
            <span style="color: #cc66cc;">1</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #800000;'</span><span style="color: #339933;">,</span>
            <span style="color: #cc66cc;">2</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #cc0000; font-style: italic;'</span><span style="color: #339933;">,</span>
            <span style="color: #cc66cc;">3</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #000000; font-weight: bold;'</span><span style="color: #339933;">,</span>
  	    <span style="color: #cc66cc;">4</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #FF0000; font-weight: bold;'</span><span style="color: #339933;">,</span>     <span style="color: #666666; font-style: italic;">// Farbe und Font für root</span>
	    <span style="color: #cc66cc;">5</span> <span style="color: #339933;">=&gt;</span> <span style="color: #0000ff;">'color: #0000FF; font-weight: bold;'</span>      <span style="color: #666666; font-style: italic;">// Farbe und Font für einen normalen User</span>
            <span style="color: #009900;">&#41;</span><span style="color: #339933;">,</span>
           <span style="color: #339933;">...</span></pre>
      </td>
    </tr>
  </table>
</div>

Es handelt sich hierbei um einen Hack. Wenn man das Plugin updatet, muss man diese &Auml;nderung wieder vornehmen.

 [1]: http://wordpress.org/extend/plugins/wp-syntax/
 [2]: http://qbnz.com/highlighter/