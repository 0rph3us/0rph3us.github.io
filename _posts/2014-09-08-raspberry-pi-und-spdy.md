---
layout: post
title: "Raspberry Pi und SPDY"
description: ""
category: 
 - Raspberry Pi
tags:
 - Raspberry Pi
 - SPDY
 - Performance
---
{% include JB/setup %}

Auf meinen Raspberry Pi hatte ich meinen Nginx so konfiguriert, dass er seine
Inhalte auch per [SPDY] ausliefern kann. Das hatte ganz seltsame Nebeneffekte
bei einigen php-Anwendungen und diesem Blog. Ich habe eine weile gedacht, dass 
meine DSL-Leitung zu langsam ist, weil ich auch bei statischen Seiten Verbindungsabbrüche
und halb geladenes [css] hatte.
Dann habe ich einen Versuch ohne [SPDY] gemacht und die Performance ist spürbar
besser geworden. 

Mit SPDY soll der Seitenaufbau schneller sein, als mit TLS und HTTP, aber das scheint
auf dem Raspberry Pi nicht der fall zu sein. Es fehlt ihm entweder an Ressourcen oder
die Implementierung im Nginx ist nicht optimal. Ich tippe darauf, dass mein
gesamtes Setup: Rasberry Pi und eine normale DSL-Leitung nicht geeignet sind um
SPDY sinnvoll zu nutzen.

Durch diese Erfahung werde ich SPDY als Protokoll nicht mehr anbieten.

[SPDY]: http://de.wikipedia.org/wiki/SPDY
[css]: http://de.wikipedia.org/wiki/Cascading_Style_Sheets
