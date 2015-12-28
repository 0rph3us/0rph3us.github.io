+++
Categories = ["Sicherheit", "Linux"]
Description = ""
Tags = ["LibreSSL", "HAProxy", "Raspberry Pi", "Security", "Raspbian"]
date = "2015-12-28T22:37:08+01:00"
title = "LibreSSL und HAProxy"

+++

Wenn man [Raspbian] einsetzt (oder eine fast beliebige andere Linux-Distribution)
hat man das _Problem_, dass die mitgelieferten Webserver und Loadbalancer [OpenSSL]
nutzen. OpenSSL ist 2015 durch eine Sicherheitslücken negativ aufgefallen, außerdem
gibt es keine Unterstützung[^1] für [ChaCha20 Cipher Suiten]. Diese haben den Vorteil,
dass sie in Software schneller sind als [AES]. Das macht sich insbesondere bei meinen
Raspberry Pi und bei Smartphones bemerkbar. Diese haben Hardware AES. 

[LibreSSL] ist eine Alternative zu OpenSSL. Es hat die Unterstützung für ChaCha20. Bei
LibreSSL liegt der Fokus auf Sicherheit und weniger auf die Unterstützung von alten 
Schnittstellen. Deswegen ist davon auszugehen, dass es in der Zukunft auch weniger
kritische Sicherheitslücken geben wird.


## LibreSSL bauen

``` sh
cd
wget http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.3.1.tar.gz
tar xfvz libressl-2.3.1.tar.gz
cd libressl-2.3.1/
./configure
make -j 4
sudo make install
sudo ln -s /usr/local/lib/libssl.so.37 /usr/lib/libssl.so.37
sudo ln -s /usr/local/lib/libcrypto.so.36 /usr/lib/libcrypto.so.36
``` 

```
# /usr/local/bin/openssl version
LibreSSL 2.3.1
```

## HAProxy bauen
``` sh
cd 
git clone http://git.haproxy.org/git/haproxy-1.6.git/
cd haproxy-1.6/
git checkout v1.6.3
export LIBRESSL=/usr/local/
make TARGET=linux2628 USE_OPENSSL=1 SSL_INC=${LIBRESSL}/include SSL_LIB=${LIBRESSL}/lib ADDLIB=-ldl
sudo cp haproxy /usr/local/sbin
```


[Raspbian]: https://www.raspbian.org/
[OpenSSL]: https://www.openssl.org/
[ChaCha20 Cipher Suiten]: https://blog.cloudflare.com/do-the-chacha-better-mobile-performance-with-cryptography/
[AES]: https://de.wikipedia.org/wiki/Advanced_Encryption_Standard
[LibreSSL]: http://www.libressl.org/

[^1]: In den kommenden Versionen von OpenSSL wird es Unterstützung für ChaCha20 Cipher Suiten geben. Ich finde die Quelle gerade nicht :-(
