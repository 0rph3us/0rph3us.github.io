---
title: Im SunStudio die STL nutzen
author: Michael Rennecke
type: post
date: 2010-11-26T07:08:37+00:00
categories:
  - Programmieren
  - Tools
tags:
  - STL
  - Sun
  - Sun Studio

---
Mir ist die Tage beim programmieren negativ aufgefallen, dass sich im Sun Studio 12 Express einige Funktionen anderst sind, als in der STL spezifiziert. Mir ist es bei _std::sort_ aufgefallen. Man kann normal _sort_ eine Funktion übergeben, welche die Elemente vergleicht. Diese Überladung existiert in der Sun STL nicht. Das ist bekannt und wurde schon an anderen Stellen diskutiert. Wenn man die STL nutzen möchte, dann muss man dem Compiler die Option _-library=stlport4_ mitgeben, dann wird die standartkonforme STL verwendet.

Im Sun Studio kann man diese Option unter Additional Options mit angeben.