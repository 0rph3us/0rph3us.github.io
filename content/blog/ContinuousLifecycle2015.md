+++
Categories = ["privat"]
Description = ""
Tags = ["Deployment", "docker"]
date = "2015-11-13T07:21:17+01:00"
title = "Continuous Lifecycle 2015"
type = "post"

+++

Ich war vom 10.11. bis 12.11.2015 auf der Continuous Lifecycle
in Mannheim. Die Konferenz hat sich rund um das Thema Continuous
Delivery gedreht, weiterhin war [Docker] in aller Munde. Durch
die Konferenz wurde mir gezeigt, dass Docker inzwischen/langsam 
reif für den produktiven Betrieb ist. 

Damit Continuous Delivery funktioniert nutzen viele interdisziplinäre
Teams. Dabei hat das einzelne Team in der Regel viele Freiheiten,
aber es gibt auch unumstößliche Regeln. Die folgenden Dinge habe ich
oft gehört und die Reihenfolge ist willkürlich gewählt.

 - der gesamte Code ist in einem Repo und alle arbeiten auf einen Branch
 - es gibt ein einheitliches Logging und Monitoring
 - Entwickler sind für den Betrieb der Software verantwortlich
 - der Betrieb (Admins) sitzt bei den Entwicklern und es gibt keine wirkliche Unterscheidung
 - kleine Teams
 - wenige bis gar keine Schnittstellen zwischen den Teams
 - gute automatische Tests

Sehr beeindruckend fand ich den Vortrag von [GameDuell]. Sie machen Continuous Delivery
mit [GlassFish]. Jeder der GlassFish kennt, weiß wie schwerfällig sich
dieser Application Server anfühlt. Dieser Talk hat mir sehr deutlich gemacht,
dass man seine Werkzeuge nur richtig nutzen muss, um innovative
Dinge zu machen[^1].

In der nächsten Zeit werde mir privat und beruflich Docker genauer
ansehen. Da ich definitiv auf tolle Technologien stehe. 



[^1]: Innovativ ist für mich die Art, wie GameDuell entwickelt und Software ausrollt. Wie innovativ das Angebot von GameDuell ist, kann und möchte ich nicht einschätzen ;-)
[Docker]: https://docker.com
[GlassFish]: https://glassfish.java.net/
[GameDuell]: http://www.gameduell.de/
