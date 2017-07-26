---
title: Virtual Box-Clienten auf raw-Devices
author: Michael Rennecke
type: post
date: 2010-02-08T21:18:16+00:00
categories:
  - Solaris
  - Tools
tags:
  - OpenSolaris
  - vbox
  - zfs

---
Dan man mit zfs kann man auch volumes anlegen kann, wollte ich mal testen, ob man auch einen [VirtualBox][1]-Client auch auf ein solches Volume installieren kann. Es benötige einiges an Vorbereitungen, aber es geht wie folgt:

#### 1. Volume erzeugen

``` sh
rennecke@walhalla VirtualBox $ pfexec  zfs create -s -V 200g daten/vol_win
```

man erzeugt hiermit ein Volume, welches 200 GB groß ist. Es fordert den Speicher erst an, wenn dieser benötigt wird.

####  2. VirtualBox-User Zugriff auf das raw-Device geben

``` sh
rennecke@walhalla VirtualBox $ pfexec chown rennecke:staff /dev/zvol/rdsk/daten/vol_win
rennecke@walhalla VirtualBox $ pfexec chmod 660 /dev/zvol/rdsk/daten/vol_win
```

Das Device VirtualBox bekannt geben. Ich möchte diese Platten nicht bei den virtuellen Platten liegen haben.

``` sh
rennecke@walhalla VirtualBox $ mkdir ~/.VirtualBox/raw-disk
rennecke@walhalla VirtualBox $ cd /opt/VirtualBox/
rennecke@walhalla VirtualBox $ VBoxManage internalcommands createrawvmdk -filename /home/rennecke/.VirtualBox/raw-disk/windows-raw.vmdk -rawdisk /dev/zvol/rdsk/daten/vol_win -register
```

#### 3. Fertig: Nun kann man in VirtualBox auf das Volume zugreifen

Man sollte aber wissen, was man tut. Man kann sich mit dieser Vorgehensweise ganz schnell etwas kaputt machen, z.B. indem man VirtualBox das falsche raw-Device übergibt. Das ganze hat auch noch einen anderen Schönheitsfehler. Man kann keine Snapshots mit VirtualBox erzeugen. Diese werden als Datei im Dateisystem auf dem Host abgelegt. Man kann aber Snapshots mit zfs erstellen, um Sicherungen der Virtuellen Maschine zu haben. Vielleicht gibt es irgendwann eine VirtualBox-Version, welche Features von zfs nutzt.

 [1]: http://www.virtualbox.org/
