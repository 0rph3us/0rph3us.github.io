+++
title = "Sicherheitslücke in CDNs"
date = "2017-07-27T21:28:03+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["security"]
categories = ["privat"]
+++

Auf golem.de habe ich heute den Beitrag [Caches von CDN-Netzwerken führen zu Datenleck] gelesen.
Ich finde diesen Beitrag oberflächlich und falsch.

Das CDN-Anbieter, wie Akamei die Cache-Header ignorieren ist ein Feature. Wenn man ein CDN einsetzt,
dann möchte man in der Regel _keinen_ transparenten Cache haben. Ein transparenter Cache **muss** die
Cache-Header beachten.

## Beipiele

Die folgenden Beispiele sind etwas an konstruiert, aber ich kenne alle aufgeführten Beispiele
(und noch mehr) aus meiner beruflichen Praxis. 

### Mehrere Top-Level-Domains
Klaus hat ein erfolgreiches E-Commerce Portal. Damit er seine Kunden in den verschiedenen Ländern
besser anspricht, gehört es zu seiner Strategie, dass er jeweils die Top-Level-Domain des jeweiligen
Landes nutzt. Das Portal nutzt für jede Top-Level-Domain das identische CSS, JavaScript und Bilder.

Wenn man klassisch die Cache-Header betrachtet, dann sind `https://klaus.de/main.css`, 
`https://klaus.com/main.css` und `https://klaus.fr/main.css` 3 verschiedene Ressourcen,
obwohl sie identisch sind. Aus diesem Grund ist des durchaus clever den CDN zu sagen, dass `main.css`
für alle Domains identisch ist. Dann spart Klaus Traffic, da der CDN-Anbieter nur einmal `main.css`
anfragen muss und das CDN spart auch Traffic, da eine Cache-Node `main.css` für Frankreich und Deutschland
ausliefern kann.


### Eigene Brandbreite sparen
Peter hat einen sehr erfolgreichen Blog mit einer extrem hohen Reichweite. Aus den verschiedensten Gründen
kann und möchte er nicht den Content direkt ausliefern. Also nutzt er ein CDN. Damit er fast keinen Traffic
bekommt sagt er den CDN, dass _alle_ Inhalte eine Woche gecacht werden dürfen, aber beim Endnutzer sollen
sie nicht gecacht werden.

Wenn Peter seine Inhalte ändern, dann gibt er dem CDN Be­scheid, dass bestimmte Inhalte invalidiert werden
sollen. Anschließend holt sich das CDN die neuen Inhalte von Peter. Die Leser bekommen davon nichts mit,
ihr Browser holt sich immer die neusten Inhalte vom CDN. Denn auf die Browser-Caches der Leser hat Peter
begrenzten Zugriff.


### Verfügbarkeit erhöhen
Ulf hat einen stark frequentierten Webshop. Dabei kann es durchaus vorkommen, dass sein Frontend
zusammenbricht oder nicht mehr alle Ressourcen ausliefern kann. Ein vorgelagertes CDN liefert die
entsprechenden Inhalte auch noch aus, wenn sie bei ihm fehlen. Sein Checkout hat kein Lastproblem,
da in der Regel ca. 4% der Besucher nur etwas kaufen


### Unwissende Entwickler
Karl hat inzwischen eine recht große Entwicklungsabteilung. Der Nachteil ist, dass viele Entwickler
nicht wissen, wie ihr Code beim Kunden ankommt und wie die Komponenten zusammen arbeiten. Dadurch
passiert es, dass meistens gar keine Cache-Header implementiert sind. Die fehlenden oder falschen
Header setzen seine Admins im CDN die passenden Header, weil es dort ein schönes Frontend gibt.


## Zusammenfassung
Der beschriebene Fehler ist in meinen Augen durchaus kritisch. Die CDN Anbieter sind begrenzt dafür
zuständig. Bei ihnen bekommt man einen großen Werkzeugkasten bekommt, den man **richtig** benutzen
muss. Derartige Fehler **müssen** in den Webanwendungen behoben werden und nicht im CDN.

### Anmerkung
Ich werde von keinen CDN Anbieter bezahlt ;-) Ich weiß aber, wie viel ich mit [HAProxy] und [Varnish]
_repariert_ habe... Die selben Dinge kann man auch mit vielen CDNs machen.


[HAProxy]: http://www.haproxy.org/
[Varnish]: https://varnish-cache.org/
[Caches von CDN-Netzwerken führen zu Datenleck]: https://www.golem.de/news/sicherheitsluecke-caches-von-cdn-netzwerken-fuehren-zu-datenleck-1707-129148.html
