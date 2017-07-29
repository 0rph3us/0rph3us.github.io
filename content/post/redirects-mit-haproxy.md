+++
title = "Redirects mit HAProxy"
date = "2017-07-29T21:58:13+02:00"
hide_authorbox = false
disable_comments = false
draft = false
categories = ["Linux", "Infrastruktur"]
tags = ["HAProxy"]
+++

[HAProxy] ist mein persönliches Schweizer Taschenmesser, wenn es um HTTP-Routing
geht. Wenn man ganze Verzeichnisse umleiten möchte, dann ist das mitunter etwas
kompliziert, gerade wenn man eine alte Version benutzen muss.

Im folgenden gibt es zwei Beispiele, wie man alle Requests, welche mit `/foo/`
beginnen zu `/bar/` umleitet.

## HAProxy 1.5
In HAProxy 1.5 funktioniert dieser Redirect nur mit einem kleinen Hack: Man
kopiert den Inhalt der internen Variable `url`[^1] in einen eigenen Header.
Dieser Header wird mit einem regulären Ausdruck manipuliert und anschließt 
leitet man um.

{{< highlight sh>}}
# Clean the request -> remove any existing header named X-REDIR
http-request del-header X-REDIR

# Copy the full request URL into X-REDIR (without changes)
http-request add-header X-REDIR %[url] if { path_beg /foo/ }

# Change the X-REDIR header to contain out new path
http-request replace-header X-REDIR ^/foo(/.*)?$ /bar\1 if { hdr_cnt(X-REDIR) gt 0 }

# Perform the 301 redirect
http-request redirect code 301 location https://%[hdr(host)]%[hdr(X-REDIR)] if { hdr_cnt(X-REDIR) gt 0 }
{{< /highlight >}}


## ab HAProxy 1.6
Seit HAProxy 1.6 gibt es den Filter [regsub], mit diesen geht der Redirect direkt.

{{< highlight sh>}}
http-request redirect code 301 location https://%[hdr(host)]%[url,regsub(^/foo/,/bar/,)] if { path_beg /foo/ }
{{< /highlight >}}

[HAProxy]: http://www.haproxy.org/
[regsub]: https://cbonte.github.io/haproxy-dconv/1.7/configuration.html#7.3.1-regsub
[^1]: Es ist der komplette Path mit allen Parametern, ohne Protokoll und Hostname