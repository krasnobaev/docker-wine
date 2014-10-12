#!/bin/bash
LOG=/var/log

# make wine32
cd /usr/wine32
/usr/src/wine-git/configure --with-wine64=../wine64 --prefix=/usr 2> >(tee $LOG/wine32-config-error.log) > >(tee $LOG/wine32-config.log)
make -j$(nproc) 2> >(tee $LOG/wine32-build-error.log) > >(tee $LOG/wine32-build.log)
make install 2> >(tee $LOG/wine32-install-error.log) > >(tee $LOG/wine32-install.log)

cd /usr/src/wine64
make install
cd /usr/src/wineasio
make -j$(nproc) 2> >(tee $LOG/wineasio32-build-error.log) > >(tee $LOG/wineasio32-build.log)
mv wineasio.dll.so wineasio_32bit.dll.so

exec "$@"

