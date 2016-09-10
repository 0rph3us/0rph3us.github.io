---
title: “Sichere” Captchas programmieren
author: Michael Rennecke
type: post
date: 2010-08-18T12:34:59+00:00
excerpt: |
  <p>
  Man möchte manchmal Teile seiner Seite mittels Captchas schützen. Es gibt zahlreiche fertige Varianten, auch für wordpress. Diese haben fast immer den Nachteil, dass sie <a href="http://de.wikipedia.org/wiki/JavaScript">JavaScript</a>, <a href="http://www.adobe.com/support/documentation/de/flash/">Flash</a>, oder <a href="http://www.w3.org/TR/WD-session-id">Sessions</a> benutzen. Persönlich habe ich eine Abneigung gegen <a href="http://de.wikipedia.org/wiki/JavaScript">JavaScript</a> und <a href="http://www.adobe.com/support/documentation/de/flash/">Flash</a>. <a href="http://www.w3.org/TR/WD-session-id">Sessions</a> lassen sich nicht immer nachträglich nutzen und man erzeugt serverseitig etwas Last. Fakt ist, dass ich keine Sessions mag! Das schlimmste an fertigen Captcha-Lösungen ist der zum Teil invalide html-Code. Ich möchte validen <a href="http://www.w3.org/TR/xhtml1/">xhtml 1.0 strict</a>-Code haben und das Captcha sollte in mein Design passen. Wenn man die ganzen Anforderungen erfüllt haben möchte, so muss man wohl oder übel sein Captcha selbst programmieren.
  </p>
wp_jd_wp:
  - http://0rpheus.net/?p=3682
wp_jd_target:
  - http://0rpheus.net/?p=3682
jd_wp_twitter:
  - ' Post Edited: "Sichere" Captchas programmieren http://0rpheus.net/?p=3682'
categories:
  - Programmieren
  - sonstiges
  - Tools
tags:
  - captcha
  - hack
  - php
  - Security
  - xhtml

---
Man möchte manchmal Teile seiner Seite mittels Captchas schützen. Es gibt zahlreiche fertige Varianten, auch für wordpress. Diese haben fast immer den Nachteil, dass sie [JavaScript][1], [Flash][2], oder [Sessions][3] benutzen. Persönlich habe ich eine Abneigung gegen [JavaScript][1] und [Flash][2]. [Sessions][3] lassen sich nicht immer nachträglich nutzen und man erzeugt serverseitig etwas Last. Fakt ist, dass ich keine Sessions mag! Das schlimmste an fertigen Captcha-Lösungen ist der zum Teil invalide html-Code. Ich möchte validen [xhtml 1.0 strict][4]-Code haben und das Captcha sollte in mein Design passen. Wenn man die ganzen Anforderungen erfüllt haben möchte, so muss man wohl oder übel sein Captcha selbst programmieren. 

## Wie komme ich zum sicheren Captcha

Wenn ich auf Sessions verzichten möchte, so muss ich die Lösung des Captcha mit auf die Seite schreiben. Das kann man in einen _nicht sichtbaren_ Feld machen. Damit man dieses Feld nicht so einfach auslesen kann, schreibt man einen [Hash][5] hinein bzw. man verschlüsselt den Inhalt. 

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
</pre>
      </td>
      
      <td class="code">
        <pre class="php" style="font-family:monospace;"><span style="color: #990000;">define</span><span style="color: #009900;">&#40;</span><span style="color: #990000;">KEY</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">"Ich bin ein Key"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #990000;">define</span><span style="color: #009900;">&#40;</span>IV<span style="color: #339933;">,</span> <span style="color: #0000ff;">"KlyV6gxG3MOPzlfuj8azF6sKKTnsdsiN58i0zjHA0EU="</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">function</span> <span style="color: #990000;">Crypt</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$plaintext</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#123;</span>
    <span style="color: #000088;">$td</span> <span style="color: #339933;">=</span> <span style="color: #990000;">mcrypt_module_open</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">'rijndael-256'</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">''</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">'ofb'</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">''</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #000088;">$iv</span> <span style="color: #339933;">=</span> <span style="color: #990000;">base64_decode</span><span style="color: #009900;">&#40;</span>IV<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$ks</span> <span style="color: #339933;">=</span> <span style="color: #990000;">mcrypt_enc_get_key_size</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
     <span style="color: #666666; font-style: italic;">/* Create key */</span>
    <span style="color: #000088;">$key</span> <span style="color: #339933;">=</span> <span style="color: #990000;">substr</span><span style="color: #009900;">&#40;</span><span style="color: #990000;">md5</span><span style="color: #009900;">&#40;</span><span style="color: #990000;">KEY</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">,</span> <span style="color: #000088;">$ks</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #666666; font-style: italic;">/* Intialize encryption */</span>
    <span style="color: #990000;">mcrypt_generic_init</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #339933;">,</span> <span style="color: #000088;">$key</span><span style="color: #339933;">,</span> <span style="color: #000088;">$iv</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #666666; font-style: italic;">/* Encrypt data */</span>
    <span style="color: #000088;">$encrypted</span> <span style="color: #339933;">=</span> <span style="color: #990000;">mcrypt_generic</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #339933;">,</span> <span style="color: #000088;">$plaintext</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #666666; font-style: italic;">/* Terminate decryption handle and close module */</span>
    <span style="color: #990000;">mcrypt_generic_deinit</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #990000;">mcrypt_module_close</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #b1b100;">return</span> <span style="color: #990000;">base64_encode</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$encrypted</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">function</span> Decrypt<span style="color: #009900;">&#40;</span><span style="color: #000088;">$chiffre</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#123;</span>
    <span style="color: #000088;">$td</span> <span style="color: #339933;">=</span> <span style="color: #990000;">mcrypt_module_open</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">'rijndael-256'</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">''</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">'ofb'</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">''</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #000088;">$iv</span> <span style="color: #339933;">=</span> <span style="color: #990000;">base64_decode</span><span style="color: #009900;">&#40;</span>IV<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$ks</span> <span style="color: #339933;">=</span> <span style="color: #990000;">mcrypt_enc_get_key_size</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
     <span style="color: #666666; font-style: italic;">/* Create key */</span>
    <span style="color: #000088;">$key</span> <span style="color: #339933;">=</span> <span style="color: #990000;">substr</span><span style="color: #009900;">&#40;</span><span style="color: #990000;">md5</span><span style="color: #009900;">&#40;</span><span style="color: #990000;">KEY</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">,</span> <span style="color: #000088;">$ks</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #000088;">$chiffre</span> <span style="color: #339933;">=</span> <span style="color: #990000;">base64_decode</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$chiffre</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #990000;">mcrypt_generic_init</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #339933;">,</span> <span style="color: #000088;">$key</span><span style="color: #339933;">,</span> <span style="color: #000088;">$iv</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$plaintext</span> <span style="color: #339933;">=</span> <span style="color: #990000;">mdecrypt_generic</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #339933;">,</span> <span style="color: #000088;">$chiffre</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #990000;">mcrypt_generic_deinit</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #990000;">mcrypt_module_close</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$td</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #b1b100;">return</span> <span style="color: #000088;">$plaintext</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">function</span> draw_captcha_form<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#123;</span>
    <span style="color: #339933;">.....</span>
    <span style="color: #000088;">$time</span> <span style="color: #339933;">=</span> <span style="color: #990000;">time</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #339933;">+</span> <span style="color: #cc66cc;">60</span><span style="color: #339933;">*</span><span style="color: #cc66cc;">30</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$captchaSolution</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">"Test"</span>
    <span style="color: #b1b100;">echo</span> <span style="color: #0000ff;">"<span style="color: #000099; font-weight: bold;">\t</span><span style="color: #000099; font-weight: bold;">\n</span><span style="color: #000099; font-weight: bold;">\t</span>Bitte Captcha lösen&lt;br/&gt;<span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
    <span style="color: #666666; font-style: italic;">// erzeuge ein Captcha</span>
    <span style="color: #b1b100;">echo</span> <span style="color: #0000ff;">"<span style="color: #000099; font-weight: bold;">\t</span><span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
    <span style="color: #b1b100;">echo</span> <span style="color: #0000ff;">"<span style="color: #000099; font-weight: bold;">\t</span>"</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">'
&lt;input name="captvalue" id="captvalue" value="" size="40" tabindex="4" type="text"/&gt;'</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">"<span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
    <span style="color: #b1b100;">echo</span> <span style="color: #0000ff;">"<span style="color: #000099; font-weight: bold;">\t</span>"</span>    <span style="color: #339933;">.</span> <span style="color: #0000ff;">'
&lt;input name="captcha" value="'</span><span style="color: #339933;">.</span> <span style="color: #990000;">Crypt</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$time</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">"~"</span> <span style="color: #339933;">.</span> <span style="color: #000088;">$captchaSolution</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">"~"</span> <span style="color: #339933;">.</span> <span style="color: #000088;">$REMOTE_ADDR</span><span style="color: #009900;">&#41;</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">'" type="hidden"/&gt;'</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">"<span style="color: #000099; font-weight: bold;">\n</span>"</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">function</span> check_post<span style="color: #009900;">&#40;</span>$<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
    <span style="color: #339933;">....</span>
    <span style="color: #000088;">$captcha</span> <span style="color: #339933;">=</span> <span style="color: #000088;">$_POST</span><span style="color: #009900;">&#91;</span><span style="color: #0000ff;">'captvalue'</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
    <span style="color: #990000;">list</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$timeOld</span><span style="color: #339933;">,</span> <span style="color: #000088;">$secret</span><span style="color: #339933;">,</span> <span style="color: #000088;">$addr</span><span style="color: #009900;">&#41;</span> <span style="color: #339933;">=</span> <span style="color: #990000;">explode</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">'~'</span><span style="color: #339933;">,</span>Decrypt<span style="color: #009900;">&#40;</span><span style="color: #000088;">$_POST</span><span style="color: #009900;">&#91;</span><span style="color: #0000ff;">'captcha'</span><span style="color: #009900;">&#93;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #339933;">....</span>
    <span style="color: #b1b100;">if</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$timeOld</span> <span style="color: #339933;">&lt;=</span> <span style="color: #990000;">time</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#123;</span>
            <span style="color: #b1b100;">echo</span> <span style="color: #0000ff;">"Deine Zeit ist abgelaufen"</span><span style="color: #339933;">;</span>
            <span style="color: #b1b100;">return</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
    <span style="color: #b1b100;">if</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$addr</span> <span style="color: #339933;">!=</span> <span style="color: #000088;">$REMOTE_ADDR</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#123;</span>
            <span style="color: #b1b100;">echo</span> <span style="color: #0000ff;">"Falsche IP"</span><span style="color: #339933;">;</span>
            <span style="color: #b1b100;">return</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
    <span style="color: #b1b100;">if</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$secret</span> <span style="color: #339933;">!=</span> <span style="color: #000088;">$captcha</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#123;</span>
            <span style="color: #b1b100;">echo</span> <span style="color: #0000ff;">"Falsches Captcha"</span><span style="color: #339933;">;</span>
            <span style="color: #b1b100;">return</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
    <span style="color: #339933;">.....</span>
<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Mit diesen Ideen kann man sich nun sein eigenes Captcha zusammen bauen. Ich generiere z.B. Matheaufgaben.

 [1]: http://de.wikipedia.org/wiki/JavaScript
 [2]: http://www.adobe.com/support/documentation/de/flash/
 [3]: http://www.w3.org/TR/WD-session-id
 [4]: http://www.w3.org/TR/xhtml1/
 [5]: http://burtleburtle.net/bob/hash/index.html