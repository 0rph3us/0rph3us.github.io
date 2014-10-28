---
layout: post
title: "rrdtool und json"
description: ""
category: 
  - programmieren
  - tools
tags:
  - rrdtool
  - json
  - xml
  - ajax
  - jquerry
  - highcharts
  - javascript
---
{% include JB/setup %}

In den letzten beiden Beiträgen habe ich erklärt, wie man den [DTH22] bzw. [BMP085] am
Raspberry Pi betreibt. Dabei liegt es nahe die Sensordaten aufzuzeichnen und zu 
visualisieren. In einen kleinen Prototyp habe ich die Daten in [RRDtool] und mit [Highcharts]
angezeigt. 

Meine Idee war, dass ich aus der RRD-Datenbank einige Daten zu json konvertiere, um sie dann
mit highcharts anzuzeigen. Die json-Daten wollte ich mit einem ajax-Request nachladen. Da ich
so gut wie keine JavaScript- und JQuerry-Kenntnisse habe, habe ich sehr lange vergeblich 
probiert einen Graph zu zeichnen. Als ich das von RRDtool generierte "json" mir angesehen
habe, ist mir aufgefallen, dass es kein valides json ist. 

Weil ich noch ein Erfolgserlebnis haben wollte, bin ich auf den validen xml-Export von
RRDtool umgestiegen. Danach hat der Prototyp funktioniert.

Nach etwas Recherche im Netz, bin ich auch auf ein [Bug-Ticket] gestoßen, welches den kaputten
json-Export anspricht.


[BMP085]: {% post_url 2014-10-17-bmp085-am-raspberry-pi %}
[DTH22]: {% post_url 2014-10-14-dht22-am-raspberry-pi %}
[RRDtool]: http://oss.oetiker.ch/rrdtool/
[Highcharts]: http://www.highcharts.com/
[Bug-Ticket]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=686825
