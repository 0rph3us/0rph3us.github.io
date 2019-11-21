---
title: "Haproxy Testen"
date: 2019-11-21T13:31:10+01:00
description:
categories:
 - Infrastruktur
tags:
 - HAProxy
featured_image:
author: ""
---

Ich war die Tage mit zwei Kumpeln Bier trinken. Die machen meist nur krankes Netzwerkzeugs und große [Ceph]-Cluster.
Auf jeden Fall haben sie mir berichtet, dass ihnen ein [HAProxy] bei einem kleinen Angriff um die Ohren geflogen ist.
Ein HAProxy fliegt einen eigentlich nie um die Ohren. Entweder hat man wirklich sehr viel Last oder man macht komische
Dinge. Man kann in HAProxy auch *teure* lua-Skripte ausführen oder gegen komplexe reguläre Ausdrücke prüfen.
Aus diesem Grund lässt es sich nicht pauschal sagen, wie viel Traffic eine bestimmte Konfiguration auf einer bestimmten
Hardware/VM aushält. Falls man nicht auf der produktiven Infrastruktur testen darf, kann man mit einem Dummyserver und
einem Lastgenerator, wie [Vegeta], die Proxykonfiguration testen.

Ich gehe davon aus, dass man die produktive Konfiguration HAProxy hat. Idealerweise hat meine eine VM zum Last generieren,
eine für den HAProxy und eine VM für den Dummyserver. Damit man ein Bauchgefühl bekommt, kann man auch alles auf einen
Rechner laufen lassen. Dabei ist zu bedenken, dass man ggf. nicht die passenden `ulimit`s hat. Diese müssen, je nach Last
angepasst werden.

## Konfiguration anpassen

1. Backendserver durch den Testserver austauschen. Es kann auch notwenig sein, dass man mehrere Testserver verwendet.
1. `X-Backend` Header mit dem Namen vom Backend setzen, damit kann man einen Request verfolgen. Evtl. auch für `listen`-Blöcke notwendig

Das folgende Skript erledigt die beiden Schritte. Es sollte mit vielen Konfigurationen funktionieren. Im Zweifel muss man es anpassen oder
die Konfiguration per Hand umschreiben.

{{< highlight bash >}}
#!/bin/bash

config=/etc/haproxy/haproxy.cfg
testserver=192.0.2.20:8080

# rename socket connections
sed -e "s/\(^[[:space:]]*\)server\(.*unix@.*\)/\1UNIXSOCKERSERVER\2/g" -i "$config"

sed -e "s/\(^[[:space:]]*\)server\(.*\)/\1server testserverNRNR $testserver/g" -i "$config"
sed -e 's/^backend \(.*\)$/backend \1\n\thttp-request set-header X-Backend \1/g' -i "$config"

# rename socket connections back
sed -e "s/UNIXSOCKERSERVER/server/g" -i "$config"

# replace NRNR with the current line number
#   servers without an explicit IDs are not recommended
gawk -i inplace '{gsub("NRNR",NR,$0);print}' "$config"
{{< /highlight >}}

## Dummyserver

Dieser kleine http-Server gibt auf bei jedem Request auf irgendeine Ressource ein JSON zurück. In diesem
JSON findet man den Host-Header, Path und den Namen vom Backend. Der Name des Backends wird über den
`X-Backend` bestimmt. Diese Information kann man die HAProxy-Konfiguration testen:
`curl -H 'Host: example.com' http://192.0.2.10/hallo/welt | jq .backend`

{{< highlight golang >}}
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"
)

type response struct {
	Backend        string              `json:"backend"`
	Path           string              `json:"path"`
	Host           string              `json:"host"`
	RequestHeaders []map[string]string `json:"requestHeaders"`
}

func handler(w http.ResponseWriter, r *http.Request) {

	backend, exist := r.Header["X-Backend"]
	if exist == false {
		backend = []string{"X-Backend Header is not set"}
	}

	var resp response
	resp.Backend = backend[0]
	resp.Path = r.URL.Path[1:]
	resp.Host = r.Host

	// add all Request Headers to Response
	for header, values := range r.Header {
		h := make(map[string]string)
		h[header] = strings.Join(values, ", ")
		resp.RequestHeaders = append(resp.RequestHeaders, h)
	}

	json, _ := json.Marshal(resp)
	fmt.Fprintf(w, string(json))

	log.Printf("hostheader: %s\tpath: %s\n", resp.Host, resp.Path)
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
{{< /highlight >}}

## Durchführung

Wenn man die Konfiguration umgeschrieben und den Dummyserver ausgerollt hat, dann kann man ganz einfach den
Lasttest starten und schauen wo es klemmt.

## Ausblick

Ich nutze diesen Ansatz zum Testen von komplexen Konfigurationen. Es wird noch ein Betrag folgen, wie ich das genau
bewerkstellige.

[Ceph]: https://ceph.io/
[Vegeta]: https://github.com/tsenart/vegeta
[HAProxy]: http://www.haproxy.org/