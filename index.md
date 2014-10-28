---
layout: page
title: Hallo Welt!
tagline: Ein alter alter Blog mit neuer Technik
---
{% include JB/setup %}

Ich habe mich entschlossen, meinen alten [Wordpress](http://wpde.org/)-Blog einzudampfen. Ich
fand Wordpress schon immer recht schwergewichtig, aber ich kanne bis jetzt keine Alternative um einen
"gut" aussehenden Blog mit "wenig" Arbeit zu pflegen. 


Nun bin ich auf [JekyllBootstrap](http://jekyllbootstrap.com) und [Hooligan](https://github.com/dhulihan/hooligan) gestoßen. 
Am Theme habe ich etwas etwas Hand angelegt. Als 
Versionsverwaltung nutze ich [git](http://git-scm.com/). Der gesamte Blog ist als Code auf [github](https://github.com/0rph3us/jekyll-bootstrap) zu finden.

Da ich nun offline am Blog arbeiten kann, möchte ich wieder aktiver sein.

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_german }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>



