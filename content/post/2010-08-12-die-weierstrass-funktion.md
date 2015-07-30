---
layout: post
title: Die Weierstraß-Funktion
date: 2010-08-12
categories:
 - sonstiges
tags:
 - diffenzierbar
 - stetig
 - weierstraß
mathjax: true
lightbox: true
---
Ich habe mich heute an mein Proseminar in Analysis erinnert.  Ein Thema war eine überall stetige, aber nirgendwo diffenzierbare Funktion.
Das es eine solche Funktion gibt war lange Zeit unbekannt.

Aus der Diffenzierbarkeit folgt die Stetigkeit. Diese Umkehrung dieser Aussage gibt nicht. Ein Beipiel ist die Betragsfunktion.
Diese ist im Nullpunkt nicht diffenzierbar. Der Mathematiker [Karl Weierstraß](https://de.wikipedia.org/wiki/Karl_Weierstra%C3%9F)
hat im 19. Jahrhundert eine Funktion konstruiert, welche überall stetig, aber an keiner Stelle differenziebar ist.

$$ f(x) = \sum_{n=0}^\infty \frac{\sin(101^n\cdot x)}{100^n} $$

Das ist nicht die Orginale Funktion von ihm, welche er zuerst vorgestellt hat. Diese Funktion sieht aber aus wie eine Sinuskurve. 
Die Zacken im Plot entstehen, weil die Summe nicht bis Unendlich läuft. Aus Gründen der Zahlendarstellung im Rechner,
habe ich die Summe nur bis 50 laufen lassen.

<a href="/weierstrass.png" title="" data-lightbox="set1" data-title="Plots der Weierstraß- und Sinusfunktion"><img src="/weierstrass-thumbnail.png" alt="Plots der Weierstraß- und Sinusfunktion"></a>

Seine erste Funktion sah wie folgt aus:

$$ f(x) = \sum_{n=0}^\infty a^n\cos(b^n\pi x) $$

Unter den folgenden Bedingungen: $$ 0 < a < 1$$  und $$b \in \mathbb{N}$$ sowie $$ ab > 1+\frac{3}{2} \pi$$
