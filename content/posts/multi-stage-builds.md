+++
title = "Multi-Stage-Build mit Docker"
date = "2017-08-07T09:31:44+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["golang", "Docker", "deployment"]
categories = ["Docker"]
+++

Wenn man [Docker] nutzt, möchte man gerne kleine Images haben. Durch die Nutzung
von kleineren Images spart man Netzwerklast beim *PUSH* und *PULL*. Ein weiterer
offensichtlicher Vorteil ist das Sparen von Festplattenplatz. Ein kleines Image
kann auch sicherer sein, da der mögliche Angriffsvektor kleiner wird, wenn man keine
zusätzlichen Tools, Compiler oder Laufzeitumgebungen im Image hat.


Bis jetzt war es realtiv schwierig kleine Images mit Docker zu bauen. Da es nicht
möglich ist, ein einmal erzeugten Layer wieder los zu werden. Um das Problem zu
lösen wurde mit Docker Version 17.05 ein Feature mit dem Namen Multi-Stage-Build
eingeführt. Damit ist es möglich mehrere Stages innerhalb eines Dockerfiles zu 
definieren und Projektdateien von einer Stage zur nächsten zu kopieren. Zusammen 
mit der Möglichkeit in jeder Stage ein anderes Image als Basis zu nutzen, ergibt
sich dadurch die Möglichkeit die Abhängigkeiten, die es zum Kompilieren/Bauen
benötigt, von den Abhängigkeiten, die es zur Laufzeit braucht, zu trennen.


## Was heißt das?

Als Beispiel nehmen wir einmal ein kleines Web-Projekt. Dieses hat ein Frontend
bestehend aus HTML, Javascript, CSS und Bildern. Die eigentliche Anwendung ist
in Java geschrieben. Ein Webserver liefert die Assets[^1] und leitet die Anfragen
auf die Java-Anwendung weiter.

Das CSS wird mit einen Präprozessor wie [Sass] gebaut. Einige Bilder
werden evtl. zu [Sprites] zusammengefasst und ein anderer Workflow minimiert
Bilder, HTML und JavaScript. So holt man sich NodeJS in das Image, welches
für die laufende Anwendung gar nicht benötigt wird.
Damit man das Backend bauen kann, benötigt man Build-Management-Tool, wie [Maven]
und das komplette JDK[^2]. Am Ende des Build-Prozess liegt eine fat JAR[^3] vor.
Weiterhin benötigt man eine Versionskontrolle, wie git, um den Quellcode
auszuchecken.

Die laufende Anwendung benötigt zum Schluss nur einen Nginx, JRE[^4], die JAR sowie
die Assets. Das ist viel weniger als die komplette Build-Umgebung mit ihren ganzen
temporären Output.


## Beispiel

Im folgenden sieht man, wie ein kleines Image für eine go Anwendung gebaut wird. 

```
REPOSITORY   TAG         IMAGE ID        CREATED          SIZE
go-carbon    latest      c03b2725b270    3 seconds ago    16MB
<none>       <none>      7dfec15cda13    7 seconds ago    346MB
golang       1.8-alpine  310e63753884    5 weeks ago      257MB
alpine       latest      7328f6f8b418    5 weeks ago      3.97MB
```

Das *golang:1.8-alpine*-Image basiert auf alpine-Linux und ist schon 257MB groß. Ein 
Images, welches die Anwendung und die gesamte Build-Umgebung enthält ist 346MB groß.
Das Ziel-Image benötigt nur 16MB. Das ist eine große Ersparnis.


### Dockerfile
```
# Stage: Build
FROM golang:1.8-alpine as builder

ENV VERSION=v0.10.1

RUN set -x \
    && apk --update add git make

# get Code
RUN set -x \
    && mkdir -p /go/src \
    && cd /go/src \
    && git clone https://github.com/lomik/go-carbon.git

# build go-carbon
WORKDIR /go/src/go-carbon
RUN git checkout ${VERSION}
RUN make submodules
RUN make


# Stage: Run
FROM alpine

COPY --from=builder /go/src/go-carbon/go-carbon /sbin/

EXPOSE 2003 2004 7002 7007 2003/udp
ENTRYPOINT [ "/sbin/go-carbon" ]
```

Das Dockerfile enthält 2 Stages. Im *Build*-Stage wird die Anwendung gebaut und in der
*Run*-Stage wird das Ziel-Image gebaut. Die erste Stage basiert auf dem Image 
*golang:1.8-alpine* und wird *builder* genannt. Im folgenden wir die Variable *VERSION*
gesetzt und noch 2 Pakete installiert. Nach dem auschecken vom Code wird die Anwendung
gebaut. Nach dem Bau beginnt die *Run*-Stage. Die bastiert auf dem alpine-Image. Die
Anweisung `COPY --from=builder /go/src/go-carbon/go-carbon /sbin/` kopiert das Binary
*go-carbon* von der *Build*-Stage in die *Run*-Stage. Ein derartiges Dockerfile kann man
ganz normal mit `docker build` bauen.


## Anmerkung

Ich persönlich finde Multi-Stage-Builds echt super. Das Feature schon von [Rocker] und ich
habe überlegt auf Rocker umzusteigen. Zum Glück gibt es das jetzt auch für Docker :-)

Man sollte vielleicht nicht auf Krampf Multi-Stage-Builds einzuführen, insbesondere wenn
man mit Docker nocht nicht so vertraut ist. Deswegen ist meine Empfehlung sich zuerst die
[Best Practices] von Docker umzusetzten und anschließend kann man Multi-Stage-Builds in
Angriff nehmen.


## Erklärungen

### Netzwerklast

Wenn das eigene Netzwerk nur 1 GBit/s Bandbreite hat, dann benötigt man zum übertragen
eines 1 GB großen Images min. 10 Sekunden. Während dieser Zeit hat man evtl. eine
spürbar größere Latenz bei laufenden Anwendungen bzw. deren Bandbreite sinkt. Bei
Servern verbaut man heutzutage meisten 10 GBit/s und schneller, da fällt ein einzelnes
Images weniger ins Gewicht. Wenn aber 20 Knoten in einem Cluster zeitgleich[^5] Images
haben wollen, wird die Bandbreite bei der Registry zum Problem. 

## Festplattenplatz

Wenn man schnelles IO möchte, greift man zu SSDs. Diese sind pro GByte sehr viel teurer
als Festplatten. Aus diesem Grund ist es durchaus ein Unterschied, ob die Images ein
Faktor 10 größer oder kleiner sind.


[Best Practices]: https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
[Docker]: https://www.docker.com/what-docker
[Rocker]: https://github.com/grammarly/rocker
[Sprites]: https://de.wikipedia.org/wiki/CSS-Sprites
[Maven]: https://maven.apache.org/
[Sass]: http://sass-lang.com/
[^1]: statische Dateien einer Webanwendung
[^2]: Java Development Kit - Laufzeitumgebung für Java inklusive aller Entwicklungswerkzeuge
[^3]: JAR Datei, welche alle Abhänigkeiten enthält.
[^4]: Java Runtime Environment - Laufzeitumgebung für Java
[^5]: Ausrollen einer neuen Version