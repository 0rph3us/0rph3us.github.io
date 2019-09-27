+++
title = "Docker aufräumen"
date = "2017-08-21T21:12:31+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["Deployment"]
categories = ["Docker"]
+++

Wenn man [Docker] nutzt, wird man über kurz oder lang seine Festplatte voll bekommen. Das liegt daran,
dass Docker keine alten (unbenutzten) Images automatisch löscht. Man kann diese Images per Hand löschen,
das ist aber sehr nervig. Das Tool [docker-gc] gibt es schon recht lange, mit ihm kann man recht konfortabel
aufräumen. In Docker 1.13 wurde das Unterkomando [`system`] eingeführt. Damit kann man sich den verbrauchten
Plattenplatz übersichtlich anzeigen lassen und aufräumen. Eine auführliche Übersicht zum Platzverbrauch
erhält man mit [`docker system df`] und mit [`docker system prune -a`] werden alle nicht benutzen sowie
nicht referenzierte Images gelöscht.


[Docker]: https://www.docker.com/what-docker
[docker-gc]: https://github.com/spotify/docker-gc
[`system`]: https://docs.docker.com/engine/reference/commandline/system/
[`docker system df`]: https://docs.docker.com/engine/reference/commandline/system_df/
[`docker system prune -a`]: https://docs.docker.com/engine/reference/commandline/system_prune/
