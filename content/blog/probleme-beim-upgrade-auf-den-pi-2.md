---
type: post
title: "Probleme beim Upgrade auf den Pi 2"
date: 2015-03-11
description: ""
categories: 
 - 'Raspberry Pi'
tags:
 - I²C
 - spi
 - BMP085
 - DTH22
 - NRF24L01
---


Ich wollte meine Sensoren ([BMP085] und [DHT22]) an meinen Raspberry Pi 2 anschließen und gleich noch
ein paar Experimente mit dem 2,4 GHz Sender [NRF24L01]. Dabei musste ich feststellen, dass der [I²C-Bus] und
das [SPI (Serial Peripheral Interface)] nicht wie gewohnt funktionieren.

Beim Kernel 3.18 gab es einige Änderungen, die einen das Leben schwer machen. Es gibt auf stackechange eine
[kurze Zusammenfassung] und eine [sehr Ausführliche auf raspberrypi.org].

Wer es kurz und knackig mag, der fügt die folgenden Zeilen in `/boot/config.txt` ein und startet den Pi neu.

```
dtparam=i2c1=on
dtparam=spi=on
```

[kurze Zusammenfassung]: http://raspberrypi.stackexchange.com/questions/27073/firmware-3-18-x-breaks-i2c-spi-audio-lirc-1-wire-e-g-dev-i2c-1-no-such-f
[sehr Ausführliche auf raspberrypi.org]: http://www.raspberrypi.org/forums/viewtopic.php?p=675658#p675658
[NRF24L01]: http://www.mikrocontroller.net/articles/NRF24L01_Tutorial
[BMP085]: {{< ref "bmp085-am-raspberry-pi.md" >}}
[DHT22]: {{< ref "dht22-am-raspberry-pi.md" >}}
[SPI (Serial Peripheral Interface)]: http://de.wikipedia.org/wiki/Serial_Peripheral_Interface
[I²C-Bus]: http://de.wikipedia.org/wiki/I%C2%B2C
