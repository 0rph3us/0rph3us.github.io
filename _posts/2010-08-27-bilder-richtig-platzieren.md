---
layout: post
title: 'LaTeX: Bilder an eine bestimmte Stelle platzieren'
categories:
- sonstiges
- Tools
- LaTeX
tags:
- Bild
- TeX Live
status: publish
type: post
published: true
author:
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
---


Wenn man bei $$\LaTeX$$  Bilder einfügt, dann wundert man sich vielleicht, dass sie an einer anderden Stelle sind.
$$\LaTeX$$  setzt normal die Bilder so, dass man möglichst wenig weiße Fläche hat. Manchmal möchte man erzwingen,
dass ein Bild an einer bestimmten Position ist. Dafür gibt es das alte Package `here`, welches inzwischen
bei [TeX Live](http://tug.org/texlive/) durch `float` ersetzt wurde.


{% highlight latex %}
\usepackage{float} % lädt das Paket zum erzwingen der Grafikposition
%\usepackage{here} auf älteren LaTeX Distributionen

\begin{document}

\begin{figure}[H]
   %mit dem großen H wird die Grafikposition auf HERE gesetzt
   \centering
   \fbox{ %erzeugt einen Rahmen um die Grafik
      \includegraphics[angle=0,width=5cm]{Bild.png}
   }
\end{figure}

\end{document}
{% endhighlight %}

