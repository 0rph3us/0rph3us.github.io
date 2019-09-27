+++
title = "map Files mit HAProxy"
date = "2017-08-03T21:41:58+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["HAProxy"]
categories = ["Infrastruktur"]
+++

In meinen Beitrag [Loadbalancer und Webserver härten] habe ich map Files in [HAProxy] verwendet, um
die Konfiguration zu vereinfachen. Normalerweise arbeitet HAProxy weiter, wenn ein `use_backend` keine
Anwendung findet, da man dazu in der Regel eine entsprechende ACL definiert. Wenn man mehrere map Files
verwendet und diese sollen nacheinander ausgewertet werden, z.B. zuerst möchte man nach Pfaden routen
und dann nach Hostnamen, dann *muss* man auch ACLs definieren. Falls man keine ACL und kein 
Default-Backend bei der [map]-Funktion angibt, wird auch Default-Backend ignoriert, welches 
mit `default_backend` konfiguriert wird.


## Minimalbeispiel
```
global
    log /dev/log    local0
    log /dev/log    local1 notice


defaults
    mode http
    timeout connect 5s
    timeout client 15s
    timeout server 15s


frontend http-in
    bind :8080

    use_backend bk_%[path,map_beg(/etc/haproxy/path2backends.map)] if { path,map_beg(/etc/haproxy/path2backends.map) -m found }
    use_backend bk_%[req.hdr(host),lower,map(/etc/haproxy/host2backends.map,stats)]


backend bk_stats
    stats enable
    stats show-legends
    stats realm Haproxy\ Statistics
    stats uri /
    stats refresh 30s


backend bk_host1
    server a1 127.0.0.1:9001


backend bk_host2
    server a2 127.0.0.1:9002


backend bk_path1
    server a3 127.0.0.1:9003


backend bk_path2
    server a4 127.0.0.1:9004
```

Die ACL `{ path,map_beg(/etc/haproxy/path2backends.map) -m found }` ist wahr, wenn der Pfad in der Datei
`path2backends.map` gefunden wurde. Falls das nicht Fall ist, wird diese Zeile übersprungen. 
Wird der Hostname von Request nicht in der Datei `host2backends.map` gefunden, dann wird das Backend
`bk_stats` genommen.



[HAProxy]: http://www.haproxy.org/
[Loadbalancer und Webserver härten]: {{< relref "Loadbalancer-haerten.md" >}}
[map]: https://cbonte.github.io/haproxy-dconv/1.7/configuration.html#7.3.1-map