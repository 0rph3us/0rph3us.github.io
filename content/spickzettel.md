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
