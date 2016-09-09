---
title: Eine Zone in 10 Minuten
author: Michael Rennecke
type: post
date: 2010-04-15T05:39:40+00:00
url: /solaris/eine-zone-in-10-minuten
categories:
  - Solaris
tags:
  - OpenSolaris
  - quotas
  - Virtualisierung
  - zone

---
Ich kam gestern in die Verlegenheit mal schnell eine Zone aufsetzten zu müssen. Ich dachte mir, wenn ich das mal schnell mache, dann wenigsten mit RAM-Quota und CPU-Begrenzung. Es kann evtl. sein, dass man <tt>pkg:/service/resource</tt> installieren muss. Dieses Paket ist f&uuml;r die Verwaltung von RAM-Resourcen zust&auml;ndig.

Ressourcenpools anstellen

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pooladm <span style="color: #660033;">-e</span></pre>
      </td>
    </tr>
  </table>
</div>

Aktuelle Konfiguration in der <tt>/etc/pooladm.conf</tt> sichern

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pooladm <span style="color: #660033;">-s</span></pre>
      </td>
    </tr>
  </table>
</div>

Nun erstellen wir einen Pool mit einem CPU-Set, welches über maximal 2 CPUs verfügt

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec poolcfg <span style="color: #660033;">-c</span> <span style="color: #ff0000;">'create pset zone-pset (uint pset.min=1; uint pset.max=2)'</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec poolcfg <span style="color: #660033;">-c</span> <span style="color: #ff0000;">'create pool zone-pool'</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec poolcfg <span style="color: #660033;">-c</span> <span style="color: #ff0000;">'associate pool zone-pool (pset zone-pset)'</span></pre>
      </td>
    </tr>
  </table>
</div>

Als nächstes aktivieren wir die Konfiguration und speichern sie

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pooladm <span style="color: #660033;">-c</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pooladm <span style="color: #660033;">-s</span>
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec pooladm
&nbsp;
system default
	string	system.comment
	int	system.version <span style="color: #000000;">1</span>
	boolean	system.bind-default <span style="color: #c20cb9; font-weight: bold;">true</span>
	string	system.poold.objectives wt-load
&nbsp;
	pool zone-pool
		int	pool.sys_id <span style="color: #000000;">1</span>
		boolean	pool.active <span style="color: #c20cb9; font-weight: bold;">true</span>
		boolean	pool.default <span style="color: #c20cb9; font-weight: bold;">false</span>
		int	pool.importance <span style="color: #000000;">1</span>
		string	pool.comment
		pset	zone-pset
&nbsp;
	pool pool_default
		int	pool.sys_id <span style="color: #000000;"></span>
		boolean	pool.active <span style="color: #c20cb9; font-weight: bold;">true</span>
		boolean	pool.default <span style="color: #c20cb9; font-weight: bold;">true</span>
		int	pool.importance <span style="color: #000000;">1</span>
		string	pool.comment
		pset	pset_default
&nbsp;
	pset zone-pset
		int	pset.sys_id <span style="color: #000000;">1</span>
		boolean	pset.default <span style="color: #c20cb9; font-weight: bold;">false</span>
		uint	pset.min <span style="color: #000000;">1</span>
		uint	pset.max <span style="color: #000000;">2</span>
		string	pset.units population
		uint	pset.load <span style="color: #000000;">5</span>
		uint	pset.size <span style="color: #000000;">2</span>
		string	pset.comment 
&nbsp;
		cpu
			int	cpu.sys_id <span style="color: #000000;">1</span>
			string	cpu.comment
			string	cpu.status on-line
&nbsp;
		cpu
			int	cpu.sys_id <span style="color: #000000;"></span>
			string	cpu.comment
			string	cpu.status on-line
&nbsp;
	pset pset_default
		int	pset.sys_id <span style="color: #660033;">-1</span>
		boolean	pset.default <span style="color: #c20cb9; font-weight: bold;">true</span>
		uint	pset.min <span style="color: #000000;">1</span>
		uint	pset.max <span style="color: #000000;">65536</span>
		string	pset.units population
		uint	pset.load <span style="color: #000000;">562</span>
		uint	pset.size <span style="color: #000000;">2</span>
		string	pset.comment 
&nbsp;
		cpu
			int	cpu.sys_id <span style="color: #000000;">3</span>
			string	cpu.comment
			string	cpu.status on-line
&nbsp;
		cpu
			int	cpu.sys_id <span style="color: #000000;">2</span>
			string	cpu.comment
			string	cpu.status on-line</pre>
      </td>
    </tr>
  </table>
</div>

Nun kommen wir zum eigenlichen erstellen der Zone

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec zonecfg <span style="color: #660033;">-z</span> zone1
zone1: No such zone configured
Use <span style="color: #ff0000;">'create'</span> to begin configuring a new zone.
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> create
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">zonepath</span>=<span style="color: #000000; font-weight: bold;">/</span>export<span style="color: #000000; font-weight: bold;">/</span>zone<span style="color: #000000; font-weight: bold;">/</span>zone1
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">autoboot</span>=<span style="color: #c20cb9; font-weight: bold;">true</span>
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> add net
zonecfg:zone1:net<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">address</span>=192.168.1.10<span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">24</span>
zonecfg:zone1:net<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">physical</span>=rge0
zonecfg:zone1:net<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">defrouter</span>=192.168.1.1
zonecfg:zone1:net<span style="color: #000000; font-weight: bold;">&gt;</span> end
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">pool</span>=zone-pool
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> add capped-memory
zonecfg:zone1:capped-memory<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">physical</span>=200m
zonecfg:zone1:capped-memory<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">swap</span>=400m
zonecfg:zone1:capped-memory<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #000000; font-weight: bold;">set</span> <span style="color: #007800;">locked</span>=30m
zonecfg:zone1:capped-memory<span style="color: #000000; font-weight: bold;">&gt;</span> end
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> verify
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> commit
zonecfg:zone1<span style="color: #000000; font-weight: bold;">&gt;</span> <span style="color: #7a0874; font-weight: bold;">exit</span></pre>
      </td>
    </tr>
  </table>
</div>

Ich denke, dass sich alles von selbst erkl&auml;rt, wenn jedmand Fragen hat, dann bitte einen Kommentar bzw. die Manpage lesen. Als nächsten Schritt installieren wir die Zone und booten sie anschlie&szlig;end.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec zoneadm <span style="color: #660033;">-z</span> zone1 <span style="color: #c20cb9; font-weight: bold;">install</span>
A ZFS <span style="color: #c20cb9; font-weight: bold;">file</span> system has been created <span style="color: #000000; font-weight: bold;">for</span> this zone.
   Publisher: Using opensolaris.org <span style="color: #7a0874; font-weight: bold;">&#40;</span>http:<span style="color: #000000; font-weight: bold;">//</span>pkg.opensolaris.org<span style="color: #000000; font-weight: bold;">/</span>dev<span style="color: #000000; font-weight: bold;">/</span> <span style="color: #7a0874; font-weight: bold;">&#41;</span>.
   Publisher: Using pending <span style="color: #7a0874; font-weight: bold;">&#40;</span>http:<span style="color: #000000; font-weight: bold;">//</span>pkg.opensolaris.org<span style="color: #000000; font-weight: bold;">/</span>pending<span style="color: #000000; font-weight: bold;">/</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>.
   Publisher: Using contrib.opensolaris.org <span style="color: #7a0874; font-weight: bold;">&#40;</span>http:<span style="color: #000000; font-weight: bold;">//</span>pkg.opensolaris.org<span style="color: #000000; font-weight: bold;">/</span>contrib<span style="color: #000000; font-weight: bold;">/</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>.
       Image: Preparing at <span style="color: #000000; font-weight: bold;">/</span>export<span style="color: #000000; font-weight: bold;">/</span>zone<span style="color: #000000; font-weight: bold;">/</span>zone1<span style="color: #000000; font-weight: bold;">/</span>root.
       Cache: Using <span style="color: #000000; font-weight: bold;">/</span>var<span style="color: #000000; font-weight: bold;">/</span>pkg<span style="color: #000000; font-weight: bold;">/</span>download.
Sanity Check: Looking <span style="color: #000000; font-weight: bold;">for</span> <span style="color: #ff0000;">'entire'</span> incorporation.
  Installing: Core System <span style="color: #7a0874; font-weight: bold;">&#40;</span>output follows<span style="color: #7a0874; font-weight: bold;">&#41;</span>
DOWNLOAD                                  PKGS       FILES    XFER <span style="color: #7a0874; font-weight: bold;">&#40;</span>MB<span style="color: #7a0874; font-weight: bold;">&#41;</span>
Completed                                <span style="color: #000000;">44</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">44</span> <span style="color: #000000;">12305</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">12305</span>    <span style="color: #000000;">85.9</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">85.9</span> 
&nbsp;
PHASE                                        ACTIONS
Installationsphase                       <span style="color: #000000;">17833</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">17833</span>
Für dieses Abbild sind keine Updates erforderlich.
  Installing: Additional Packages <span style="color: #7a0874; font-weight: bold;">&#40;</span>output follows<span style="color: #7a0874; font-weight: bold;">&#41;</span>
DOWNLOAD                                  PKGS       FILES    XFER <span style="color: #7a0874; font-weight: bold;">&#40;</span>MB<span style="color: #7a0874; font-weight: bold;">&#41;</span>
Completed                                <span style="color: #000000;">36</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">36</span>   <span style="color: #000000;">3233</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">3233</span>    <span style="color: #000000;">20.6</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">20.6</span> 
&nbsp;
PHASE                                        ACTIONS
Installationsphase                         <span style="color: #000000;">4329</span><span style="color: #000000; font-weight: bold;">/</span><span style="color: #000000;">4329</span> 
&nbsp;
        Note: Man pages can be obtained by installing SUNWman
 Postinstall: Copying SMF seed repository ... done.
 Postinstall: Applying workarounds.
        Done: Installation completed <span style="color: #000000; font-weight: bold;">in</span> <span style="color: #000000;">606</span>,<span style="color: #000000;">736</span> seconds.
&nbsp;
  Next Steps: Boot the zone, <span style="color: #000000; font-weight: bold;">then</span> log into the zone console <span style="color: #7a0874; font-weight: bold;">&#40;</span>zlogin -C<span style="color: #7a0874; font-weight: bold;">&#41;</span>
              to <span style="color: #7a0874; font-weight: bold;">complete</span> the configuration process.</pre>
      </td>
    </tr>
  </table>
</div>

Die Geschwindigkeit zum erstellen der Zone h&auml;ngt von der Downloadgewindigkeit maßgeblich ab. Wenn man Pech hat, wartet man sehr lange auf die 100 MB&#8230;

Nachdem nun die Zone installiert ist m&uuml;ssen wir sie nur noch booten und initial konfigurieren

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec zoneadm <span style="color: #660033;">-z</span> zone1 boot
rennecke<span style="color: #000000; font-weight: bold;">@</span>walhalla ~ <span style="color: #000000; font-weight: bold;">%</span> pfexec zlogin <span style="color: #660033;">-C</span> zone1
<span style="color: #7a0874; font-weight: bold;">&#91;</span>Connected to zone <span style="color: #ff0000;">'zone1'</span> console<span style="color: #7a0874; font-weight: bold;">&#93;</span>
&nbsp;
You did not enter a selection.
What <span style="color: #7a0874; font-weight: bold;">type</span> of terminal are you using?
 <span style="color: #000000;">1</span><span style="color: #7a0874; font-weight: bold;">&#41;</span> ANSI Standard CRT
 <span style="color: #000000;">2</span><span style="color: #7a0874; font-weight: bold;">&#41;</span> DEC VT100
 <span style="color: #000000;">3</span><span style="color: #7a0874; font-weight: bold;">&#41;</span> PC Console
 <span style="color: #000000;">4</span><span style="color: #7a0874; font-weight: bold;">&#41;</span> Sun Command Tool
 <span style="color: #000000;">5</span><span style="color: #7a0874; font-weight: bold;">&#41;</span> Sun Workstation
 <span style="color: #000000;">6</span><span style="color: #7a0874; font-weight: bold;">&#41;</span> X Terminal Emulator <span style="color: #7a0874; font-weight: bold;">&#40;</span>xterms<span style="color: #7a0874; font-weight: bold;">&#41;</span>
 <span style="color: #000000;">7</span><span style="color: #7a0874; font-weight: bold;">&#41;</span> Other
Type the number of your choice and press Return: <span style="color: #000000;">2</span></pre>
      </td>
    </tr>
  </table>
</div>

Es ist sehr zu empfehlen f&uuml;r die Konfiguration ein VT100 Terminal zu nehmen. Das ich zwar nicht sch&ouml;n, aber man kann auj **jeder** Konsole ordentlich arbeiten, ohne das was verschoben wird.