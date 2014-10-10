FROM ubuntu:14.04
MAINTAINER Aleksey Krasnobaev <https://github.com/krasnobaev>

# building wine64

RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git wget;
RUN git clone git://source.winehq.org/git/wine.git /usr/src/wine-git;   \
    git clone git://git.code.sf.net/p/wineasio/code /usr/src/wineasio;  \
    wget http://winezeug.googlecode.com/svn/trunk/install-wine-deps.sh;
RUN sed -i 's/apt-get install /DEBIAN_FRONTEND=noninteractive apt-get install -y /g' install-wine-deps.sh; \
    sh install-wine-deps.sh
RUN mkdir -p /usr/src/wine64 /usr/src/wine32
ENV VERSION 1.7.28
RUN cd /usr/src/wine-git; git checkout wine-$VERSION
WORKDIR /usr/src/wine64

# RUN git pull
RUN /usr/src/wine-git/configure --enable-win64 --prefix=/usr
RUN make
RUN make install

