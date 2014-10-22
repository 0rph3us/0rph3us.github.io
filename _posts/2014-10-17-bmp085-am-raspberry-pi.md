---
layout: post
title: "BMP085 am Raspberry Pi"
description: ""
category:
  - Raspberry Pi
  - Elektronik
  - Programmieren
tags:
  - python
  - BMP085
  - Sensor
  - git
  - I²C
---
{% include JB/setup %}

## Was kann der BMP085? ##
 - Kosten: 8 - 12€
 - 1,8 - 3,6V Eingangsspannung
 - Stromverbrauch
     - 3 µA (ultra-low power mode, 1Hz Samplingrate)
     - 32 µA (advanced power mode, 1Hz Samplingrate)
     - 0.1 μA Standby
     - max. 650 μA in der Spitze
 - Temperaturbereich: -40 bis 85°C
 - Luftdruck: 300 bis 1100 hPa

## Aufbau ##
Der BMP085 ist ganz einfach am Raspberry Pi zu betreiben, da man ihn über
den [I²C-Bus] anspricht. Beim Anschließen muss man aber aufpassen, da die
verschiedenen Hersteller verschiedene Pin-Belegungen haben. Die Belegung
steht auf der Vorder- oder Rückseite der Platine. Es gibt auch Sensoren,
bei denen man die Pins noch anlöten muss.

{% lightbox 300xAUTO bmp085_pi.png group:"bmp085_group" caption:"Steckbrett mit BMP085 und Raspberry Pi" alt="Steckbrett mit BMP085 und Raspberry Pi" %}

An den roten Leitungen liegen 3,3V an, die schwarzen Leitungen liegen auf Masse.
Die orange und violette Leitung sind der I²C-Bus, wobei 
orange SDA (Serial Data) und violett SCL (Serial Clock) ist. [Hier] findet man ein
paar mehr technische Informationen zum I²C-Bus

## Programmierung ##

### Betriebssystem vorbeiten ###

Um den I²C-Bus ansprechen zu können, muss man 2 Kernel-Module laden und ein paar Pakete
installieren. Unter Raspbian und Debian ist alles in den Standart-Paketquellen verfügbar.

{% highlight bash %}
sudo apt-get update
sudo apt-get install build-essential python-dev python-smbus
{% endhighlight %}

Nun kümmern wir uns um die Kernelmodule. Bei [Raspbian] muss man die die Module
noch in der Datei `/etc/modprobe.d/raspi-blacklist.conf` mit einer Raute `#` 
am Zeilenanfang auskommentieren. Dazu muss man `root` oder den Editor mit `sudo`
starten.

{% highlight bash %}
sudo su -
echo "i2c-dev" >> /etc/modules
echo "i2c_bcm2708" >> /etc/modules
{% endhighlight %}

Damit man bequem auf den Sensor zugreifen kann, sollte man auch gleich die passende
Python-Bibliothek von Adafruit installieren.

{% highlight bash %}
git clone https://github.com/adafruit/Adafruit_Python_BMP
cd Adafruit_Python_BMP
sudo python setup.py install
{% endhighlight %}

Es gibt auch hier im `examples`-Verzeichnis einige Beispiele.

### Minimalbeispiel ###

Das kleine Python-Programm muss als `root` bzw. mit `sudo` ausgeführt werden.

{% highlight python %}
#!/usr/bin/python
# -*- coding: utf-8 -*-
#

import Adafruit_BMP.BMP085 as BMP085

bmp085 = BMP085.BMP085()

# Read the current temperature
temp   = bmp085.read_temperature()

# Read the current barometric pressure level
pressure = bmp085.read_pressure()

# calculate hPa
pressure = pressure / 100.0

print "Temperature:  {:8.2f} °C".format(temp)
print "Pressure:     {:8.2f} hPa".format(pressure)
{% endhighlight %}

Man kann auch mit Hilfe der [Bibliothek] die [Höhe barometrisch] bestimmen und auch den Luftdruck
auf Meereshöhe. Nur der Luftdruck auf Meereshöhe ist zwischen Wetterstationen vergleichbar.

[I²C-Bus]: http://de.wikipedia.org/wiki/I%C2%B2C
[Hier]: http://www.timmermann.org/ralph/index.htm?http://www.ralph.timmermann.org/elektronik/i2c.htm
[Raspbian]: http://www.raspbian.org/
[Bibliothek]: https://github.com/adafruit/Adafruit_Python_BMP
[Höhe barometrisch]: http://de.wikipedia.org/wiki/Barometrische_H%C3%B6henformel
