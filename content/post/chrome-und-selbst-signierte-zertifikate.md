---
type: post
title: "Chrome und selbst signierte Zertifikate"
date: 2014-08-29
description: ""
categories: 
  - Sicherheit
  - privat
tags:
  - Chrome
  - SSL
  - Zertifikat
---


Heute habe ich festgestellt, dass Google den [Chrome]-Browser (Version 37.0.2062.94 (64-Bit)) 
verhunzt hat. Es gibt jetzt einen **Privacy Error** wenn eine Seite, wie dieser Blog, 
ein selbst signiertes SSL-Zertifikat benutzt. Bis jetzt gab es einen **SSL Error**


## Chromium ##

    The site's security certificate is not trusted!
    
    You attempted to reach blog.rennecke.dyndns.dk, but the server presented a certificate
    issued by an entity that is not trusted by your computer's operating system. This may 
    mean that the server has generated its own security credentials, which Chromium cannot 
    rely on for identity information, or an attacker may be trying to intercept your communications.
    
    You should not proceed, especially if you have never seen this warning before for this site.
    
    Proceed anyway       Back to safety



## Chome jetzt ##

    Your connection is not private
    
    Attackers might be trying to steal your information from blog.rennecke.dyndns.dk 
    (for example, passwords, messages, or credit cards).

    advanced    Back to safety


Diese Meldung finde ich unter aller Sau! Verdient Google auch an den Zertifikatverkäufen oder weswegen
muss der Hinweis so drastisch ausfallen, dass ein nicht technikaffiner Nutzer nicht mehr auf meinen
Blog kommt? Erst wenn man *advanced* ausklappt hat man die Möglichkeit auf die Seit zu kommen. In
Zeiten von Abhörskandalen darf man nicht selbst signierte Zertifikate boykottieren. So wächst nur
die Hemmschwelle SSL einzusetzen.




[Chrome]: http://www.google.de/intl/de/chrome/browser/
