---
layout: post
title: Die Weierstraß-Funktion
categories:
- sonstiges
tags:
- diffenzierbar
- stetig
- weierstraß
type: post
author:
  login: rennecke
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
mathjax: true
---
Ich habe mich heute an mein Proseminar in Analysis erinnert.  Ein Thema war eine überall stetige, aber nirgendwo diffenzierbare Funktion.
Das es eine solche Funktion gibt war lange Zeit unbekannt.

Aus der Diffenzierbarkeit folgt die Stetigkeit. Diese Umkehrung dieser Aussage gibt nicht. Ein Beipiel ist die Betragsfunktion.
Diese ist im Nullpunkt nicht diffenzierbar. Der Mathematiker [Karl Weierstraß](http://de.wikipedia.org/wiki/Karl_Weierstra%C3%9F)
hat im 19. Jahrhundert eine Funktion konstruiert, welche überall stetig, aber an keiner Stelle differenziebar ist.

$$ f(x) = \sum_{n=0}^\infty \frac{\sin(101^n\cdot x)}{100^n} $$

Das ist nicht die Orginale Funktion von ihm, welche er zuerst vorgestellt hat. Diese Funktion sieht aber aus wie eine Sinuskurve. 
Die Zacken im Plot entstehen, weil die Summe nicht bis Unendlich läuft. Aus Gründen der Zahlendarstellung im Rechner,
habe ich die Summe nur bis 50 laufen lassen.

{% lightbox 200xAUTO weierstrass.png group:"test_group" caption:"Plots der Weierstraß- und Sinusfunktion" alt="test image" %}

Seine erste Funktion sah wie folgt aus:

$$ f(x) = \sum_{n=0}^\infty a^n\cos(b^n\pi x) $$

Unter den folgenden Bedingungen: $$ 0 < a < 1$$  und $$b \in \mathbb{N}$$ sowie $$ ab > 1+\frac{3}{2} \pi$$