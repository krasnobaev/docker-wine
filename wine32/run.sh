#!/bin/bash
/usr/src/wine-git/configure --with-wine64=../wine64 --prefix=/usr
make
make install
exec "$@"

