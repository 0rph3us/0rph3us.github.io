+++
title = "Repository zu Github spiegeln"
date = "2017-08-12T22:26:17+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["git"]
categories = ["programmieren"]
+++

Bei [Github] gibt es leider keine Möglichkeit, dass man fremde [git]-Repositories
spiegeln kann. Das hat zur Folge, dass man von Github aus spiegelt oder man muss
zu Github *pushen*. Es gibt verschiedene Gründe, weswegen man Github nicht als das
*zentrale* Repository nehmen möchte. Also muss man die Änderungen aktiv zu Github
schieben.

## Zusätzlicher Remote

Die offensichtlichste Möglichkeit ist, dass man eine zusätzlichen [Remote]
hinzufügt.

{{< highlight sh >}}
git remote add github <github repo URL>
git push github
{{< /highlight >}}

Man muss aber immer daran denken, dass man auch zu Github pushen muss. Wenn man im Team
arbeitet müssen im Zweifel alle Teammitglieder daran denken

## origin mit 2 push URLs

Eine weitere Möglichkeit ist, dass man *origin* 2 push URLs konfiguriert. Das man man wie
folgt:

{{< highlight sh >}}
git remote set-url --add --push [remote] [original repo URL]
git remote set-url --add --push [remote] [second repo URL]
{{< /highlight >}}

Mit `git remote -v` kann man das überprüfen:

{{< highlight sh >}}
$ git remote -v
origin gogs@git.0rpheus.net:rennecke/original-repo.git (fetch)
origin gogs@git.0rpheus.net:rennecke/original-repo.git (push)
origin git@0rph3us.com:bjmiller121/second-repo.git (push)
{{< /highlight >}}

## post-receive Hook

Mit einem [post-receive Hook] kann man zwei oder mehr Repostories sehr
elegant und auch automatisch synchron halten. Diesen Hook muss man auf
seinen zentralen Repository einrichten. Dieser Hook wird jedes mal
ausgeführt, wenn das Repo neue Commits erhält.
Der Hook sieht wie folgt aus:

{{< highlight sh >}}
#!/bin/bash
/usr/bin/git push --mirror [second repo URL]
{{< /highlight >}}

Falls man via ssh das zweite Repo spiegelt, muss man ggf. noch den Hostkey
von Github hinzufügen.

[Github]: https://github.com/
[git]: https://git-scm.com/
[Remote]: https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes
[post-receive Hook]: https://git-scm.com/docs/githooks#post-receive