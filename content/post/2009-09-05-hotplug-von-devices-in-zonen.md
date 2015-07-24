---
layout: post
title: Hotplug von Devices in Zonen
date: 2009-09-05
categories:
- Solaris
tags:
- hotplug
- OpenSolaris
- zone
status: publish
type: post
---
Manchmal ist erforderlich, dass man einer Zone den Zugriff auf ein Device gewährt. Ich habe z.B. einer Zone mein
externes LTO-2 Bandlaufwerk gegeben. Dieses ist über [SCSI](http://de.wikipedia.org/wiki/Small_Computer_System_Interface)
mit dem Rechner verbunden. Da ich Strom sparen möchte und [SCSI](http://de.wikipedia.org/wiki/Small_Computer_System_Interface)
[hotplugfähig](http://de.wikipedia.org/wiki/Hot_Swapping) ist, schalte ich das Bandlaufwerk nur ein wenn ich es benötige.


Damit man das Device unter Solaris in der global-Zone ansprechen kann, muss es wie folgt einbinden (mein Laufwerk ist an Controller c17 angeschlossen):

``` sh
cfgadm -c configure c17
root@walhalla ~ $ cfgadm -a c17
p_Id                          Type         Receptacle   Occupant     Condition
c17                            scsi-bus     connected    configured   unknown
c17::rmt/0                     tape         connected    configured   unknown
```


Wenn man in einer nonglobal-Zone ist geht dieses Verfahren nicht. Solaris sagt aber einen woran es liegt:

```
cfgadm: Configuration administration not supported: cfgadm can only be run from the global zone
```


Also muss man Devices, die eine nonglobal-Zone benötigt **immer** in der global-Zone
einbinden bzw. tauschen. Ich vertrete die Auffassung, das man in einer nonglobal-Zone,
so weit es möglich ist, keine Devices gibt. Das kann unter Umständen zu Probleme
bei der Migration der Zonen führen.
