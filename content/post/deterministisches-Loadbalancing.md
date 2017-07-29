+++
Categories = ["Tools", "Infrastruktur"]
Description = ""
Tags = ["HAProxy", "Loadbalancing"]
date = "2015-09-17T05:58:20+02:00"
title = "Deterministisches Loadbalancing"
type = "post"

+++

Beim Loadbalancing verteilet ein Loadbalancer, wie HAProxy die Last auf mehrere Server. In vielen Fällen macht man das Roud-Robin oder nach Last. Es ergibt auch durchaus Sinn nach einer ID die Backendserver auszuwählen. Daraus ergeben sich zwei Vorteile. Zum einen kann es für Backendserver besser sein, wenn die selbe ID immer auf den selben Server kommt. Dadurch können interene Caches evtl. besser ausgenutzt werden. Da eine ID immer einen Server zugeordnet ist, wird das Loadbalancing deterministisch. Das hat den unschätzbaren Vorteil, dass z.B. eine Anfrage die fehl schlägt immer fehl schlägt.

Bei meinen Arbeitgeber hatten wir das Problem, dass bestimmte URLs konsequent nicht gehen. Bei einen naiven Test hat der Entwickler festgestellt, dass sein Dienst auf die URL korrekt antwortet. Durch meinen Test der Proxykonfiguration konnte ich ausschließen, dass das Routing im HAProxy Schuld am Fehlverhalten ist. Da dieser Dienst mit einer konsistenten Hashfunktion deterministisch geroutet wird, trat der Fehler immer auf. Dabei stellte sich heraus, dass eine Instanz nicht in der richtigen Version[^1] lief.

Da Fehler immer wieder vorgekommen, ist es wichtig sie schnell und zuverlässig zu beseitigen. In solchen Situationen ist es besser, den Fehler **immer** zu haben, anstatt bei jeder x-ten Anfrage.


## Umsetzung von deterministischen Loadbalancing

Mein favorisierter Loadbalancer für HTTP ist [HAProxy]. Ich hatte die Anforderung nach einer ID, welche im Path der URL steht zu balancen. Das ist nicht ganz offensichtlich mit HAProxy. Meine Umsetzung sieht wie folgt aus:

```
backend Webserver
        balance hdr(X-MyID)
        hash-type consistent

        http-request set-header     X-MyID %[url]
        http-request replace-header X-MyID ^/foo/bar/lol/([0-9]{5,5}).* \1
        http-request replace-header X-MyID ^/foo/barbar/([0-9]{5,5}).* \1

        server webserver1 10.0.0.1:80
        server webserver2 10.0.0.2:80
        server webserver3 10.0.0.3:80
        server webserver4 10.0.0.4:80
```

Als erstes wird die URL in den Header **X-MyID** kopiert. Die folgenden regulären Ausdrücke schmeißen alles weg, außer die 5-stellige ID. Falls keiner der beiden Ausdrücke angewendet werden kann, steht die URL noch im Header. Dann wird diese als Kriterium für die Verteilung genommen. Der `hash-type consistent` bei HAProxy verteilt die Anfragen auf die anderen Server, falls ein Server aus dem Loadbalancing geht.

[HAProxy]: http://www.haproxy.org/
[^1]: Es gab auch schon den Fall, dass eine Instanz auf bestimmte Anfragen nicht beantworten konnte, weil ein Teil der Applikation Ammok lief. Dieser Fehler war auch nicht von außen ersichtlich.
