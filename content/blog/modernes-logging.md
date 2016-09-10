---
type: post
title: "Modernes Logging"
date: 2015-02-15
description: ""
categories:
  - 'linux'
  - 'tools'
tags:
  - 'logging'
  - 'elasticsearch'
  - 'kibana'
  - 'syslog'
  - 'rsyslog'
  - 'logstash'
---


Achtung: Es gibt einen [2. Teil des Artikels], welchen sich vorher ansehen solle, bevor man hier alles copy&pastet

In [Java]-Welt ist folgende Stack für Logging recht verbreitet, weil man mit ihm ein leistungsstarkes modernes und zentrales Logging umsetzten kann. Dieser Stack besteht aus [Elasticsearch], einen Volltextindex zum speichern der Nahrichten. Diese werden von [Logstash] verarbeitet und zum Index geschickt. [Kibana] wird zum
visualisieren der Volltextinhalte genommen. Ich finde Logstash zum reinen verschicken von Lognahrichten zu schwergewichtig und es bötigt zu viel Ressourcen. Linux verwendet [syslog] zum versenden von Lognachrichten. In vieles Distributionen wird [rsyslog] zum verarbeiten der Nahrichten verwendet. Das gute ist, dass man mit rsyslog auch direkt in Elasticsearch loggen kann. So kann man mit rsyslog, Elasticsearch und Kibana ein leichtgewichtigeres und modernes Logsystem bauen.

Die folgende Anleitung beschreibt, wie man das ganze unter Ubuntu 14.04 einrichtet. Ich beschreibe kein komplettes Setup, es ist als Einstieg in die Thematik gedacht.

### rsyslog unter Ubuntu 14.04 installieren

Eine Konsole öffnen und das Repository hinzufügen. Es handelt sich hierbei um das [offizelle Repository] von rsyslog. Rsyslog ist in den offizellen Repositories von Ubuntu nicht auf dem neusten Stand, außerdem gibt kein Paket mit dem Elasticsearchsupport.

``` sh
sudo add-apt-repository ppa:adiscon/v8-stable
```

Den Cache von `apt` aktualisieren und `rsyslog` mit der Elasticsearch Unterstützung installieren

``` sh
sudo apt-get update
sudo apt-get install rsyslog rsyslog-elasticsearch
```

### Elasticsearch installieren

deb-Paket herunterladen und installieren. Die Installation über das deb-Paket hat den Vorteil, dass man Elasticsearch einfach updaten kann und es gibt auch schon init-Skripte.

``` sh
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.3.deb
sudo dpkg -i elasticsearch-1.4.3.deb
sudo update-rc.d elasticsearch defaults
```

 Elasticsearch konfigurieren. Dazu muss man die Datei `/etc/elasticsearch/elasticsearch.yml` im Editor seine Wahl öffnen und die folgenden Zeilen einkommentieren und ändern

``` yaml
# Set the number of shards (splits) of an index (5 by default):
#
index.number_of_shards: 1

# Set the number of replicas (additional copies) of an index (1 by default):
#
index.number_of_replicas: 0
```

Elasticsearch starten:

``` sh
sudo service elasticsearch start
```

### rsyslog konfigurieren

Man muss nun dafür sorgen, dass die Lognahrichten von rsyslog nach Elasticsearch geschrieben werden. Als erstes legt man ein [Mapping] in Elasticsearch an. Damit sagt man Elasticsearch, dass es das Feld `program` [nicht analysieren] soll. Außerdem sollen die Dokumente nach [90 Tagen gelöscht] werden.

``` sh
curl -XPUT 'http://localhost:9200/logstash' -d '{
  "mappings": {
    "events" : {
      "_ttl" : {
        "enabled" : true,
        "default" : "90d"
        },
      "properties" : {
        "program" : {
          "type" : "string",
          "index" : "not_analyzed",
          "norms" : {
            "enabled" : false
          }
        }
      }
    }
  }
}'
```

Nach man die Datei  `/etc/rsyslog.d/30-elasticsearch.conf` erstellt hat, muss
man nur noch `rsyslog` neu starten. Wenn es Probleme gibt kann man mit `rsyslogd -N1` die Konfiguraion überprüfen.


``` sh
sudo su -
cat << EOF > /etc/rsyslog.d/30-elasticsearch.conf
#module(load="imuxsock")       # for listening to /dev/log, normal not needed
module(load="omelasticsearch") # for outputting to Elasticsearch

# this is for index names to be like: logstash-YYYY.MM.DD
template(name="logstash-index"
  type="list") {
    constant(value="logstash-")
    property(name="timereported" dateFormat="rfc3339" position.from="1" position.to="4")
    constant(value=".")
    property(name="timereported" dateFormat="rfc3339" position.from="6" position.to="7")
    constant(value=".")
    property(name="timereported" dateFormat="rfc3339" position.from="9" position.to="10")
}

# use only one index, useful only for local usage
template(name="logstash" type="string" string="logstash")

# this is for formatting our syslog in JSON with @timestamp
template(name="plain-syslog"
  type="list") {
    constant(value="{")
      constant(value="\"@timestamp\":\"")     property(name="timereported" dateFormat="rfc3339")
      constant(value="\",\"host\":\"")        property(name="hostname")
      constant(value="\",\"severity\":\"")    property(name="syslogseverity-text")
      constant(value="\",\"facility\":\"")    property(name="syslogfacility-text")
      constant(value="\",\"tag\":\"")         property(name="syslogtag" format="json")
      constant(value="\",\"program\":\"")     property(name="programname")
      constant(value="\",\"message\":\"")     property(name="msg" format="json")
    constant(value="\"}")
}

# this is where we actually send the logs to Elasticsearch (localhost:9200 by default)
action(type="omelasticsearch"
    template="plain-syslog"
    searchIndex="logstash"
    dynSearchIndex="on")

EOF
/etc/init.d/rsyslog restart
exit
```

### Kibana installieren

Für Kibana gibt es leider keinen bequemen Installationsweg. Deswegen beschreibe ich den Weg, der schnell und einfach zum Ziel führt, aber auf keinen Fall sinnvoll für den produktiven Betrieb ist. Man läd Kibana herunter und startet es.

``` sh
wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-rc1-linux-x64.tar.gz
tar xfvz kibana-4.0.0-rc1-linux-x64.tar.gz
kibana-4.0.0-rc1-linux-x64/bin/kibana
```

Nun kann man auf Kibana über `http://127.0.0.1:5601/` im Browser zugreifen. Man muss nur noch Kibana sagen, welchen Index es benutzen soll. Das geht realtiv intuitiv.

### Anmerkung
Das es rsyslog auch für Windows gibt, kann man diesen Stack auch für Windows nutzen. Ich habe hier alle Technologien nur angeschitten, für ein richtiges Setup muss man noch viel mehr beachten und konfigurieren.


[Java]: http://de.wikipedia.org/wiki/Java_%28Programmiersprache%29
[Elasticsearch]: http://www.elasticsearch.org/
[Logstash]: http://logstash.net/
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[syslog]: http://de.wikipedia.org/wiki/Syslog
[rsyslog]: http://www.rsyslog.com/
[offizelle Repository]:http://www.rsyslog.com/ubuntu-repository/
[Mapping]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/mapping.html
[nicht analysieren]:http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/mapping-core-types.html
[90 Tagen gelöscht]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/mapping-ttl-field.html
[2. Teil des Artikels]: {{< ref "modernes-logging-teil-2.md" >}}
