---
title: Sensoren mit Nagios abfragen
author: Michael Rennecke
type: post
date: 2009-09-09T22:24:56+00:00
categories:
  - Solaris
tags:
  - nagios
  - Solaris
  - Sparc

---
Ich wollte verschiedene Sparc-Rechner mit [Nagios][1] überwachen. Da ich kein passendes Plugin gefunden habe um die Sensoren zu überwachen habe ich mir selbst eins geschrieben.

Es funktioniert ganz gut, wenn jemand Probleme mit dem Plugin hat, dann kann ich versuchen es zu verbessern. Man kann das [Plugin auch hier][2] herunter laden. Ich parse die Ausgabe von <tt>prtpicl</tt>. Wenn die Temperatur **HighWarningThreshold $warn** übersteigt, dann wird warning zurück gegeben. Wenn **HighWarningThreshold** überschritten wird, dann gibt das Plugin critical zurück.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="perl" style="font-family:monospace;"><span style="color: #666666; font-style: italic;">#!/usr/bin/perl -w</span>
&nbsp;
<span style="color: #666666; font-style: italic;"># File:    check_solaris_sensors</span>
<span style="color: #666666; font-style: italic;"># Purpose: prtpicl output parser</span>
<span style="color: #666666; font-style: italic;"># Author:  Michael Rennecke michael.rennecke@sun.com</span>
<span style="color: #666666; font-style: italic;"># Date:    2009/07/08</span>
<span style="color: #666666; font-style: italic;"># Version: 0.2</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">use</span> strict<span style="color: #339933;">;</span>
&nbsp;
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$warn</span>        <span style="color: #339933;">=</span> <span style="color: #cc66cc;">15</span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$prtpicl</span>     <span style="color: #339933;">=</span> <span style="color: #ff0000;">"/usr/sbin/prtpicl"</span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">@diag</span>        <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">@sensor_data</span> <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$state</span>       <span style="color: #339933;">=</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$output</span>      <span style="color: #339933;">=</span> <span style="color: #ff0000;">""</span><span style="color: #339933;">;</span>
&nbsp;
<span style="color: #b1b100;">unless</span><span style="color: #009900;">&#40;</span><span style="color: #000066;">open</span><span style="color: #009900;">&#40;</span>DIAG<span style="color: #339933;">,</span> <span style="color: #ff0000;">"$prtpicl -v -c temperature-sensor | "</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
    <span style="color: #000066;">print</span> <span style="color: #000000; font-weight: bold;">STDERR</span> <span style="color: #ff0000;">"Initialization error - Can't execute  $prtpicl -v -c temperature-sensor!<span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
    <span style="color: #000066;">exit</span><span style="color: #009900;">&#40;</span><span style="color: #cc66cc;">3</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #b1b100;">while</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#123;</span>
    <span style="color: #000066;">push</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">@diag</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">$_</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span>
<span style="color: #000066;">close</span><span style="color: #009900;">&#40;</span>DIAG<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
<span style="color: #b1b100;">unless</span><span style="color: #009900;">&#40;</span> <span style="color: #0000ff;">@diag</span> <span style="color: #339933;">&</span><span style="color: #b1b100;">gt</span><span style="color: #339933;">;</span> <span style="color: #cc66cc;"></span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
    <span style="color: #000066;">print</span> <span style="color: #000000; font-weight: bold;">STDERR</span> <span style="color: #ff0000;">"Can't find any temperature-sensor!<span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
    <span style="color: #000066;">exit</span><span style="color: #009900;">&#40;</span><span style="color: #cc66cc;">3</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">sub</span> change_state <span style="color: #009900;">&#123;</span>
    <span style="color: #b1b100;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$_</span><span style="color: #009900;">&#91;</span><span style="color: #cc66cc;"></span><span style="color: #009900;">&#93;</span> <span style="color: #339933;">&</span><span style="color: #b1b100;">gt</span><span style="color: #339933;">;</span> <span style="color: #0000ff;">$state</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #0000ff;">$state</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">$_</span><span style="color: #009900;">&#91;</span><span style="color: #cc66cc;"></span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$sensor</span>      <span style="color: #339933;">=</span> <span style="color: #000066;">undef</span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$warning</span>     <span style="color: #339933;">=</span> <span style="color: #000066;">undef</span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$critical</span>    <span style="color: #339933;">=</span> <span style="color: #000066;">undef</span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$temperature</span> <span style="color: #339933;">=</span> <span style="color: #000066;">undef</span><span style="color: #339933;">;</span>
<span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$get_temp</span>    <span style="color: #339933;">=</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">;</span>
&nbsp;
<span style="color: #b1b100;">foreach</span> <span style="color: #b1b100;">my</span> <span style="color: #0000ff;">$line</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">@diag</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
&nbsp;
    <span style="color: #0000ff;">$get_temp</span> <span style="color: #339933;">=</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #b1b100;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$line</span> <span style="color: #339933;">=~</span> <span style="color: #009966; font-style: italic;">/\s*([a-zA-Z0-9_]+)\s*\(temperature-sensor/</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #0000ff;">$sensor</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">$1</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span> <span style="color: #b1b100;">elsif</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$line</span> <span style="color: #339933;">=~</span> <span style="color: #009966; font-style: italic;">/:HighWarningThreshold\s*(\d+)/</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #0000ff;">$warning</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">$1</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span> <span style="color: #b1b100;">elsif</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$line</span> <span style="color: #339933;">=~</span> <span style="color: #009966; font-style: italic;">/:Temperature\s*(\d+)/</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #0000ff;">$temperature</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">$1</span><span style="color: #339933;">;</span>
        <span style="color: #0000ff;">$get_temp</span> <span style="color: #339933;">=</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
&nbsp;
    <span style="color: #b1b100;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$get_temp</span> <span style="color: #339933;">==</span> <span style="color: #cc66cc;">1</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #b1b100;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$temperature</span> <span style="color: #339933;">&</span><span style="color: #b1b100;">lt</span><span style="color: #339933;">;=</span> <span style="color: #0000ff;">$warning</span> <span style="color: #339933;">-</span> <span style="color: #0000ff;">$warn</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #0000ff;">&amp</span><span style="color: #339933;">;</span>change_state<span style="color: #009900;">&#40;</span><span style="color: #cc66cc;"></span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span> <span style="color: #b1b100;">elsif</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$temperature</span> <span style="color: #339933;">&</span><span style="color: #b1b100;">lt</span><span style="color: #339933;">;=</span> <span style="color: #0000ff;">$warning</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #0000ff;">&amp</span><span style="color: #339933;">;</span>change_state<span style="color: #009900;">&#40;</span><span style="color: #cc66cc;">1</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span> <span style="color: #b1b100;">else</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #0000ff;">&amp</span><span style="color: #339933;">;</span>change_state<span style="color: #009900;">&#40;</span><span style="color: #cc66cc;">2</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span>
    <span style="color: #0000ff;">$output</span> <span style="color: #339933;">=</span> <span style="color: #ff0000;">"$output $sensor: ${temperature}°C "</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #b1b100;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$state</span> <span style="color: #339933;">==</span> <span style="color: #cc66cc;"></span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
    <span style="color: #0000ff;">$output</span> <span style="color: #339933;">=</span> <span style="color: #ff0000;">"Temperature OK --$output <span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span> <span style="color: #b1b100;">elsif</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$state</span> <span style="color: #339933;">==</span> <span style="color: #cc66cc;">1</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
    <span style="color: #0000ff;">$output</span> <span style="color: #339933;">=</span> <span style="color: #ff0000;">"Temperature WARNING --$output <span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span> <span style="color: #b1b100;">elsif</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$state</span> <span style="color: #339933;">==</span> <span style="color: #cc66cc;">2</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
    <span style="color: #0000ff;">$output</span> <span style="color: #339933;">=</span> <span style="color: #ff0000;">"Temperature CRITICAL --$output <span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span> <span style="color: #b1b100;">else</span> <span style="color: #009900;">&#123;</span>
    <span style="color: #0000ff;">$output</span> <span style="color: #339933;">=</span> <span style="color: #ff0000;">"Temperature UNKNOWN --$output <span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #000066;">print</span> <span style="color: #000000; font-weight: bold;">STDOUT</span> <span style="color: #ff0000;">"$output"</span><span style="color: #339933;">;</span>
<span style="color: #000066;">exit</span> <span style="color: #009900;">&#40;</span><span style="color: #0000ff;">$state</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
      </td>
    </tr>
  </table>
</div>

 [1]: http://www.nagios.org/
 [2]: http://blogs.sun.com/rennecke/resource/stuff/check_solaris_sensors