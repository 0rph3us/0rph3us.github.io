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

  * Packet für die eigene Architektur [hier][4] herunterladen <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ $ <span style="color: #c20cb9; font-weight: bold;">bunzip2</span> SUNWonbld.i386.tar.bz2
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ $ <span style="color: #c20cb9; font-weight: bold;">tar</span> xfv SUNWonbld.i386.tar  rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ $ pfexec <span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>sbin<span style="color: #000000; font-weight: bold;">/</span>pkgadd <span style="color: #660033;">-d</span> onbld SUNWonbld</pre>
          </td>
        </tr>
      </table>
    </div>
    
    Alternativ kann man auch das Packet _SUNWonbld_ über <tt>pkg</tt> installieren

#### Pfad anpassen

  * <tt>$ export PATH=/opt/onbld/bin:/opt/onbld/bin/i386:/opt/SunStudioExpress/bin:/usr/bin:/usr/sfw/bin:$PATH</tt>

#### fuse installieren

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ $ <span style="color: #c20cb9; font-weight: bold;">mkdir</span> fuse; <span style="color: #7a0874; font-weight: bold;">cd</span> fuse
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor fuse $ hg clone ssh:<span style="color: #000000; font-weight: bold;">//</span>anon<span style="color: #000000; font-weight: bold;">@</span>hg.opensolaris.org<span style="color: #000000; font-weight: bold;">/</span>hg<span style="color: #000000; font-weight: bold;">/</span>fuse<span style="color: #000000; font-weight: bold;">/</span>libfuse libfuse
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor fuse $ hg clone ssh:<span style="color: #000000; font-weight: bold;">//</span>anon<span style="color: #000000; font-weight: bold;">@</span>hg.opensolaris.org<span style="color: #000000; font-weight: bold;">/</span>hg<span style="color: #000000; font-weight: bold;">/</span>fuse<span style="color: #000000; font-weight: bold;">/</span>fusefs fusefs
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor fuse $ <span style="color: #7a0874; font-weight: bold;">cd</span> libfuse<span style="color: #000000; font-weight: bold;">/</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor libfuse $ <span style="color: #c20cb9; font-weight: bold;">make</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor libfuse $ <span style="color: #c20cb9; font-weight: bold;">make</span> <span style="color: #c20cb9; font-weight: bold;">install</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor libfuse $ <span style="color: #c20cb9; font-weight: bold;">make</span> pkg
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor libfuse $ <span style="color: #7a0874; font-weight: bold;">cd</span> ..<span style="color: #000000; font-weight: bold;">/</span>fusefs<span style="color: #000000; font-weight: bold;">/</span>kernel
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor kernel $ <span style="color: #c20cb9; font-weight: bold;">make</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor kernel $ <span style="color: #c20cb9; font-weight: bold;">make</span> <span style="color: #c20cb9; font-weight: bold;">install</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor kernel $ <span style="color: #c20cb9; font-weight: bold;">make</span> pkg
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor kernel $ pfexec <span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>sbin<span style="color: #000000; font-weight: bold;">/</span>pkgadd <span style="color: #660033;">-d</span> packages SUNWfusefs
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor kernel $ pfexec <span style="color: #000000; font-weight: bold;">/</span>usr<span style="color: #000000; font-weight: bold;">/</span>sbin<span style="color: #000000; font-weight: bold;">/</span>pkgadd <span style="color: #660033;">-d</span> ..<span style="color: #000000; font-weight: bold;">/</span>..<span style="color: #000000; font-weight: bold;">/</span>libfuse<span style="color: #000000; font-weight: bold;">/</span>packages SUNWlibfuse</pre>
      </td>
    </tr>
  </table>
</div>

#### sshfs installieren

  * [Quellen von sshfs bei sourceforge runter laden][3]

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor fuse $ <span style="color: #c20cb9; font-weight: bold;">gunzip</span> sshfs-fuse-<span style="color: #000000;">2.2</span>.tar.gz
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor fuse $ <span style="color: #c20cb9; font-weight: bold;">tar</span> xf sshfs-fuse-<span style="color: #000000;">2.2</span>.tar
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor fuse $ <span style="color: #7a0874; font-weight: bold;">cd</span> sshfs-fuse-<span style="color: #000000;">2.2</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor sshfs-fuse-<span style="color: #000000;">2.2</span> $ .<span style="color: #000000; font-weight: bold;">/</span>configure <span style="color: #660033;">--prefix</span>=<span style="color: #000000; font-weight: bold;">/</span>usr
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor sshfs-fuse-<span style="color: #000000;">2.2</span> $ <span style="color: #c20cb9; font-weight: bold;">make</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor sshfs-fuse-<span style="color: #000000;">2.2</span> $ pfexec <span style="color: #c20cb9; font-weight: bold;">make</span> <span style="color: #c20cb9; font-weight: bold;">install</span></pre>
      </td>
    </tr>
  </table>
</div>

#### sshfs benutzen

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>trantor ~ $ sshfs rennecke<span style="color: #000000; font-weight: bold;">@</span>zeus:<span style="color: #000000; font-weight: bold;">/</span>home<span style="color: #000000; font-weight: bold;">/</span>rennecke <span style="color: #000000; font-weight: bold;">/</span>mnt</pre>
      </td>
    </tr>
  </table>
</div>

Es gibt auch eine Manpage zu <tt>sshfs</tt> 😉

 [1]: http://de.wikipedia.org/wiki/SSHFS
 [2]: http://www.opensolaris.org/os/project/fuse/
 [3]: http://fuse.sourceforge.net/sshfs.html
 [4]: http://dlc.sun.com/osol/on/downloads/current/