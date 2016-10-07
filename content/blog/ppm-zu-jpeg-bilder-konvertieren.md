+++
author = ""
categories = ["Tools"]
date = "2016-10-07T17:52:45+02:00"
description = ""
featured = ""
featuredalt = ""
featuredpath = ""
linktitle = ""
title = "ppm zu jpeg Bilder konvertieren"
type = "post"
draft = false
tags = ["bash", "Ubuntu", "Debian", "konvertieren"]
+++

Heute musste ich viele Bilder vom [ppm] in das [jpeg]-Format umwandeln. Mit dem folgenden kleinen
Bash-Skript ging das ganz schnell:

{{< highlight sh >}}
for pic in *.ppm
do
    pnmtojpeg "${pic}" > "${pic/%ppm/jpg}"
done
{{< /highlight >}}

`pnmtojpeg` befindet sich bei Debian und Ubuntu im Paket `netpbm`.


[ppm]: https://www.fileformat.info/format/pbm/egff.htm
[jpeg]: https://de.wikipedia.org/wiki/JPEG
