+++
title = "Build Kernel"
date = "2018-02-26T20:25:47+01:00"
author = "Michael Rennecke"
hide_authorbox = true
disable_comments = true
draft = false

tags = ["Ubuntu", "Debian"]
categories = ["Linux"]
+++

Ich im Beitrag [Kernel Bauen] geschrieben, wie man sich einen Linux Kernel
für Debian bzw. Ubuntu selbst bauen kann. Da ich in der letzten Zeit öfter
Kernel baue, habe ich mir ein Skript geschrieben, welches alle Schritte
automatisiert.

Das Skript befindet sich unten.


## build-kernel.sh

```bash
#!/bin/bash
set -e

VERSION=
KERNEL_KEY=38DBBDC86092693E

function usage()
{
    echo ''
    echo "$(basename "$0") --kernel=4.15.6"
    echo 'Build linux kernel'
    printf '\t-h --help\n'
    printf '\t--kernel=<kernel version>\n'
    echo ''
}

while [ "$1" != "" ]; do
    PARAM=$(echo "$1" | awk -F= '{print $1}')
    VALUE=$(echo "$1" | awk -F= '{print $2}')
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --kernel)
            VERSION=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

if [ -z "$VERSION" ]
then
    echo "Parameter --kernel is missing"
    usage
    exit 1
fi

base_url=https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${VERSION}

if [ ! -f "linux-${VERSION}.tar" ] && [ ! -f "linux-${VERSION}.tar.xz" ]
then
    curl "$base_url".tar.xz > "linux-${VERSION}.tar.xz"
    curl "$base_url".tar.sign > "linux-${VERSION}.tar.sign"
fi

if [ ! -f "linux-${VERSION}.tar" ]
then
    unxz "linux-${VERSION}.tar.xz"
fi

gpg2 -k "$KERNEL_KEY" > /dev/null 2>&1
rc=$?
if [[ $rc != 0 ]]
then
    gpg2 --keyserver hkp://keys.gnupg.net --recv-keys "$KERNEL_KEY"
fi

gpg2 --verify "linux-${VERSION}.tar.sign"

[ -d "linux-${VERSION}" ] && rm -rf "linux-${VERSION}"
tar xf "linux-${VERSION}.tar"

cd "linux-${VERSION}"
cp "/boot/config-$(uname -r)" .config
yes '' | make oldconfig
make -j "$(nproc)" deb-pkg LOCALVERSION=-custom
```

[Kernel bauen]: {{< relref "kernel-bauen.md" >}}