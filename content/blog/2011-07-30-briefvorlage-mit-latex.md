---
title: Briefvorlage mit LaTeX
author: Michael Rennecke
type: post
date: 2011-07-30T19:26:59+00:00
url: /privat/briefvorlage-mit-latex
categories:
  - privat
  - Programmieren
  - sonstiges
tags:
  - Brief
  - latex
  - Mobil
  - Telefon

---
Ich bin vor kurzem umgezogen und bin inzwischen Besitzer eines Festnetztelefon. Aus diesem Grund wollte ich in meiner <img src='http://s0.wp.com/latex.php?latex=%5CLaTeX&#038;bg=ffffff&#038;fg=000000&#038;s=0' alt='\LaTeX' title='\LaTeX' class='latex' />-Vorlage für meine Briefe beide Nummern stehen haben. Die [KOMA-Skript][1] Pakte können von Haus aus, nur eine Telefonnummer, deswegen habe ich meine Vorlage, welche ich von [meet-unix][2] habe, wie folgt angepasst. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="latex" style="font-family:monospace;"><span style="color: #800000; font-weight: normal;">\ProvidesFile</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;">letter_options.lco</span><span style="color: #E02020; ">}[</span><span style="color: #C08020; font-weight: normal;">letter-class-option file</span><span style="color: #E02020; ">]</span>
&nbsp;
<span style="color: #2C922C; font-style: italic;">% symbols: (cell)phone, email</span>
<span style="color: #800000; font-weight: normal;">\RequirePackage</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;">marvosym</span><span style="color: #E02020; ">}</span> 
<span style="color: #2C922C; font-style: italic;">% for gray color in header</span>
<span style="color: #800000; font-weight: normal;">\RequirePackage</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;">color<span style="color: #E02020; ">}</span>
<span style="color: #800000; font-weight: normal;">\RequirePackage</span><span style="color: #E02020; ">[</span><span style="color: #C08020; font-weight: normal;">utf8</span>]{inputenc</span><span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #E02020; ">\</span><span style="color: #800000;">KOMAoptions</span><span style="color: #E02020; ">{</span>
foldmarks=true,
foldmarks=BlmTP,
<span style="color: #2C922C; font-style: italic;">%fromurl=true,</span>
fromemail=true,
fromphone=true,
fromalign=right,
fromrule=aftername,
fromemail=true,
footsepline=off
<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #2C922C; font-style: italic;">% define gray for header</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">definecolor</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;">firstnamecolor<span style="color: #E02020; ">}{</span>rgb<span style="color: #E02020; ">}{</span>0.65,0.65,0.65<span style="color: #E02020; ">}</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">definecolor</span><span style="color: #E02020; ">{</span>familynamecolor<span style="color: #E02020; ">}{</span>rgb<span style="color: #E02020; ">}{</span>0.45,0.45,0.45<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\setkomavar</span><span style="color: #E02020; ">{</span>fromname<span style="color: #E02020; ">}{\</span><span style="color: #800000;">color</span><span style="color: #E02020; ">{</span>firstnamecolor<span style="color: #E02020; ">}</span>Michael<span style="color: #E02020; ">\</span><span style="color: #800000;">color</span><span style="color: #E02020; ">{</span>familynamecolor<span style="color: #E02020; ">}</span>Rennecke<span style="color: #E02020; ">}</span>
<span style="color: #800000; font-weight: normal;">\setkomafont</span><span style="color: #E02020; ">{</span>fromname<span style="color: #E02020; ">}{</span><span style="color: #800000; font-weight: normal;">\fontsize</span><span style="color: #E02020; ">{</span>38<span style="color: #E02020; ">}{</span>40<span style="color: #E02020; ">}\</span><span style="color: #800000;">sffamily</span><span style="color: #800000; font-weight: normal;">\mdseries</span><span style="color: #800000; font-weight: normal;">\upshape</span><span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\setkomafont</span><span style="color: #E02020; ">{</span>fromrule<span style="color: #E02020; ">}{\</span><span style="color: #800000;">color</span><span style="color: #E02020; ">{</span>firstnamecolor<span style="color: #E02020; ">}}</span>
<span style="color: #E00000; font-weight: normal;">\@setplength</span><span style="color: #E02020; ">{</span>fromrulethickness<span style="color: #E02020; ">}{</span>0.25ex<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\setkomafont</span><span style="color: #E02020; ">{</span>addressee<span style="color: #E02020; ">}{</span><span style="color: #800000; font-weight: normal;">\small</span><span style="color: #E02020; ">}</span>
<span style="color: #800000; font-weight: normal;">\setkomavar</span><span style="color: #E02020; ">{</span>fromaddress<span style="color: #E02020; ">}{</span>Solarisgasse 2<span style="color: #E02020; ">\\</span>12345 Tuxhausen<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\newkomavar</span><span style="color: #E02020; ">[</span><span style="color: #C08020; font-weight: normal;"><span style="color: #800000; font-weight: normal;">\Mobilefone</span></span><span style="color: #E02020; ">]{</span>frommobilephone<span style="color: #E02020; ">}</span> 
<span style="color: #800000; font-weight: normal;">\setkomavar</span><span style="color: #E02020; ">{</span>frommobilephone<span style="color: #E02020; ">}{</span>(01<span style="color: #E02020; ">\</span>,60)~1<span style="color: #E02020; ">\</span>,00<span style="color: #E02020; ">\</span>,00<span style="color: #E02020; ">\</span>,00<span style="color: #E02020; ">}</span>
<span style="color: #800000; font-weight: normal;">\setkomavar</span><span style="color: #E02020; ">{</span>fromphone<span style="color: #E02020; ">}[</span><span style="color: #C08020; font-weight: normal;"><span style="color: #800000; font-weight: normal;">\Telefon</span></span><span style="color: #E02020; ">]{</span>(03<span style="color: #E02020; ">\</span>,45)~000<span style="color: #E02020; ">\</span>,00<span style="color: #E02020; ">\</span>,00<span style="color: #E02020; ">\</span>,00<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\setkomavar</span><span style="color: #E02020; ">{</span>fromemail<span style="color: #E02020; ">}[</span><span style="color: #C08020; font-weight: normal;"><span style="color: #800000; font-weight: normal;">\Letter</span></span><span style="color: #E02020; ">]{</span>michael<span style="color: #800000; font-weight: normal;">\_</span>rennecke@gmx.net</span><span style="color: #E02020; ">}</span>
<span style="color: #2C922C; font-style: italic;">%\setkomavar{fromurl}[]{http://0rpheus.net}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\firsthead</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;">
  <span style="color: #800000; font-weight: normal;">\noindent</span>
  <span style="color: #E02020; ">\</span><span style="color: #800000;">parbox</span><span style="color: #E02020; ">[</span><span style="color: #C08020; font-weight: normal;">b</span><span style="color: #E02020; ">]{</span><span style="color: #800000; font-weight: normal;">\useplength</span>{firstheadwidth}</span><span style="color: #E02020; ">}{</span>
    <span style="color: #800000; font-weight: normal;">\noindent</span><span style="color: #2C922C; font-style: italic;">%</span>
    <span style="color: #E02020; ">\</span><span style="color: #800000;">raggedleft</span><span style="color: #2C922C; font-style: italic;">%</span>
    <span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;"><span style="color: #800000; font-weight: normal;">\usekomafont</span><span style="color: #E02020; ">{</span>fromname<span style="color: #E02020; ">}</span><span style="color: #800000; font-weight: normal;">\usekomavar</span><span style="color: #E02020; ">{</span>fromname<span style="color: #E02020; ">}}\\</span>
    <span style="color: #E02020; ">\</span><span style="color: #800000;">rule</span><span style="color: #E02020; ">{</span><span style="color: #800000; font-weight: normal;">\useplength</span><span style="color: #E02020; ">{</span>firstheadwidth<span style="color: #E02020; ">}}{</span>1pt<span style="color: #E02020; ">}\\</span>
    <span style="color: #800000; font-weight: normal;">\usekomavar</span><span style="color: #E02020; ">{</span>fromaddress<span style="color: #E02020; ">}\\</span>
    <span style="color: #800000; font-weight: normal;">\Telefon</span><span style="color: #800000; font-weight: normal;">\enskip</span><span style="color: #800000; font-weight: normal;">\usekomavar</span><span style="color: #E02020; ">{</span>fromphone<span style="color: #E02020; ">}\\</span>
    <span style="color: #800000; font-weight: normal;">\Mobilefone</span><span style="color: #800000; font-weight: normal;">\enskip</span><span style="color: #800000; font-weight: normal;">\usekomavar</span><span style="color: #E02020; ">{</span>frommobilephone<span style="color: #E02020; ">}\\</span>
    <span style="color: #800000; font-weight: normal;">\Letter</span><span style="color: #800000; font-weight: normal;">\enskip</span><span style="color: #800000; font-weight: normal;">\usekomavar</span><span style="color: #E02020; ">{</span>fromemail<span style="color: #E02020; ">}</span>
  <span style="color: #E02020; ">}</span>
<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\setkomafont</span><span style="color: #E02020; ">{</span>fromaddress<span style="color: #E02020; ">}{</span><span style="color: #800000; font-weight: normal;">\small</span><span style="color: #800000; font-weight: normal;">\rmfamily</span><span style="color: #800000; font-weight: normal;">\mdseries</span><span style="color: #800000; font-weight: normal;">\slshape</span><span style="color: #E02020; ">}</span>
<span style="color: #800000; font-weight: normal;">\setkomavar</span><span style="color: #E02020; ">{</span>backaddress<span style="color: #E02020; ">}{</span>Michael Rennecke, Große Schlossgasse 2, 06108 Halle (Saale)<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\setkomavar</span>{signature}{Michael Rennecke</span><span style="color: #E02020; ">}</span>
<span style="color: #2C922C; font-style: italic;">% signature same indention level as rest</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">renewcommand</span>*<span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;"><span style="color: #800000; font-weight: normal;">\raggedsignature</span><span style="color: #E02020; ">}{\</span><span style="color: #800000;">raggedright</span></span><span style="color: #E02020; ">}</span>
<span style="color: #2C922C; font-style: italic;">% space for signature</span>
<span style="color: #E00000; font-weight: normal;">\@setplength</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;">sigbeforevskip}{1.7cm</span><span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\endinput</span></pre>
      </td>
    </tr>
  </table>
</div>

So sieht nun ein Beipieldokument aus: 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="latex" style="font-family:monospace;"><span style="color: #E02020; ">\</span><span style="color: #800000;">documentclass</span><span style="color: #E02020; ">[</span><span style="color: #C08020; font-weight: normal;">letter_options,parskip=half+,version=last,fontsize=11pt,DIV=11,BCOR=10mm, DIN</span><span style="color: #E02020; ">]{</span><span style="color: #2020C0; font-weight: normal;">scrlttr2<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #E02020; ">\</span><span style="color: #800000;">usepackage</span><span style="color: #E02020; ">[</span><span style="color: #C08020; font-weight: normal;">utf8</span><span style="color: #E02020; ">]{</span>inputenc<span style="color: #E02020; ">}</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">usepackage</span><span style="color: #E02020; ">[</span><span style="color: #C08020; font-weight: normal;">T1</span><span style="color: #E02020; ">]{</span>fontenc<span style="color: #E02020; ">}</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">usepackage</span><span style="color: #E02020; ">[</span><span style="color: #C08020; font-weight: normal;">english,ngerman</span><span style="color: #E02020; ">]{</span>babel<span style="color: #E02020; ">}</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">usepackage</span><span style="color: #E02020; ">{</span>amssymb<span style="color: #E02020; ">}</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">usepackage</span>{lmodern</span><span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #2C922C; font-style: italic;">% overall sans serif font</span>
<span style="color: #E02020; ">\</span><span style="color: #800000;">renewcommand</span><span style="color: #E02020; ">{</span><span style="color: #2020C0; font-weight: normal;"><span style="color: #800000; font-weight: normal;">\familydefault</span><span style="color: #E02020; ">}{</span><span style="color: #800000; font-weight: normal;">\sfdefault</span><span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #800000; font-weight: normal;">\setkomavar</span><span style="color: #E02020; ">{</span>subject<span style="color: #E02020; ">}{</span>Was machst Du<span style="color: #E02020; ">}</span>
<span style="color: #800000; font-weight: normal;">\setkomavar</span><span style="color: #E02020; ">{</span>place<span style="color: #E02020; ">}{</span>Halle (Saale)<span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #C00000; font-weight: normal;">\begin</span><span style="color: #E02020; ">{</span><span style="color: #0000D0; font-weight: normal;">document</span><span style="color: #E02020; ">}</span>
<span style="color: #C00000; font-weight: normal;">\begin</span><span style="color: #E02020; ">{</span><span style="color: #0000D0; font-weight: normal;">letter</span><span style="color: #E02020; ">}{</span>Karl Mustermann<span style="color: #E02020; ">\\</span> Straße 4<span style="color: #E02020; ">\\</span> 06019 Halle (Saale)<span style="color: #E02020; ">}</span>
&nbsp;
&nbsp;
<span style="color: #800000; font-weight: normal;">\opening</span><span style="color: #E02020; ">{</span>Sehr geehrte Damen und Herren,<span style="color: #E02020; ">}</span>
  blabla
&nbsp;
  <span style="color: #800000; font-weight: normal;">\closing</span><span style="color: #E02020; ">{</span>Mit freundlichem Gruß<span style="color: #E02020; ">}</span>
<span style="color: #C00000; font-weight: normal;">\end</span><span style="color: #E02020; ">{</span><span style="color: #0000D0; font-weight: normal;">letter</span><span style="color: #E02020; ">}</span>
&nbsp;
<span style="color: #C00000; font-weight: normal;">\end</span><span style="color: #E02020; ">{</span><span style="color: #0000D0; font-weight: normal;">document</span></span><span style="color: #E02020; ">}</span></pre>
      </td>
    </tr>
  </table>
</div>

Ich hoffe ich konnte allen helfen, die ein ähnliches Problem haben. Ich bin für Anmerkungen dankbar, die meine Vorlage noch verbessern 😉 Wie das aussieht kann man [hier][3] sehen

 [1]: http://developer.berlios.de/projects/koma-script3/
 [2]: http://meet-unix.org/
 [3]: /uploads/test.pdf