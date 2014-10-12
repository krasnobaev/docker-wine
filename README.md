Build wine inside docker container
==================================

If you want latest wine both 32/64 bit you should compile it by yourself.
The problem is that you require to install both 32/64 bit development libraries
on your compiling machine. But you can not to do this if you use containers.

LXC implementation may be simpler, but I don't like LXC.

Current implementation uses two images: one for compiling 64 bit wine and
second for 32 bit wine.

apt-get installs wine to `/usr/bin`, this repository use the same folder.
Therefore you should `apt-get remove` before any `make install`.

There is no ubuntu 32 bit image for docker, but `dpkg --add-architecture i386`
makes possible to done all magic.

Native lxc implementation may be more simpler and effective, but I don't like
lxc.

What has been tested with wine 1.7.28 builded with this doodad:
- [Chaos Theory demo](http://www.pouet.net/prod.php?which=25774) — both 32/64
- Steam — 32 only
- Terraria — 32 only
- FL Studio 11 (64bit installation) — 32 only

other tests — later

Current issues
--------------
`./configure` tells that some features like `OpenCL` is not supported because
it requires some development libraries to be installed.

Prerequisites
-------------
docker

makefile

Possible steps
--------------

Preparing:
```bash
sudo apt-get install docker
git clone https://github.com/krasnobaev/docker-wine
```

Building:
```bash
cd docker-wine
sudo make buildwine64image
sudo make startdata
sudo make buildwine32image
sudo make buildwine32
sudo make copywinetohost
```

Installing:
```bash
cd /usr/src/wine-git
git checkout $WINE-VERSION
cd /usr/src/wine32
sudo make install
cd /usr/src/wine64
sudo make install
cp /usr/src/wineasio/wineasio_32bit.dll.so /usr/lib/wine/
cp /usr/src/wineasio/wineasio_64bit.dll.so /usr/lib64/wine/
```

ToDo's
------
- make ubuntu/debian package on output
- test whether it is possible to done all magic inside one container
- move wine-git to data container?
- make tests
- install other dependent packages to make possible compiling of full-featured wine
- add option to install in other folder than `/usr/bin`

Links
-----
[Win64 Support for Wine](http://wiki.winehq.org/Wine64) — some notes for wow64
used in this repository by [winehq.org](winehq.org).

[ASIO SDK](http://www.steinberg.net/en/company/developers.html)

my [docker workflow template](https://github.com/krasnobaev/docker-doc-template)

