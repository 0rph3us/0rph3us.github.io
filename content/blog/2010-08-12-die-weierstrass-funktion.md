---
title: Die Weierstraß-Funktion
author: Michael Rennecke
type: post
date: 2010-08-12T09:25:25+00:00
url: /sonstiges/die-weierstrass-funktion
categories:
  - sonstiges
tags:
  - nicht diffenzierbar
  - stetig
  - weierstraß

---
Ich habe mich heute an mein Proseminar in Analysis erinnert.  Ein Thema war eine überall stetige, aber niergendwo diffenzierbare Funktion.  Das es eine solche Funktion gibt war lange Zeit unbekannt.

Aus der Diffenzierbarkeit folgt die Stetigkeit. Diese Umkehrung dieser Aussage gibt nicht. Ein Beipiel ist die Betragsfunktion. Diese ist im Nullpunkt nicht diffenzierbar. Der Mathematiker [Karl Weierstraß][1] hat im 19. Jahrhundert eine Funktion konstruiert, welche überall stetig, aber an keiner Stelle differenziebar ist.

<p style="text-align: center;">
  <img src='http://s0.wp.com/latex.php?latex=+f%28x%29+%3D+%5Csum_%7Bn%3D0%7D%5E%5Cinfty+%5Cfrac%7B%5Csin%28101%5En%5Ccdot+x%29%7D%7B100%5En%7D&#038;bg=ffffff&#038;fg=000000&#038;s=3' alt=' f(x) = \sum_{n=0}^\infty \frac{\sin(101^n\cdot x)}{100^n}' title=' f(x) = \sum_{n=0}^\infty \frac{\sin(101^n\cdot x)}{100^n}' class='latex' />
</p>

Das ist nicht die Orginale Funktion von ihm, welche er zuerst vorgestellt hat. Diese Funktion sieht aber aus wie eine Sinuskurve. Die Zacken im Plot entstehen, weil die Summe nicht bis Unendlich läuft. Aus Gründen der Zahlendarstellung im Rechner, habe ich die Summe nur bis 50 laufen lassen.

<p style="text-align: center;">
  <a href="http://0rpheus.net/uploads/2010/08/weierstrass.png" rel="lightbox[3192]"><img class="aligncenter" title="Weierstraß-Funktion" src="http://0rpheus.net/uploads/2010/08/weierstrass-300x300.png" alt="Plots der Weierstraß- und Sinusfunktion" width="300" height="300" /></a>
</p>

Seine erste Funktion sah wie folgt aus:

<p style="text-align: center;">
  <img src='http://s0.wp.com/latex.php?latex=f%28x%29+%3D+%5Csum_%7Bn%3D0%7D%5E%5Cinfty+a%5En%5Ccos%28b%5En%5Cpi+x%29+&#038;bg=ffffff&#038;fg=000000&#038;s=3' alt='f(x) = \sum_{n=0}^\infty a^n\cos(b^n\pi x) ' title='f(x) = \sum_{n=0}^\infty a^n\cos(b^n\pi x) ' class='latex' />
</p>

Unter den folgenden Bedingungen: <img src='http://s0.wp.com/latex.php?latex=0+%3C+a+%3C+1%26%2391%3B%2Flatex%26%2393%3B++und+%26%2391%3Blatex%26%2393%3B+b+%5Cin+%5Cmathbb%7BN%7D%26%2391%3B%2Flatex%26%2393%3B+sowie+%26%2391%3Blatex%26%2393%3B+ab+%3E+1%2B%5Cfrac%7B3%7D%7B2%7D+%5Cpi&#038;bg=ffffff&#038;fg=000000&#038;s=0' alt='0 < a < 1&#091;/latex&#093;  und &#091;latex&#093; b \in \mathbb{N}&#091;/latex&#093; sowie &#091;latex&#093; ab > 1+\frac{3}{2} \pi' title='0 < a < 1&#091;/latex&#093;  und &#091;latex&#093; b \in \mathbb{N}&#091;/latex&#093; sowie &#091;latex&#093; ab > 1+\frac{3}{2} \pi' class='latex' />

 [1]: http://de.wikipedia.org/wiki/Karl_Weierstra%C3%9F "Karl Weierstraß"