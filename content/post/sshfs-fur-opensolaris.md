---
title: sshfs für OpenSolaris
author: Michael Rennecke
type: post
date: 2009-09-22T22:40:47+00:00
categories:
  - Solaris
  - Tools
tags:
  - fuse
  - OpenSolaris
  - ssh
  - sshfs

---
Ich wollte mal endlich auch unter Open Solaris [sshfs][1] haben, deswegen habe ich mich informiert wie man das anstellt. Infos findet man unter

  * [Projekt fuse][2]
  * [Projekt sshfs][3]

#### Vorarbeiten für Open Solaris

folgende Packte muss man installiert haben:

  * SUNWgnome-common-devel
  * sunstudioexpress
  * SUNWmercurial

#### Installation von SUNWonbld

Packet für die eigene Architektur [hier][4] herunterladen

``` sh
rennecke@trantor ~ $ bunzip2 SUNWonbld.i386.tar.bz2
rennecke@trantor ~ $ tar xfv SUNWonbld.i386.tar  rennecke@trantor ~ $ pfexec /usr/sbin/pkgadd -d onbld SUNWonbld
```

Alternativ kann man auch das Packet _SUNWonbld_ über `pkg` installieren

#### Pfad anpassen

``` sh
$ export PATH=/opt/onbld/bin:/opt/onbld/bin/i386:/opt/SunStudioExpress/bin:/usr/bin:/usr/sfw/bin:$PATH
```

#### fuse installieren

``` sh
rennecke@trantor ~ $ mkdir fuse; cd fuse
rennecke@trantor fuse $ hg clone ssh://anon@hg.opensolaris.org/hg/fuse/libfuse libfuse
rennecke@trantor fuse $ hg clone ssh://anon@hg.opensolaris.org/hg/fuse/fusefs fusefs
rennecke@trantor fuse $ cd libfuse/
rennecke@trantor libfuse $ make
rennecke@trantor libfuse $ make install
rennecke@trantor libfuse $ make pkg
rennecke@trantor libfuse $ cd ../fusefs/kernel
rennecke@trantor kernel $ make
rennecke@trantor kernel $ make install
rennecke@trantor kernel $ make pkg
rennecke@trantor kernel $ pfexec /usr/sbin/pkgadd -d packages SUNWfusefs
rennecke@trantor kernel $ pfexec /usr/sbin/pkgadd -d ../../libfuse/packages SUNWlibfuse
```

#### sshfs installieren

[Quellen von sshfs bei sourceforge runter laden][3]

``` sh
rennecke@trantor fuse $ gunzip sshfs-fuse-2.2.tar.gz
rennecke@trantor fuse $ tar xf sshfs-fuse-2.2.tar
rennecke@trantor fuse $ cd sshfs-fuse-2.2
rennecke@trantor sshfs-fuse-2.2 $ ./configure --prefix=/usr
rennecke@trantor sshfs-fuse-2.2 $ make
rennecke@trantor sshfs-fuse-2.2 $ pfexec make install
```


#### sshfs benutzen

```
rennecke@trantor ~ $ sshfs rennecke@zeus:/home/rennecke /mnt
```

Es gibt auch eine Manpage zu `sshfs` 😉

 [1]: http://de.wikipedia.org/wiki/SSHFS
 [2]: http://www.opensolaris.org/os/project/fuse/
 [3]: http://fuse.sourceforge.net/sshfs.html
 [4]: http://dlc.sun.com/osol/on/downloads/current/
