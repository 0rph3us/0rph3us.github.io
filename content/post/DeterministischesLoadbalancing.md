+++
Categories = ["Tools"]
Description = ""
Tags = ["HAProxy", "Loadbalancing"]
date = "2015-09-17T05:58:20+02:00"
title = "Deterministisches Loadbalancing"

+++

Beim Loadbalancing verteilet ein Loadbalancer, wie HAProxy die Last auf mehrere Server. In vielen Fällen macht man das Roud-Robin oder nach Last. Es ergibt auch durchaus Sinn nach einer ID die Backendserver auszuwählen. Daraus ergeben sich zwei Vorteile. Zum einen kann es für Backendserver besser sein, wenn die selbe ID immer auf den selben Server kommt. Dadurch können interene Caches evtl. besser ausgenutzt werden. Da eine ID immer einen Server zugeordnet ist, wird das Loadbalancing deterministisch. Das hat den unschätzbaren Vorteil, dass z.B. eine Anfrage die fehl schlägt immer fehl schlägt.

Bei meinen Arbeitgeber hatten wir das Problem, dass bestimmte URLs konsequent nicht gehen. Bei einen naiven Test hat der Entwickler festgestellt, dass sein Dienst auf die URL korrekt antwortet. Durch meinen Test der Proxykonfiguration konnte ich ausschließen, dass das Routing im HAProxy Schuld am Fehlverhalten ist. Da dieser Dienst mit einer konsistenten Hashfunktion deterministisch geroutet wird, trat der Fehler immer auf. Dabei stellte sich heraus, dass eine Instanz nicht in der richtigen Version[^1] lief.

Da Fehler immer wieder vorgekommen, ist es wichtig sie schnell und zuverlässig zu beseitigen. In solchen Situationen ist es besser, den Fehler **immer** zu haben, anstatt bei jeder x-ten Anfrage.

[^1]: Es gab auch schon den Fall, dass eine Instanz auf bestimmte Anfragen nicht beantworten konnte, weil ein Teil der Applikation Ammok lief. Dieser Fehler war auch nicht von außen ersichtlich.
