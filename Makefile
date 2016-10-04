VOLUME=swish-test
PORT=3050
WITH_R=--volumes-from=rserve

PUBLISH=--publish=${PORT}:3050
DOPTS=${PUBLISH} -v ${VOLUME}:/data ${WITH_R}

BOWER=swish-bower-components.zip
BOWER_URL=http://www.swi-prolog.org/download/swish/${BOWER}

all:
	@echo "Targets"
	@echo
	@echo "image            Build the swish image"
	@echo "run              Run the image (detached)"
	@echo "authenticated    Run the image in authenticated mode"
	@echo "add-user         Add a user for authenticated mode"
	@echo "interactive      Run the image interactively"

image:
	docker build -t swish .

swish::
	if [ -d swish ]; then \
	   (cd swish && git pull) ; \
	else \
	   git clone https://github.com/SWI-Prolog/swish.git; \
	fi
	make -C swish clean
	make -C swish bower-components src js css

run:
	docker run --detach ${DOPTS} swish

authenticated:
	docker run --detach ${DOPTS} swish --authenticated

interactive:
	docker run -it ${DOPTS} swish --interactive

add-user:
	docker run -it ${DOPTS} swish --add-user

help:
	docker run -it ${DOPTS} swish --help

