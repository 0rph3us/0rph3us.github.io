---
title: "Abtastrate unter Ubuntu einstellen"
date: 2020-04-20T21:13:45+02:00
draft: false
description:
categories:
 - Linux
tags:
 - Ubuntu
 - audio 
featured_image:
author: ""
---

Man kann die Abtastrate unter Ubuntu 18.04 in der Datei `/etc/pulse/daemon.conf` einstellen. Damit die Soundkarte
mit 96kHz und 24 Bit läuft muss das folgende enthalten sein:

{{< highlight config >}}
default-sample-format = s24le
default-sample-rate = 96000
{{< /highlight >}}

Ich weiß leider nicht wie man verlässlich die Abtastraten heraus bekommt. Normalerweise findet man sie bei Default PCM:

{{< highlight text >}}
cat /proc/asound/card2/codec#0
Codec: Realtek ALC1220
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec1220
Subsystem Id: 0x1458a0c3
Revision Id: 0x100101
No Modem Function Group found
Default PCM:
    rates [0x5f0]: 32000 44100 48000 88200 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
...
{{< /highlight >}}

Die erste Soundkarte (`card0`) gibt keine Raten aus und die Zweite (`card1`) hat die Datei nicht. Wobei ich `card1`
für meine Kopfhörer benutze.

Wenn man eine 5€ Kopfhörer hat und eine günstige Onboardsoundkarte nützt, dann wird das Ändern der Abtastrate kaum etwas ändern.
An meinen 30€ Kopfhörern höre ich einen Unterschied zwischen 32kHz und 96kHz. Ich bin auf die Problematik aufmerksam geworden, weil
meine USB Soundkarte die Abtastrate per LED anzeigt.
