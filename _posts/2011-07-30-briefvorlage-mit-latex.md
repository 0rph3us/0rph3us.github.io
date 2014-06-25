---
layout: post
title: Briefvorlage mit LaTeX
categories:
- privat
- Programmieren
- sonstiges
tags:
- Brief
- latex
- Mobil
- Telefon
status: publish
type: post
published: true
meta:
  _jd_post_meta_fixed: 'true'
  _jd_wp_twitter: ''
  _wp_jd_target: ''
  _wp_jd_url: ''
  _wp_jd_yourls: ''
  _wp_jd_wp: ''
  _wp_jd_bitly: ''
  _wp_jd_clig: ''
  _jd_twitter: ''
  _jd_tweet_this: 'yes'
  _edit_last: '2'
author:
  login: rennecke
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
---

Ich bin vor kurzem umgezogen und bin inzwischen Besitzer eines Festnetztelefon. 
Aus diesem Grund wollte ich in meiner $$ \LaTeX $$-Vorlage für meine Briefe beide Nummern stehen haben. 
Die [KOMA-Skript](http://developer.berlios.de/projects/koma-script3/) Pakete können von Haus aus, nur eine 
Telefonnummer, deswegen habe ich meine Vorlage, welche ich von [meet-unix](http://meet-unix.org/) habe, wie folgt angepasst.

{% highlight latex %}
\ProvidesFile{letter_options.lco}[letter-class-option file]

% symbols: (cell)phone, email
\RequirePackage{marvosym}
% for gray color in header
\RequirePackage{color}
\RequirePackage[utf8]{inputenc}

\KOMAoptions{
foldmarks=true,
foldmarks=BlmTP,
%fromurl=true,
fromemail=true,
fromphone=true,
fromalign=right,
fromrule=aftername,
fromemail=true,
footsepline=off
}

% define gray for header
\definecolor{firstnamecolor}{rgb}{0.65,0.65,0.65}
\definecolor{familynamecolor}{rgb}{0.45,0.45,0.45}

\setkomavar{fromname}{\color{firstnamecolor}Michael\color{familynamecolor}Rennecke}
\setkomafont{fromname}{\fontsize{38}{40}\sffamily\mdseries\upshape}

\setkomafont{fromrule}{\color{firstnamecolor}}
\@setplength{fromrulethickness}{0.25ex}

\setkomafont{addressee}{\small}
\setkomavar{fromaddress}{Solarisgasse 2\12345 Tuxhausen}

\newkomavar[\Mobilefone]{frommobilephone} 
\setkomavar{frommobilephone}{(01\,60)~1\,00\,00\,00}
\setkomavar{fromphone}[\Telefon]{(03\,45)~000\,00\,00\,00}

\setkomavar{fromemail}[\Letter]{michael\_rennecke@gmx.net}
%\setkomavar{fromurl}[]{http://0rpheus.net}

\firsthead{
  \noindent
  \parbox[b]{\useplength{firstheadwidth}}{
    \noindent%
    \raggedleft%
    {\usekomafont{fromname}\usekomavar{fromname}}\
    \rule{\useplength{firstheadwidth}}{1pt}\
    \usekomavar{fromaddress}\
    \Telefon\enskip\usekomavar{fromphone}\
    \Mobilefone\enskip\usekomavar{frommobilephone}\
    \Letter\enskip\usekomavar{fromemail}
  }
}

\setkomafont{fromaddress}{\small\rmfamily\mdseries\slshape}
\setkomavar{backaddress}{Michael Rennecke, Tuxgasse 5, 06121 Halle (Saale)}
 
\setkomavar{signature}{Michael Rennecke
% signature same indention level as rest
\renewcommand*{\raggedsignature}{\raggedright}
% space for signature
\@setplength{sigbeforevskip}{1.7cm}

\endinput
{% endhighlight %}


## Beipieldokument

{% highlight latex %}
\documentclass[letter_options,parskip=half+,version=last,fontsize=11pt,DIV=11,BCOR=10mm, DIN]{scrlttr2}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[english,ngerman]{babel}
\usepackage{amssymb}
\usepackage{lmodern}

% overall sans serif font
\renewcommand{\familydefault}{\sfdefault}

\setkomavar{subject}{Was machst Du}
\setkomavar{place}{Halle (Saale)}

\begin{document}
\begin{letter}{Karl Mustermann\ Straße 4\ 06019 Halle (Saale)}


\opening{Sehr geehrte Damen und Herren,}
  blabla

  \closing{Mit freundlichem Gruß}
\end{letter}

\end{document}
{% endhighlight %}


Ich hoffe ich konnte allen helfen, die ein ähnliches Problem haben. Ich bin für Anmerkungen dankbar, 
die meine Vorlage noch verbessern ;-) Wie das aussieht kann man <a href="/uploads/test.pdf">hier</a> sehen.
