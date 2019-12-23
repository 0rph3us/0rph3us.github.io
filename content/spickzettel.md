+++
title    = "Linux-Spickzettel"
nodate   = true
nopaging = true
+++


## MD5SUM eines Verzeichnisses bestimmen

{{< highlight sh >}}
find /tmp -type f -exec md5sum {} \; | sort | md5sum
{{< /highlight >}}

## Systemmail-Verteiler

{{< highlight sh >}}
vim /etc/aliases
newaliases
{{< /highlight >}}

## Alle Abhänigkeiten eines go-Projektes rekursiv holen und updaten

{{< highlight sh >}}
go get -u ./...
{{< /highlight >}}

## golang cross kompilieren

Für den Raspberry Pi 2 sieht es wie folgt aus:

{{< highlight sh >}}
env GOOS=linux GOARCH=arm GOARM=7 go build  main.go
{{< /highlight >}}

## journalctl als nicht root ausführen

{{< highlight sh >}}
usermod -a -G systemd-journal rennecke
{{< /highlight >}}

## parallel packen

Alle Varianten nutzen automatisch alle Kerne. Man kann die Anzahl auch explizit angeben.

{{< highlight sh >}}
tar cf - . | pigz -9 > ~/backup.tar.gz
tar cf - . | pxz -9 > ~/backup.tar.xz
tar cf - . | pbzip2 -9 > ~/backup.tar.bz2
{{< /highlight >}}
