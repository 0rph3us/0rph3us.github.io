+++
title    = "Linux-Spickzettel"
nodate   = true
nopaging = true
+++


## MD5SUM eines Verzeichnisses bestimmen

```shell
find /tmp -type f -exec md5sum {} \; | sort | md5sum
```

## Systemmail-Verteiler

```shell
vim /etc/aliases
newaliases
```

## Alle Abhänigkeiten eines go-Projektes rekursiv holen und updaten

```shell
go get -u ./...
```

## golang cross kompilieren

Für den Raspberry Pi 2 sieht es wie folgt aus:

```shell
env GOOS=linux GOARCH=arm GOARM=7 go build  main.go
```

## journalctl als nicht root ausführen

```shell
usermod -a -G systemd-journal rennecke
```

## parallel packen

Alle Varianten nutzen automatisch alle Kerne. Man kann die Anzahl auch explizit angeben.

```shell
tar cf - . | pigz -9 > ~/backup.tar.gz
tar cf - . | pxz -9 > ~/backup.tar.xz
tar cf - . | pbzip2 -9 > ~/backup.tar.bz2
```

## Geodaten von jpg-Dateien entfernen

```shell
exiftool -gps:all= -xmp:geotag= *.jpg
```
