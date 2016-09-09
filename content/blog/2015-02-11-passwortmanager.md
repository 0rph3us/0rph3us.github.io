---
type: post
title: "Passwortmanager"
date: 2015-02-11
description: ""
categories:
 - 'sicherheit'
tags:
 - 'Security'
 - 'linux'
 - 'GnuPG'
 - 'git'
  
---

Jeder kennt das Problem mit dem Passwörtern. Man sollte nicht überall das selbe Passwort verwenden,
außerdem sollte man es regelmäßig wechseln und dann muss es auch noch _komplex_ sein. Da ich mir
nicht 100 Passwörter merken kann, verwende ich einen Passwortmanager. Es gibt eine ganze Reihe
von solchen Tools, aber keins hat mich mich bis überzeugt.

### Meine Anforderungen sind
- einfach zu bedienen
- einfache synchronisation zwischen mehreren Geräten
- leichtgewichtig
- eine GUI ist nicht nötig
- Windowsunterstützung ist mir egal, da ich kein Windows nutze

[KeePass 2] würde meine meisten Anforderungen erfüllen. Aber ich werde mit dem Tool nicht wirklich warm. Ich finde auch, dass 
es recht schwergewichtig ist, weil ich dafür noch [Mono] benötige, was ich sonst nicht auf meinen Rechnern habe. 


## pass - Der Standard Unix Passwortmanager

Nachdem ich [pass] gefunden habe, war ich glücklich. Dieser Passwortmanager hat alles was ich verlange. 
Das schöne ist, dass pass auf Standarttools setzt. Die Daten werden mit [GnuPG] verschlüsselt und bei Bedarf
in einen [git]-Repository versioniert. Durch die Verwendung von git ist es auch möglich die Passwörter über
verschiedene Clients hinweg zu sychronisieren. 

Man kann [pass] über die Paketverwaltung der meisten Distributionen installieren. Es ist auch ohne weiteres
möglich pass via git checkout zu installieren. Das geht deswegen so einfach, weil pass _nur_ ein Shell-Skript
ist, welches einige Standarttools sowie GnuPG und git nutzt.


### Anwendung

``` sh
pass init EE75C6FE
mkdir: created directory ‘/home/rennecke/.password-store’
Password store initialized for EE75C6FE Password Storage Key.
```

Es wird eine leere Passwortdatenbank erstellt und zum verschküsseln der Passwörter wird der GnuPG Key `EE75C6FE`
verwenden. Man kann den Key auch mit der dazugehörigen Emailadresse angeben.

```
pass git init 
Initialized empty Git repository in /home/rennecke/.password-store/.git/ 
[master (root-commit) 998c8fd] Added current contents of password store. 
1 file changed, 1 insertion(+) 
create mode 100644 .gpg-id
```

Jetzt wird noch leere Passwortdatenbank unter Versionskontrolle genommen. Nun kann alle Möglichkeiten
von git nutzen. Die `<parameter>` von `pass git <parameter>` sind alle möglichen Parameter, welche git
aktzeptiert, `pass` alles was nach git kommt 1:1 an `git` weiter.

An dieser Stelle möchte ich nicht die Dokumentation von pass abschreiben, da ich es auch recht intuitiv finde. Man
kann sich [hier] einen Überblick verschaffen.


### Android App

Für alle Android-Nutzer gibt es noch ein richtiges Sahnestück, die App [Password Store]. Sie überzeugt mich, durch ein
gutes Bedienkonzept und sie kann alle Funktionen von pass nutzen. Sie unterstützt auch mit einem Passwort gesicherte 
ssh-Schlüssel. Zur Verwaltung der GnuPG-Schlüssel nutzte ich [OpenKeychain]. OpenKeychain unterstüzt selbstverständlich
auch mit einem Passwort gesicherte private Schlüssel.


### Nachtrag

Wie ihr im letzten Absatz bemerkt habt, muss ich mir trotzdem 2 Passwörter merken und bei KeyPass 2 ist es nur ein Passwort.
Das ist aber kein Nachteil in meinen Augen. Jeder der ssh- und GnuPG-Schlüssel nutzt sollte sie mit einen Passwort sichern,
falls das Gerät, auf dem sich der Schlüssel befindet kompromitiert wird. Die Passwörter muss man sich einfach merken, wenn 
man täglich diese Schlüssel nutzt.


[KeePass 2]: http://keepass.info/
[Mono]: http://www.mono-project.com/
[pass]: http://www.passwordstore.org/
[GnuPG]: https://www.gnupg.org/
[git]: http://git-scm.com/
[hier]: http://git.zx2c4.com/password-store/about/#EXTENDED%20GIT%20EXAMPLE
[Password Store]: https://github.com/zeapo/Android-Password-Store
[OpenKeychain]: http://www.openkeychain.org/
