+++
author = ""
categories = ["Linux", "Sicherheit"]
date = "2016-10-30T21:17:02+01:00"
description = ""
featured = ""
featuredalt = ""
featuredpath = ""
linktitle = ""
title = "SSH Angriffe abwehren"
type = "post"
tags = ["ssh"]

+++

Ich [habe geschrieben], wie ich meinen SSH-Server gehärtet habe. Nun habe ich mir das `auth.log`
genauer angesehen. Dabei habe ich festgestellt, dass mein gehärteter SSH Server alle Angriffe im
Keim erstickt:

    fatal: Unable to negotiate with 116.31.116.41 port 16229: no matching key exchange method found. Their offer: diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1 [preauth]

Das ist Angreifer "stirbt" schon beim Schlüsselaustausch mit dem Server und kann somit keinen
Login-Versuch unternehmen. 

Wenn man aktiv sein SSH-Zugang schützen möchte, dann sollte man auch über [fail2ban] nachdenken.


[habe geschrieben]: {{< relref "ssh-absichern.md" >}}
[fail2ban]: https://www.thomas-krenn.com/de/wiki/SSH_Login_unter_Debian_mit_fail2ban_absichern
