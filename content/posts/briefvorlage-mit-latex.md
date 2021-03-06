---
title: Briefvorlage mit LaTeX
author: Michael Rennecke
type: post
date: 2011-07-30T19:26:59+00:00
categories:
  - privat
  - programmieren
  - sonstiges
tags:
  - Brief
  - latex
  - Mobil
  - Telefon

---
Ich bin vor kurzem umgezogen und bin inzwischen Besitzer eines Festnetztelefons. Aus diesem Grund wollte ich in meiner LaTeX-Vorlage
für meine Briefe beide Nummern stehen haben. Die [KOMA-Skript][1] Pakte können von Haus aus nur eine Telefonnummer, deswegen
habe ich meine Vorlage, welche ich von [meet-unix][2] habe, wie folgt angepasst.

``` tex
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
\setkomavar{fromaddress}{Solarisgasse 2\\12345 Tuxhausen}

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
    {\usekomafont{fromname}\usekomavar{fromname}}\\
    \rule{\useplength{firstheadwidth}}{1pt}\\
    \usekomavar{fromaddress}\\
    \Telefon\enskip\usekomavar{fromphone}\\
    \Mobilefone\enskip\usekomavar{frommobilephone}\\
    \Letter\enskip\usekomavar{fromemail}
  }
}

\setkomafont{fromaddress}{\small\rmfamily\mdseries\slshape}
\setkomavar{backaddress}{Michael Rennecke, Große Schlossgasse 2, 06108 Halle (Saale)}

\setkomavar{signature}{Michael Rennecke}
% signature same indention level as rest
\renewcommand*{\raggedsignature}{\raggedright}
% space for signature
\@setplength{sigbeforevskip}{1.7cm}

\endinput
```

So sieht nun ein Beipieldokument aus:

``` tex
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
\begin{letter}{Karl Mustermann\\ Straße 4\\ 06019 Halle (Saale)}


\opening{Sehr geehrte Damen und Herren,}
  blabla

  \closing{Mit freundlichem Gruß}
\end{letter}

\end{document}
```

Ich hoffe ich konnte allen helfen, die ein ähnliches Problem haben. Ich bin für Anmerkungen dankbar, die meine Vorlage noch verbessern 😉

 [1]: http://developer.berlios.de/projects/koma-script3/
 [2]: http://meet-unix.org/
