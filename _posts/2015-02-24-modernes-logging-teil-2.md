---
layout: post
title: "Modernes Logging Teil 2"
description: ""
category:
  - 'linux'
  - 'tools'
tags:
 - 'elasticsearch'
 - 'kibana'

---
{% include JB/setup %}

Ich habe in meinen [letzten Beitrag über Logging] schon geschrieben, wie man eine moderne Logging-Infrastruktur aufsetzten kann.
Inzwischen wurde [Kibana] in der Version 4 finale freigegeben. In diesem Artikel möchte ich das Upgrade auf die
finale Version zeigen und auf das [Repository von Elasticsearch] hinweisen.

Kibana in der finalen Version 4 lässt sich genauso installieren, wie der Release Candidate. Man muss nur die Konfiguration
im Elasticsearch anpassen. 

### Vorarbeiten

Als erstes fährt man Kibana herunter und updatet Elasricsearch auf die Version 1.4.4. Das geht sehr einfach, wenn man das
entsprechende [Repository] benutzt. Dann ist es nur noch ein `apt-get install elasticsearch`.

### Update auf Kibana 4
``` sh
wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-linux-x64.tar.gz
tar xfvz kibana-4.0.0-linux-x64.tar.gz

# Index updaten
BODY=`curl -XGET 'localhost:9200/.kibana/config/4.0.0-rc1/_source'`; curl -XPUT "localhost:9200/.kibana/config/4.0.0" -d "$BODY" && curl -XDELETE "localhost:9200/.kibana/config/4.0.0-rc1"

# kibana starten
kibana-4.0.0-linux-x64/bin/kibana
```


### Nachtrag 06.03.2015

Es wurde [Kibana 4.0.1] released. Diese Version hat ein paar Bugfixes und man auch den Index nicht updaten, wenn man den Release Candidate noch installiert hat.



[Kibana 4.0.1]: https://www.elasticsearch.org/blog/kibana-4-0-1-released/
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[Repository von Elasticsearch]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-repositories.html
[Repository]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-repositories.html
[letzten Beitrag über Logging]: {% post_url 2015-02-15-modernes-logging %}
