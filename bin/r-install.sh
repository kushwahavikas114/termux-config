#!/bin/sh

# https://conr.ca/post/installing-r-on-android-via-termux/

pkg install curl gnupg
mkdir -p "$PREFIX/etc/apt/sources.list.d/"
echo "deb https://its-pointless.github.io/files/24 termux extras" > "$PREFIX/etc/apt/sources.list.d/pointless.list"
curl "https://its-pointless.github.io/pointless.gpg" | apt-key add

pkg install r-base \
            make \
            clang \
            gcc-9 \
            libgfortran5 \
            openssl \
            libcurl \
            libicu \
            libxml2
