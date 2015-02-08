---
layout: post
title: "DHT22 am Raspberry Pi"
description: ""
category: 
  - Raspberry Pi
  - Elektronik
  - Programmieren
tags:
  - python
  - DTH22
  - Sensor
  - git
---
{% include JB/setup %}

## Was kann der DHT22? ##
 - kostet zwischen 6€ und 9€
 - 3,3 - 5V Eingangsspannung
 - max. 2.5 mA (während der Datenübertragung)
 - 40-50 µA Standby-Strom
 - Luftfeuchtigkeit: 0 bis 100% relative Luftfeuchtigkeit mit ±2% Genauigkeit
 - Temperaturbereich: -40 bis 80°C ± 0,5°C
 - Sampling Rate: max. 0,5Hz (eine Messung in 2 Sekunden)

## Aufbau ##
Um den DHT22 am Raspberry Pi zu betreiben ist noch ein [Pullup-Widerstand] von 4,7 bis 10kΩ nötig.
Dieser wird zwischen Datenleitung und der 3,3V Spannungsversorgung geschaltet. Man darf den Sensor
nur mit 3,3V Spannung versorgen, da die Logik des Raspberry Pi nur 3,3V verträgt.

{% lightbox 300xAUTO dht22_pi.png group:"dht22_group" caption:"Steckbrett mit DHT22 und Raspberry Pi" alt="Steckbrett mit DHT22 und Raspberry Pi" %}

Die roten Leitungen liegen auf 3,3V, die schwarzen Leitungen liegen auf Masse und die weiße Leitung ist die Datenleitung. Man kann den
DHT22 an jedem GPIO-Pin betreiben, hier wird er an Pin GPIO 4 des Raspberry Pi betrieben. 

### Belegung DHT22 ###
 - Pin 1: 3,3V
 - Pin 2: Daten
 - Pin 3: frei
 - Pin 4: Masse


## Programmierung ##
Es gibt von Adafruit eine Python-[Bibliothek], welche sehr einfach zu nutzen ist, um den Sensor
abzufragen.

{% highlight bash %}
sudo apt-get update
sudo apt-get install build-essential python-dev
git clone https://github.com/adafruit/Adafruit_Python_DHT.git
cd Adafruit_Python_DHT
sudo python setup.py install
{% endhighlight %}

Im `examples` Verzeichnis findet man ein paar Beispiele. Der folgende Code ist
ein funktionierendes Minimalbeispiel, welches man einfach erweitern kann. Man muss 
bedenken, dass der Code als `root` bzw. mit `sudo` ausgeführt werden, da man
direkt auf die Hardware des Raspberry Pi zugreift. [Hier] findet man Nummerierung
der Pins.

{% highlight python %}
#!/usr/bin/python
# -*- coding: utf-8 -*-
#

import Adafruit_DHT

# GPIO pin for DTH-22
# see http://pi.gadgetoid.com/pinout
pin = 4

# Try to grab a sensor reading.  Use the read_retry method which will retry up
# to 15 times to get a sensor reading (waiting 2 seconds between each retry).
humidity, temperature = Adafruit_DHT.read_retry(Adafruit_DHT.DHT22, pin)

if humidity is None or temperature is None:
    print 'Failed to get reading DTH-22. Try again!'
else:
    print "Temperature: %8.2f°C" % temperature
    print "Humidity:    %8.2f%%" % humidity
{% endhighlight %}



[Pullup-Widerstand]: http://www.elektronik-kompendium.de/public/schaerer/pullr.htm
[Bibliothek]: https://github.com/adafruit/Adafruit_Python_DHT.git
[Hier]: http://pi.gadgetoid.com/pinout
