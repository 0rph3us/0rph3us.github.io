---
layout: post
title: "Pakete selbst bauen"
description: ""
category:
 - 'linux'
tags:
 - 'deb'
 - 'fpm'
 - 'paket'
---
{% include JB/setup %}

[binfalse] hat mich dazu gebracht diesen Artiel zu schreiben. Die verschiedenen Paketformate der Linux-Distrubutionen können Softwareentwickler vor Probleme stellen, die ihre Software leicht installierbar gestalten möchten. Debian und Ubuntu setzen auf [deb]-Pakete während RedHat und Fedora auf [rpm]-Pakete setzen. Diese beiden Fromate nicht nicht kompartibel zueinander. Die Werkzeuge, um die Pakte zu erstellen können viele als unnötig kompliziert befinden. Das schreckt ab, wenn man das Paket nur für sich oder für eine kleine Gruppe von Nutzern baut. Es ist auch durchaus sinnvoll __Sktripte__ zu paketetieren, da sich die Paketverwaltung um die Anhänigkeiten kümmern kann.

Um unnötige Komplikationen zu vermeiden, gibt es Tool [fpm]. Es kann unter anderm deb- und rpm-Pakete erstellen. fpm ist in [ruby] geschrieben. Aus diesem Grund muss man etwas Vorarbeit leisten.

### Installation von fpm unter Ubuntu/Debian

``` sh
sudo apt-get update
sudo apt-get install ruby-dev build-essential
sudo gem install fpm
```

Wenn das [gem] `fpm` installiert ist, dann gibt es den Befehl `fpm` im `PATH`. Man kann das ganze wie folgt testen:

``` sh
fpm -h
Intro:

  This is fpm version 1.3.3

  If you think something is wrong, it's probably a bug! :)
  Please file these here: https://github.com/jordansissel/fpm/issues

  You can find support on irc (#fpm on freenode irc) or via email with
  fpm-users@googlegroups.com

Usage:
    fpm [OPTIONS] [ARGS] ...

...
```

Nun kann man anfangen Pakte zu bauen. Ein Aufruf sieht im einfachsten Fall so aus: `fpm -s source_type -t target_type  source_name_or_location` Der __source_type__ bzw. __target_type__ können die verschiedensten Paketformate sein. Einige Pakettype benötigen Hilfsprogramme, damit `fpm` sie erstellen kann. Da ich annehme, dass `fpm` auf einen Debian bzw. Ubuntu benutzt wird, zeige ich im folgenden Beispiel wie man aus einen [ruby] [gem] ein deb-Paket baut.

``` sh
fpm -s gem -t deb bundler
Erstellt package {: path => "rubygem-bundler_1.6.5_all.deb"}
```

Es wird die Datei `rubygem-bundler_1.6.5_all.deb` im aktuellen Verzeichnis erstellt. (Ihre Versionsnummer kann abweichen). Diese kann man dann ganz einfach installieren (oder zu einen Repository hinzufügen).

``` sh
sudo dpkg -i rubygem-bundler_1.6.5_all.de
```

Wenn die Quelle ein __Standart Reporitory__ wie [rubygems.org] für ruby gems  oder  [npm] für [nodejs] Pakete, dann ist fpm in der Lage automatisch alle benötigten Dateien herunterzuladen.

Es ist auch sehr einfach möglich fremde Software zu packen, welche man compilieren muss. Im Allgemeinen sieht das wie folgt aus:

``` sh
# Vorbereitung
mkdir ~/build
cd ~/build
git clone https://github.com/cool/cool-app
cd cool-app

# bauen
make
mkdir -p /tmp/cool-app 
make install DESTDIR=/tmp/cool-app
fpm -s -t dir deb -C /tmp/cool-app \
  --name cool-app-name \
  --version 1.0.0 \
  --iteration 1 \
  --depends "Abhänigkeit 1 (>= 2.0.0)" \
  --depends "Abhänigkeit 2" \
  --description "Ein Beispielpaket" \
 .

fpm -s -t dir rpm -C /tmp/cool-app \
  --name cool-app-name \
  --version 1.0.0 \
  --iteration 1 \
  --depends "Abhänigkeit 1 (>= 2.0.0)" \
  --depends "Abhänigkeit 2" \
  --description "Ein Beispielpaket" \
  .
```

Man erhält dann im aktuellen Verzeichnis ein `rpm`- und ein `deb`-Paket. So kann man einfach und schnell Pakete für das eigene System bauen oder für andere, wenn man z.B. selbst Software bereit stellt. Man kann auch statt des `.` am Ende des `fpm`-Komandos sagt, dass der gesamte Inhalt von unter `/tmp/cool-app` in das Paket soll. Man kann/sollte auch die Vezeichnisse einzeln angeben z.B. `etc/cool-app usr/bin usr/share/man`.



#### Sources
* __gem__ ruby-gem (automatischer Download)
* __python__ [python]-Module, welche `easy_install` unterstützen (automatischer Download)
* __pear__ [php]-Module (automatischer Download von [pear.php.net])
* __dir__ Verzeichnis
* __tar__ [tar]-Archiv
* __pear__ php-Module (automatischer Download)
* __rpm__ [rpm]-Paket
* __deb__ deb-Paket
* __zip__ [zip]-Archiv
* __empty__ erzeugt ein leeres Paket, welches man oft für Metapakte benutzt
* __npm__ nodejs Module (automaticher Download)
* __cpan__ peal-Module (automatischer Download)
* __osxpkg__ Mac OS X Pakete (nur auf Mac verfügbar)

#### Targets
* __deb__
* __rpm__
* __zip__
* __tar__
* __dir__
* __sh__ (selbst entpackendes Shell skript, welches ein [bzip2] gepacktes tar enthält)
* __osxpkg__ (nur auf Mac verfügbar)
* __solaris__ Solaris Pakete (nur auf Solaris möglich)
* __pkgin__ BSD pakete (nur auf BSD möglich)
* __puppet__ ([puppet]-Modul, aktuell noch nicht implementiert)


[binfalse]: http://binfalse.de/
[fpm]:https://github.com/jordansissel/fpm/wiki
[deb]: http://de.wikipedia.org/wiki/Debian-Paket
[rpm]: http://de.wikipedia.org/wiki/RPM_Package_Manager
[ruby]: https://www.ruby-lang.org/de/
[gem]: http://guides.rubygems.org/what-is-a-gem/
[rubygems.org]: https://rubygems.org/
[npm]: https://www.npmjs.com/
[nodejs]: http://nodejs.org/
[puppet]: http://puppetlabs.com/puppet/what-is-puppet
[tar]: http://de.wikipedia.org/wiki/Tar
[zip]: http://de.wikipedia.org/wiki/ZIP-Dateiformat
[python]: https://www.python.org/
[php]: http://php.net/
[pear.php.net]: http://pear.php.net/
[bzip2]: http://www.bzip.org/
