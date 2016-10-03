+++
author = ""
categories = [ "Linux", "Sicherheit" ]
date = "2016-10-03T21:41:59+02:00"
description = ""
featured = ""
featuredalt = ""
featuredpath = ""
linktitle = ""
title = "SSH absichern"
type = "post"
tags = ["ssh"]

+++

[SSH] gilt als sichere Möglichkeit, um sich auf einen entfernten Server zu verbinden. Man sollte aber
wissen, dass bei SSH, wie bei HTTPS, verschiedene Algorithmen für die Verschlüsselung gibt. Einige
davon gelten sicherer als andere. Mit Hilfe von `nmap` kann man schnell sehen, welche Algorithmen
erlaubt sind:

{{< highlight sh >}}
nmap --script ssh2-enum-algos -p 22 127.0.0.1

Starting Nmap 7.01 ( https://nmap.org ) at 2016-10-03 22:28 CEST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000060s latency).
PORT   STATE SERVICE
22/tcp open  ssh
| ssh2-enum-algos: 
|   kex_algorithms: (6)
|       curve25519-sha256@libssh.org
|       ecdh-sha2-nistp256
|       ecdh-sha2-nistp384
|       ecdh-sha2-nistp521
|       diffie-hellman-group-exchange-sha256
|       diffie-hellman-group14-sha1
|   server_host_key_algorithms: (8)
|       ssh-rsa
|       rsa-sha2-512
|       rsa-sha2-256
|       ecdsa-sha2-nistp256
|       ssh-ed25519
|       ssh-rsa
|       rsa-sha2-512
|       rsa-sha2-256
|   encryption_algorithms: (6)
|       chacha20-poly1305@openssh.com
|       aes128-ctr
|       aes192-ctr
|       aes256-ctr
|       aes128-gcm@openssh.com
|       aes256-gcm@openssh.com
|   mac_algorithms: (10)
|       umac-64-etm@openssh.com
|       umac-128-etm@openssh.com
|       hmac-sha2-256-etm@openssh.com
|       hmac-sha2-512-etm@openssh.com
|       hmac-sha1-etm@openssh.com
|       umac-64@openssh.com
|       umac-128@openssh.com
|       hmac-sha2-256
|       hmac-sha2-512
|       hmac-sha1
|   compression_algorithms: (2)
|       none
|_      zlib@openssh.com

Nmap done: 1 IP address (1 host up) scanned in 0.19 seconds
{{< /highlight >}}

Die Algorithmen, welche verwendet werden kann man in der `/etc/ssh/sshd_config` konfigurieren. Ich 
habe die folgenden Zeilen eingefügt:

{{< highlight sh >}}
KexAlgorithms curve25519-sha256@libssh.org

Ciphers aes256-gcm@openssh.com,chacha20-poly1305@openssh.com
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com
{{< /highlight >}}

Nun sind nur noch die Ciphers aus der Liste erlaubt. Wenn man die Änderung gemacht hat, dann muss man
sie testen und anschließend den ssh-Dienst neu laden.

{{< highlight sh >}}
sshd -t
echo $?
0
systemctl reload ssh.service
{{< /highlight >}}


Nun sieht das ganze wie folgt aus:

{{< highlight sh >}}
nmap --script ssh2-enum-algos -p 22 127.0.0.1

Starting Nmap 7.01 ( https://nmap.org ) at 2016-10-03 22:59 CEST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000058s latency).
PORT   STATE SERVICE
22/tcp open  ssh
| ssh2-enum-algos: 
|   kex_algorithms: (1)
|       curve25519-sha256@libssh.org
|   server_host_key_algorithms: (1)
|       ssh-ed25519
|   encryption_algorithms: (2)
|       aes256-gcm@openssh.com
|       chacha20-poly1305@openssh.com
|   mac_algorithms: (2)
|       hmac-sha2-256-etm@openssh.com
|       hmac-sha2-512-etm@openssh.com
|   compression_algorithms: (2)
|       none
|_      zlib@openssh.com

Nmap done: 1 IP address (1 host up) scanned in 0.19 seconds
{{< /highlight >}}


**Achtung! Wenn man an der `/etc/ssh/sshd_config`
arbeitet, dann muss man sehr sorgsam arbeiten, sonst sperrt man sich im Zweifel aus!**

[SSH]: https://de.wikipedia.org/wiki/Secure_Shell
