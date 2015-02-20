---
layout: page
title: Linux-Spickzettel
tagline: Commandline Hacks
group: linux
author:
  email: michael.rennecke@gmail.com
  display_name: Michael Rennecke
  first_name: Michael
  last_name: Rennecke
---
{% include JB/setup %}


### MD5SUM eines Verzeichnisses bestimmen

{% highlight bash %}
find /tmp -type f -exec md5sum {} \; | sort | md5sum
{% endhighlight %}

### Systemmail-Verteiler
{% highlight bash %}
vim /etc/aliases
newaliases
{% endhighlight %}

### Alle Abhänigkeiten eines go-Projektes rekursiv holen
``` sh
go get ./...
```
