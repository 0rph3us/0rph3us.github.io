---
layout: post
title: Sensoren mit Nagios abfragen
date: 2009-09-10
categories:
- Solaris
tags:
- nagios
- Solaris
- Sparc
status: publish
type: post
---
Ich wollte verschiedene Sparc-Rechner mit [Nagios](http://www.nagios.org/) überwachen.
Da ich kein passendes Plugin gefunden habe um die Sensoren zu überwachen habe ich mir selbst eins geschrieben.

Es funktioniert ganz gut, wenn jemand Probleme mit dem Plugin hat, dann kann ich versuchen es zu verbessern.
Man kann das [Plugin auch hier](http://blogs.sun.com/rennecke/resource/stuff/check_solaris_sensors) herunter laden.
Ich parse die Ausgabe von `prtpicl`. Wenn die Temperatur __HighWarningThreshold  $warn__ übersteigt, dann wird
warning zurück gegeben. Wenn __HighWarningThreshold__ überschritten wird, dann gibt das Plugin critical zurück.

~~~perl
#!/usr/bin/perl -w

# File:    check_solaris_sensors
# Purpose: prtpicl output parser
# Author:  Michael Rennecke michael.rennecke@sun.com
# Date:    2009/07/08
# Version: 0.2

use strict;

my $warn        = 15;
my $prtpicl     = "/usr/sbin/prtpicl";
my @diag        = ();
my @sensor_data = ();
my $state       = 0;
my $output      = "";

unless(open(DIAG, "$prtpicl -v -c temperature-sensor | ")) {
    print STDERR "Initialization error - Can't execute  $prtpicl -v -c temperature-sensor!\n";
    exit(3);
}

while(){
    push(@diag, $_);
}
close(DIAG);

unless( @diag &gt; 0) {
    print STDERR "Can't find any temperature-sensor!\n";
    exit(3);
}

sub change_state {
    if ($_[0] &gt; $state) {
        $state = $_[0];
    }
}

my $sensor      = undef;
my $warning     = undef;
my $critical    = undef;
my $temperature = undef;
my $get_temp    = 0;

foreach my $line (@diag) {

    $get_temp = 0;

    if ($line =~ /\s*([a-zA-Z0-9_]+)\s*\(temperature-sensor/) {
        $sensor = $1;
    } elsif ($line =~ /:HighWarningThreshold\s*(\d+)/) {
        $warning = $1;
    } elsif ($line =~ /:Temperature\s*(\d+)/) {
        $temperature = $1;
        $get_temp = 1;
    }

    if ($get_temp == 1) {
        if ($temperature &lt;= $warning - $warn) {
            &amp;change_state(0);
        } elsif ($temperature &lt;= $warning) {
            &amp;change_state(1);
        } else {
            &amp;change_state(2);
        }
    $output = "$output $sensor: ${temperature}°C ";
    }

}

if ($state == 0) {
    $output = "Temperature OK --$output \n";
} elsif ($state == 1) {
    $output = "Temperature WARNING --$output \n";
} elsif ($state == 2) {
    $output = "Temperature CRITICAL --$output \n";
} else {
    $output = "Temperature UNKNOWN --$output \n";
}

print STDOUT "$output";
exit ($state);
~~~
