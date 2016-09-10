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

  1. Volume erzeugen: <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla VirtualBox $ pfexec  zfs create <span style="color: #660033;">-s</span> <span style="color: #660033;">-V</span> 200g daten<span style="color: #000000; font-weight: bold;">/</span>vol_win</pre>
          </td>
        </tr>
      </table>
    </div>
    
    man erzeugt hiermit ein Volume, welches 200 GB groß ist. Es fordert den Speicher erst an, wenn dieser benötigt wird.

  2. VirtualBox-User Zugriff auf das raw-Device geben: <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla VirtualBox $ pfexec <span style="color: #c20cb9; font-weight: bold;">chown</span> rennecke:staff <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>zvol<span style="color: #000000; font-weight: bold;">/</span>rdsk<span style="color: #000000; font-weight: bold;">/</span>daten<span style="color: #000000; font-weight: bold;">/</span>vol_win
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla VirtualBox $ pfexec <span style="color: #c20cb9; font-weight: bold;">chmod</span> <span style="color: #000000;">660</span> <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>zvol<span style="color: #000000; font-weight: bold;">/</span>rdsk<span style="color: #000000; font-weight: bold;">/</span>daten<span style="color: #000000; font-weight: bold;">/</span>vol_win</pre>
          </td>
        </tr>
      </table>
    </div>
    
    Das Device VirtualBox bekannt geben. Ich möchte diese Platten nicht bei den virtuellen Platten liegen haben.
    
    <div class="wp_syntax">
      <table>
        <tr>
          <td class="code">
            <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla VirtualBox $ <span style="color: #c20cb9; font-weight: bold;">mkdir</span> ~<span style="color: #000000; font-weight: bold;">/</span>.VirtualBox<span style="color: #000000; font-weight: bold;">/</span>raw-disk
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla VirtualBox $ <span style="color: #7a0874; font-weight: bold;">cd</span> <span style="color: #000000; font-weight: bold;">/</span>opt<span style="color: #000000; font-weight: bold;">/</span>VirtualBox<span style="color: #000000; font-weight: bold;">/</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla VirtualBox $ VBoxManage internalcommands createrawvmdk <span style="color: #660033;">-filename</span> <span style="color: #000000; font-weight: bold;">/</span>home<span style="color: #000000; font-weight: bold;">/</span>rennecke<span style="color: #000000; font-weight: bold;">/</span>.VirtualBox<span style="color: #000000; font-weight: bold;">/</span>raw-disk<span style="color: #000000; font-weight: bold;">/</span>windows-raw.vmdk <span style="color: #660033;">-rawdisk</span> <span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span>zvol<span style="color: #000000; font-weight: bold;">/</span>rdsk<span style="color: #000000; font-weight: bold;">/</span>daten<span style="color: #000000; font-weight: bold;">/</span>vol_win <span style="color: #660033;">-register</span></pre>
          </td>
        </tr>
      </table>
    </div>

  3. Fertig: Nun kann man in VirtualBox auf das Volume zugreifen.

Man sollte aber wissen, was man tut. Man kann sich mit dieser Vorgehensweise ganz schnell etwas kaputt machen, z.B. indem man VirtualBox das falsche raw-Device übergibt. Das ganze hat auch noch einen anderen Schönheitsfehler. Man kann keine Snapshots mit VirtualBox erzeugen. Diese werden als Datei im Dateisystem auf dem Host abgelegt. Man kann aber Snapshots mit zfs erstellen, um Sicherungen der Virtuellen Maschine zu haben. Vielleicht gibt es irgendwann eine VirtualBox-Version, welche Features von zfs nutzt.

 [1]: http://www.virtualbox.org/