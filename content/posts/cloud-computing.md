---
title: Cloud Computing
author: Michael Rennecke
type: post
date: 2011-02-21T16:22:25+00:00
categories:
  - HPC
  - Linux
  - Solaris
tags:
  - Cloud Computing
  - Mainframe
  - Netzwerk
  - Solaris

---
Ich höre immer öfter von Cloud Computing. Jedes mal hört sich das ganze wie eine ganz neue Idee an. Dabei ist Cloud Computing, nach meiner Ansicht, ein alter Hut. Dieser hat bestimmt schon 50 Jahre auf dem Buckel. Was man unter [Cloud Computing][1] versteht kann nachlesen. Was ist aber der eigentliche Kern hinter der ganzen Geschichte?

Beim   Cloud Computing werden Rechen-, Speicherkapazitäten oder Dienste dynamisch zur Verfügung gestellt. Diese Kapazitäten und Dienste werden in der Regel über ein Netzwerk zugänglich gemacht. Auf den Mainframes der 1960er Jahre wurden auch Dienste und Ressourcen dynamisch angeboten und verwaltet. Die Rechenzeit wurde zum Teil auch bei den verschiedenen Kostenstellen gebucht. Auf diese Weise kann man auch aktuelle Enterprise-Server bzw. Mainframes ansetzten und dabei die Hardware dynamisch partitionieren.  Wo ist nun der Unterschied, ob man 4 volle Racks hat oder nur einen großen Rechner (1960 oder heute)?

Der Unterschied zu 1960 ist, das man seit einigen Jahren vorkonfiguriertes Blech mit entsprechenden Diensten kaufen kann. Ich habe den Vorteil, das ich auf das Blech und dem Dienst Garantie bekommen kann. Weiterhin gibt es Dienstleister, welche einen Dienste anbieten. Als Kunde muss man sich nicht mehr mit der Hardware belasten. Es ist aber durchaus interessant  im eigenen Rechenzentrum eine private Cloud zu betreiben. So kann man schnell auf sich änderte Bedingungen  reagieren.

Wenn ich es genau nehme, dann betreibe zu Hause meine eigene Cloud. Das Herzstück ist **walhalla**, auf ihn läuft ein Solaris 11 Express Edition. In dem Rechner sind einige Festplatten. Wenn ich etwas ausprobiere, dann erstelle ich schnell eine  Zone oder setzte mit VirtualBox ein Linux auf. Je nach dem was ich mache, erzeuge ich mir eine maßgeschneiderte Umgebung. Einige werden sich fragen, wozu der ganze Aufwand. Die Antwort ist ganz einfach: Es ist möglich und es macht mir Spaß. Den größten Mehrgewinn sehe ich darin, das ich mein System sauber halte. Denn ich weiß für was welche Zone gut ist.

P.S.: Ich habe 1960 gewählt, weil mir nichts besseres eingefallen ist.

 [1]: http://de.wikipedia.org/wiki/Cloud_Computing