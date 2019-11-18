+++
title = "Let's Encrypt mit ECC"
date = "2017-07-30T21:39:36+02:00"
hide_authorbox = false
disable_comments = false
draft = false
tags = ["security", "openssl"]
categories = ["Infrastruktur", "Sicherheit"]
+++

Wenn man nichts angibt, dann generiert der [Let's Encrypt]-Client einen [RSA] Schüssel,
welcher von Let's Encrypt signiert wird. Die RSA Schlüssel sind in der Regel 2048 Bit
lang. Man kann auch längere Schlüssel generieren, diese erhöhen die Sicherheit.

Es ist auch möglich [ECC] für Zertifikate zu nutzen. Der offensichtlichtlichste Vorteil
ist, dass ECC Schlüssel viel kürzer als RSA Schlüssel sind - bei einem gleichwertigen
Sicherheitsnivieau.
Auf leistungsschwachen Geräten ist ECC, in meinen Augen, auch schneller als RSA. Das merkt
man erst bei RSA Schlüsseln welche signifikant länger als 2048 Bit sind.
Es hat sich bewährt, dass man die Kurve **secp256r1** nutzt, **secp384r1** funktioniert auf
manchen Android 7 Geräten nicht richtig und längere Kurven werden z.B. von Chrome nicht 
unterstützt.

Im folgenden möchte ich zeigen, wie man ein SAN-Zertifikat anfordert

## ECC-Zertifikat anfordern

### Privaten Schlüssel erzeugen

{{< highlight sh >}}
openssl ecparam -genkey -name prime256v1 > domain.key
{{< /highlight >}}

### Certificate Signing Request erstellen

{{< highlight sh >}}
domain=blog.0rpheus.net
country=DE
state=Saxony-Anhalt

openssl req -new -sha256 \
    -key domain.key \
    -subj "/C=$country/ST=$state/CN=$domain" \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf "\n[SAN]\nsubjectAltName=DNS:$domain")) \
    -out domain.csr
{{< /highlight >}}

### Zertifikat anfordern

{{< highlight sh >}}
email=meine@email.de
outdir=/etc/certs

mkdir -p "$outdir/fullchain/"
mkdir -p "$outdir/chain/"
mkdir -p "$outdir/cert/"

letsencrypt certonly \
    --agree-tos \
    --standalone \
    --email "$email" \
    --fullchain-path "$outdir/fullchain" \
    --chain-path "$outdir/chain" \
    --cert-path "$outdir/cert" \
    --csr domain.csr
{{< /highlight >}}

Anschließden erhält man die Zertifikatsdateien in den entsprechenden
Verzeichnissen. Das ganz ist nur ein kurzer Abriss wie man ECC Zertifikate
von Let's Encrypt erhält. Der Befehl `letsencrypt` hat viel mehr Parameter,
die man nach den eigenen Anforderungen setzten kann.


[ECC]: https://de.wikipedia.org/wiki/Elliptic_Curve_Cryptography
[RSA]: https://de.wikipedia.org/wiki/RSA-Kryptosystem
[Let's Encrypt]: https://letsencrypt.org/