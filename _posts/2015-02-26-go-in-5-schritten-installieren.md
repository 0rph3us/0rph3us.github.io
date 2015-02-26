---
layout: post
title: "go in 5 Schritten installieren"
description: ""
category:
 - programmieren
tags:
 - go
 - golang
 - debian
 - ubuntu
 - gvm
 - git
---
{% include JB/setup %}

Die Installation von [go] kann etwas tricky bei Debian und Ubuntu sein. Da die Versionen im Repository
veraltet sind. Manchmal ist es auch nötig mehrere Versionen der Programmierspache go parallel zu installieren.
Das ist mit Bordmitteln fast unmöglich.

Für diese Probleme gibt es Abhilfe: Den go Versionsmanager [gvm]. Ich gebe zu, dass das ganze etwas von einem
Rüttelskript hat, aber es funktioniert und ist nach meinen Wissen der einfachste Weg `go` zu installieren


### 1. clone das Repo in Dein home

``` sh
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
```

Diese Komandozeile lädt mit [curl] ein Skript herunter und lässt es von der [bash] ausführen. Dabei
der Inhalt vom git-Repository nach `~/.gvm` kopiert 

### 2. gvm in der shell verfügbar machen

``` sh
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
```

Die Zeile muss man in seine `~/.bashrc` bzw. `~/.zshrc` einfügen, damit die Umgebungsvariablen und Komandos
von gvm in der jeweiligen shell verfügbar sind. Nach Änderung ist es nötig eine neue Shell zu öffnen oder man
führt das Komando noch einmal in der aktuellen Shell aus.

### 3. nachsehen, ob gvm installiert ist

``` sh
$ gvm version
Go Version Manager v1.0.22 installed at /home/rennecke/.gvm
```

### 4. go (golang) installieren

``` sh
$ gvm listall

gvm gos (available` sh
...
   go1.4
   go1.4.1
   go1.4.2
...
```

Man sieht alle Versionen von `go` So installiert man eine spezifische `go` Version, z.B. 1.4.2. 
*Installieren* ist eigentlich der falsche Ausdruck, denn der neue go-Compiler wird compiliert,
d.h. es werden __keine__ Binärpakete heruntergeladen.

``` sh
$ gvm install go1.4.2
Downloading Go source...
Installing go1.4...
* Compiling...
```

### 5. gvm mitteilen, welche Version von go man nutzen möchte

``` sh
$ gvm use go1.4.2
Now using version go1.4.2
```

Nun kann noch nachsehen, welche Version `go` hat.

``` sh
$ go version
go version go1.4.2 linux/amd64
```


[go]: https://golang.org/
[gvm]: https://github.com/moovweb/gvm
[curl]: http://curl.haxx.se/
[bash]: http://www.gnu.org/software/bash/
