---
type: post
title: Optischer Randausgleich
date: 2010-09-03
categories:
 - LaTeX
 - Tools
tags:
 - blocksatz
 - optischer Randausgleich
 - Word
---
Ich schreibe meine Diplomarbeit mit LaTeX. Da bekommt man auch einen schönen Blocksatz hin. Der Blocksatz wird auf dem gesamten Absatz,
unter beachtung möglicher Worttrennungen  berechnet. Deswegen sieht der Blocksatz besser aus als mit Word. Man kann den Blocksatz noch
verbessern, indem man den _optischen Randausgleich_ nutzt. Das funktioniert wie normaler Blocksatz, mit dem unterschied, dass der Grauwert
des linken Rand gleich ist. Ein Bindestrich ragt z.B. mehr in Rand hinein als ein m. da ein Bindestrich weniger schwarz enthält als ein m.
Für das Auge sieht der linke  Rand nun gerade aus. Man muss dafür nur das Package  __microtype__ einbinden. 
[Hier](http://www.ctan.org/tex-archive/macros/latex/contrib/microtype/microtype.pdf) ist die Doku dazu.

~~~tex
...
%optischer Randausgleich aktivieren
\usepackage{microtype}             % ist auf alten Installation nicht immer vorhanden
% \usepackage[activate]{pdfcprot}  % wird nicht mehr weiter entwickelt
...
~~~
