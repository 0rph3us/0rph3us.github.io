+++
title = "Kernel Bauen"
date = "2017-07-27T19:27:52+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["Ubuntu", "Debian"]
categories = ["Linux"]
+++

Auf meinen Arbeitslaptop und auf meinen privaten Desktop
nutze ich Ubuntu 16.04. Da die Ubuntu-Kernel etwas staubig
sind, habe ich angefangen selbst einen aktuellen Kernel (4.12.3)
zu bauen.


## Abhänigkeiten
Zum bauen des Kernels unter Ubuntu benötigt man `build-essential`
und `libssl-dev`. Mit `ccache` kann man das bauen beschleunigen[^1] aus
diesem Grund nutze ich es. Auf [kernel.org] findet man die neusten
Kernel als tarball zum download.


## Kernel bauen
Wenn man die alte Konfiguration beibehalten möchte, dann muss man
vorher die laufende Konfiguration in das aktuelle Verzeichnis vom
entpackten Kernel kopieren:

{{< highlight sh >}}
 cp "/boot/config-$(uname -r)" .config
{{< /highlight >}}


{{< highlight sh >}}
tar xfvJ linux-4.12.3.tar.xz
cd linux-4.12.3
yes '' | make oldconfig
make CC='ccache gcc' -j $(nproc) deb-pkg LOCALVERSION=-custom
{{< /highlight >}}

Anschließend kann man die Pakte mit `dpkg -i` installieren. Ich
installiere immer alle, außer die Debug Pakete. Diese haben `dbg`
im Namen.

## Fallstricke

### Plattenplatz
Zum bauen vom Kernel benötigt sollte man ca. 25GB Plattenplatz einplanen.

### Fehlende Firmware
Man sollte nach jedem Kernelupdate mit `dmesg` prüfen, ob alles
in Ordnung ist. Bei mir funktionierte nach dem Kernelupdate das
WLAN nicht. Die Ursache war eine zu alte Firmware. Derartige
Probleme lassen sich mitunter recht einfach lösen. Es gibt auf
kernel.org das Repository [linux-firmware]. Dort findet man die
offiziellen Firmware Blobs.

Entweder man führt `make install` aus oder man kopiert die fehlenden
Blobs nach `/lib/firmware/`. Ich kopiere die fehlenden Blobs immer per
Hand hin, welche Blobs fehlen verrät `dmesg` in der Regel.

### andere make targets
Wenn man statt `yes '' | make oldconfig` `yes '' | make localmodconfig` verwendet
enthält der neue Kernel nur die Module, welche der aktuelle Kernel geladen hat. Dadurch
spart massiv Zeit beim bauen und der Kernel wird auch viel kleiner[^2].

 
[kernel.org]: https://www.kernel.org/
[linux-firmware]: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
[^1]: Ich habe [hier]({{< relref "ccache.md" >}}) noch einige Anmerkungen zu ccache.
[^2]: Ich gehe davon aus, dass man  in der Regel nur ein Bruchteil der Kernelmodule nutzt.