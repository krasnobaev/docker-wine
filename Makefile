IMAGE32 = krasnobaev/wine32
IMAGE64 = krasnobaev/wine64
INSTANCE32 = wine32-builder
INSTANCE64 = wine64-builder
DATAGIT = wine-git
VER     = 1.7.28
NAME    = wine-$(VER)
REV     = -2
BLDVER  = $(NAME)$(REV)
DATA    = $(NAME)-data$(REV)
OUTPUTDIR = ~/

build: buildwine64image startdata buildwine32image buildwine32 copywinetohost

install:
	cd /usr/src/wine-git
	git checkout $(NAME)
	cd /usr/src/wine32
	make install
	cd /usr/src/wine64
	make install
	cp /usr/src/wineasio/wineasio_32bit.dll.so /usr/lib/wine/
	cp /usr/src/wineasio/wineasio_64bit.dll.so /usr/lib64/wine/

#######################################
# WORK WITH IMAGES
buildwine64image:
	docker build -t $(IMAGE64) wine64/

buildwine32image:
	docker build -t $(IMAGE32) wine32/

buildwine32image-alt:
	docker build -t $(IMAGE32)-alt wine32/

rebuildwine64image:
	docker build --no-cache=true -t $(IMAGE64) wine64/

rebuildwine32image:
	docker build --no-cache=true -t $(IMAGE32) wine32/

buildwine32:
	docker run -it --rm --name $(INSTANCE32) --volumes-from $(DATA) $(IMAGE32)

buildwine32-alt:
	docker run -it --rm --name $(INSTANCE32) --volumes-from $(DATA) $(IMAGE32)-alt

startimage64bash:
	docker run -it --rm --name $(INSTANCE64) $(IMAGE64) /bin/bash

startimage32bash:
	docker run -it --rm --name $(INSTANCE32) --volumes-from $(DATA) $(IMAGE32) /bin/bash

startimage32bash-alt:
	docker run -it --rm --name $(INSTANCE32) --volumes-from $(DATA) $(IMAGE32) /bin/bash

stopbuilder32:
	docker stop $(INSTANCE32)
	docker rm $(INSTANCE32)

stopbuilder64:
	docker stop $(INSTANCE64)
	docker rm $(INSTANCE64)

stopbuilders: stopbuilder32 stopbuilder64

enterwine32builder:
	docker-enter $(INSTANCE32)

enterwine64builder:
	docker-enter $(INSTANCE64)

#######################################
# WORK WITH DATA
startdata:
	docker run -dt --name $(DATA) -v /usr/src $(IMAGE64) /bin/bash

stopdata:
	docker stop $(DATA)
	docker rm $(DATA)

restartdata: stopdata startdata

enterdata:
	docker-enter $(DATA)

copywinetohost:
	mkdir -p $(OUTPUTDIR)/$(BLDVER)
	docker run -it --rm --volumes-from $(DATA) \
		-v $(OUTPUTDIR)/$(BLDVER):/tmp/output busybox \
		cp -a /usr/src/wine32 /usr/src/wine64 /usr/src/wineasio /tmp/output/
	#ln -s /usr/local/src/$(NAME)/wine32 /usr/src/wine32
	#ln -s /usr/local/src/$(NAME)/wine64 /usr/src/wine64

copywinetohost-tar:
	mkdir -p $(OUTPUTDIR)
	docker run -it --rm --volumes-from $(DATA) \
		-v $(OUTPUTDIR):/tmp/output ubuntu \
		tar -czf /tmp/output/$(BLDVER).tgz /usr/src/wine32 /usr/src/wine64 /usr/src/wineasio

