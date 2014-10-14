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
nur mit 3,3V Spannung versorgen, da die Logik des Raspberri Pi nur 3,3V verträgt.

{% lightbox 300xAUTO dht22_pi.png group:"dht22_group" caption:"Steckbrett mit DHT22 und Raspberry Pi" alt="Steckbrett mit DHT22 und Raspberry Pi" %}

Auf den roten Leitungen liegen auf 3,3V, die schwarzen Leitungen liegen auf Masse und die weiße Leitung ist die Datenleitung. Man kann den
DHT22 an jedem GPIO-Pin betreiben, hier wird er an Pin 4 des Raspberry Pi betrieben. 

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



[Pullup-Widerstand]: http://www.elektronik-kompendium.de/public/schaerer/pullr.htm
[Bibliothek]: https://github.com/adafruit/Adafruit_Python_DHT.git
