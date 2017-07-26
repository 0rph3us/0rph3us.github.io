+++
Categories = ["Sicherheit", "Linux"]
Description = ""
Tags = ["LibreSSL", "HAProxy", "Raspberry Pi", "Security", "Raspbian"]
date = "2015-12-28T22:37:08+01:00"
title = "LibreSSL und HAProxy"
type = "post"

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


## HAProxy

In meinen Setup ist [HAProxy] vor dem Webserver (Nginx). Es ist vielleicht sinnlos
einen Loadbalancer auf dem Pi zu nutzen aber ich finde, dass sich HAProxy ein einigen
Stellen einfacher konfigurieren lässt als Nginx.


## HAProxy mit LibreSSL und PCRE bauen

kopiere das folgende Script in eine Datei und führe es aus:

{{< highlight bash >}}
#!/bin/bash

# names of latest versions of each package
export HAPROXY_VERSION=1.6.3
export VERSION_PCRE=pcre-8.38
export VERSION_LIBRESSL=libressl-2.3.1
export VERSION_HAPROXY=haproxy-$HAPROXY_VERSION

# URLs to the source directories
export SOURCE_LIBRESSL=ftp://ftp.openbsd.org/pub/OpenBSD/LibreSSL/
export SOURCE_PCRE=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
export SOURCE_HAPROXY=http://www.haproxy.org/download


# clean out any files from previous runs of this script
rm -rf build
mkdir build

# proc for building faster
NB_PROC=$(grep -c ^processor /proc/cpuinfo)

# ensure that we have the required software
#sudo apt-get -y install curl wget build-essential libgd-dev libgeoip-dev checkinstall git

# grab the source files
echo "Download sources"
wget -P ./build "${SOURCE_PCRE}${VERSION_PCRE}.tar.gz"
wget -P ./build "${SOURCE_LIBRESSL}${VERSION_LIBRESSL}.tar.gz"
wget -P ./build "${SOURCE_HAPROXY}/$(echo $HAPROXY_VERSION | cut -d. -f 1-2)/src/$VERSION_HAPROXY.tar.gz"

# expand the source files
echo "Extract Packages"
cd build || exit 1

tar xfz "${VERSION_HAPROXY}.tar.gz"
tar xfz "${VERSION_LIBRESSL}.tar.gz"
tar xfz "${VERSION_PCRE}.tar.gz"
cd ../ || exit 1

export BPATH="${PWD}/build"
export STATICLIBSSL="${BPATH}/${VERSION_LIBRESSL}"

# build static LibreSSL
echo "Configure & Build LibreSSL"
cd "${STATICLIBSSL}" || exit 1
./configure --prefix="${STATICLIBSSL}/_openssl/" --enable-shared=no && make install-strip -j "${NB_PROC}"

# build pcre
export STATICLIPCRE="${BPATH}/${VERSION_PCRE}"
cd "${STATICLIPCRE}" || exit 1
./configure --prefix="${STATICLIPCRE}/_pcre" --enable-shared=no --enable-utf8 --enable-jit
make -j "${NB_PROC}"
make install


echo "Build HAProxy"
cd "${BPATH}/${VERSION_HAPROXY}" || exit 1

make \
-j "${NB_PROC}" \
TARGET=linux2628 \
USE_STATIC_PCRE=1 \
USE_PCRE_JIT=1 \
PCRE_LIB="${STATICLIPCRE}/_pcre/lib" \
PCRE_INC="${STATICLIPCRE}/_pcre/include" \
USE_OPENSSL=1 \
SSL_INC="${STATICLIBSSL}/_openssl/include" \
SSL_LIB="${STATICLIBSSL}/_openssl/lib" \
USE_ZLIB=1 \
DEFINE="-fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2"


echo "All done."
echo "become root and type: "
echo "  cp build/haproxy-${HAPROXY_VERSION}/haproxy /usr/local/sbin"
{{< / highlight >}}

## Konfiguration

Hier ist eine Beispielkonfiguration. Wobei die SSL Konfiguration sehr
paranoid ist.


{{< highlight yaml >}}
global
        maxconn 100
        ssl-default-bind-ciphers CHACHA20+EECDH:AES256+EECDH
        ssl-default-bind-options force-tlsv12

        daemon
        user haproxy
        chroot /var/lib/haproxy
        stats socket /var/run/haproxy.sock mode 660 level admin


defaults
        mode http
        timeout connect 5s
        timeout client 5s
        timeout server 5s

        stats scope .

        option socket-stats
        option forwardfor


frontend myfrontend
        # primary cert is /etc/haproxy/certs/server.pem
        # /etc/haproxy/certs/ contains additional certificates for SNI clients
        bind :443 tfo ssl crt /etc/haproxy/certs/server.pem crt /etc/haproxy/certs/ ecdhe secp384r1 name ssl-traffic
        bind :80 name http-traffic

        http-response set-header X-Frame-Options                DENY
        http-response set-header X-Content-Type-Options         nosniff
        http-response set-header Strict-Transport-Security      max-age=31536000;\ includeSubdomains;\ preload

        http-request redirect scheme https code 301 if !{ ssl_fc }

        http-request set-header X-Forwarded-Proto                https


        use_backend stats               if { path_beg /haproxy/stats }

        default_backend mybackend


backend mybackend
        # a http backend
        server s3 10.0.0.3:80
        server s4 10.0.0.3:443 ssl verify none


backend stats
        stats enable
        stats show-legends
        stats realm Haproxy\ Statistics
        stats uri /haproxy/stats
        stats refresh 30s
{{< / highlight >}}


[Raspbian]: https://www.raspbian.org/
[OpenSSL]: https://www.openssl.org/
[ChaCha20 Cipher Suiten]: https://blog.cloudflare.com/do-the-chacha-better-mobile-performance-with-cryptography/
[AES]: https://de.wikipedia.org/wiki/Advanced_Encryption_Standard
[LibreSSL]: http://www.libressl.org/
[HAProxy]: http://www.haproxy.org/

[^1]: In den kommenden Versionen von OpenSSL wird es Unterstützung für ChaCha20 Cipher Suiten geben. Ich finde die Quelle gerade nicht :-(
