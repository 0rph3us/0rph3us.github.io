---
title: "Kaktusstack mit festen Takt"
date: 2020-06-02T22:12:28+02:00
draft: false
description:
categories:
 - HPC
featured_image:
author: ""
---

In meinen [letzten Post] habe ich einen Teil meiner Diplomarbeit wieder zum leben erweckt.
Nun habe ich einmal den Boost meines Ryzen 2700 abgeschaltet und habe die Matrixmultiplikation
nach Strassen mit vollbesetzten 8192x8192 Matrizzen noch einmal durchlaufen lassen.

![Speedup Ryzen 2700 mit festen Takt](/img/ryzen-8192-fixed.png)

Das Ergebnis sieht besser aus, als ich gedacht habe. Bis 5 Threads skaliert das ganze fast linear.
Daraus folgt, dass die Einbrüche im Speedup ausschließlich mit dem dynamischen Taktverhalten der
CPUs zusammenhängen.

Den Boost kann man unter Linux wie folgt deaktivieren:

{{< highlight sh >}}
echo 0 > /sys/devices/system/cpu/cpufreq/boost
{{< /highlight >}}

Es steht jeden frei seine CPU hochzutakten, statt den Boost zu deaktivieren. Das ist auf jeden
ohne gefahrlos möglich. Es ist für den Speedup egal, ob die CPU mit 3200 MHz oder mit 5 GHz auf
allen Kernen läuft.

[letzten Post]:  {{< ref "diplomarbeit-nach-10-jahren.md" >}}