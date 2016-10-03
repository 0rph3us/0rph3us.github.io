---
type: post
title: "rrdtool und json"
date: 2014-10-28
description: ""
categories: 
  - programmieren
  - Tools
tags:
  - rrdtool
  - json
  - xml
  - ajax
  - jquerry
  - highcharts
  - javascript
---


In den letzten beiden Beiträgen habe ich erklärt, wie man den [DTH22] bzw. [BMP085] am
Raspberry Pi betreibt. Es liegt nahe die Sensordaten aufzuzeichnen und zu 
visualisieren. In einen kleinen Prototyp habe ich die Daten mit [RRDtool] gespeichert und mit [Highcharts]
angezeigt. 

Meine Idee war, dass ich aus der RRD-Datenbank einige Daten zu json konvertiere, um sie dann
mit Highcharts anzuzeigen. Die json-Daten wollte ich mit einem ajax-Request nachladen. Da ich
so gut wie keine JavaScript- und JQuerry-Kenntnisse habe, habe ich sehr lange vergeblich 
probiert einen Graph zu zeichnen. Als ich das von RRDtool generierte "json" mir angesehen
habe, ist mir aufgefallen, dass es kein valides json ist... 

Weil ich noch ein Erfolgserlebnis haben wollte, bin ich auf den validen xml-Export von
RRDtool umgestiegen. Danach hat der Prototyp funktioniert.

Nach etwas Recherche im Netz, bin ich auch auf ein [Bug-Ticket] gestoßen, welches den kaputten
json-Export anspricht.


[BMP085]: {{< ref "bmp085-am-raspberry-pi.md" >}}
[DTH22]: {{< ref "dht22-am-raspberry-pi.md" >}}
[RRDtool]: http://oss.oetiker.ch/rrdtool/
[Highcharts]: http://www.highcharts.com/
[Bug-Ticket]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=686825
