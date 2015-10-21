+++
title    = "Linux-Spickzettel"
nodate   = true
nopaging = true
+++


### MD5SUM eines Verzeichnisses bestimmen

    find /tmp -type f -exec md5sum {} \; | sort | md5sum

### Systemmail-Verteiler
    vim /etc/aliases
    newaliases

### Alle Abhänigkeiten eines go-Projektes rekursiv holen und updaten
``` sh
go get -u ./...
```


### golang cross kompilieren
Für den Raspberry Pi 2 sieht es wie folgt aus:
``` sh
env GOOS=linux GOARCH=arm GOARM=7 go build  main.go
```

### journalctl als nicht root ausführen
``` sh
usermod -a -G systemd-journal rennecke
```
