---
title: "Virtualbox Und Kernel 5.3"
date: 2019-10-06T21:05:41+02:00
draft: false 
description:
categories:
 - Linux
 - Tools
tags:
 - virtualbox
 - Ubuntu
featured_image:
author: "Michael Rennecke"
---

Ich habe die Tage meinen Kernel 5.3.1 aktualisiert. Heute Abend wollte ich verswchiedene Virtualisierungslösungen testen.
Dazu nutze ich [VirtualBox]. Ich habe mich gewundert, dass ich keine [Nested Virtualization] machen könnte. Also habe ich
die Kernelmodule neu gebaut. Das ging nicht. Ein Blick ins Log `/var/log/vbox-setup.log`, stimme mich *freudig*...

{{<highlight cfg>}}
...
/tmp/vbox.0/r0drv/linux/mp-r0drv-linux.c: In function ‘VBoxHost_RTMpOnAll’:
/tmp/vbox.0/r0drv/linux/mp-r0drv-linux.c:287:18: error: void value not ignored as it ought to be
         int rc = smp_call_function(rtmpLinuxAllWrapper, &Args, 0 /* wait */);
                  ^~~~~~~~~~~~~~~~~
/tmp/vbox.0/r0drv/linux/mp-r0drv-linux.c: In function ‘VBoxHost_RTMpOnOthers’:
/tmp/vbox.0/r0drv/linux/mp-r0drv-linux.c:341:8: error: void value not ignored as it ought to be
     rc = smp_call_function(rtmpLinuxWrapper, &Args, 1 /* wait */);
        ^
...
{{</highlight>}}

Ich hatte sofort eine Inkompatibilität zwischen VirtualBox 6.0.12 und meinen Kernel in Verdacht. Das Internet gab mir Recht,
wenn man die aktuelle Beta von VirualBox benutzt, dann kann man auch einen aktuellen Kernel verwenden. Die aktuelle Beta ist
die 6.1, welche man [hier] findet.


[hier]: http://download.virtualbox.org/virtualbox/6.1.0_BETA1/
[VirtualBox]: https://www.virtualbox.org/
[Nested Virtualization]: https://docs.oracle.com/cd/E97728_01/F12470/html/nested-virt-support.html
