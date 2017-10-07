VOLUME=$(shell pwd)
PORT=3050
WITH_R=--volumes-from=rserve

PUBLISH=--publish=${PORT}:3050
DOPTS=${PUBLISH} -v ${VOLUME}:/data ${WITH_R}

all:
	@echo "Targets"
	@echo
	@echo "image            Build the swish image"
	@echo "run              Run the image (detached)"
	@echo "authenticated    Run the image in authenticated mode"
	@echo "social           Run the image with social login"
	@echo "add-user         Add a user for authenticated mode"
	@echo "interactive      Run the image interactively"

image::
	docker build -t swish .

run:
	docker run --detach ${DOPTS} swish

authenticated:
	docker run --detach ${DOPTS} swish --authenticated

social:
	docker run --detach ${DOPTS} swish --social

interactive:
	docker run -it ${DOPTS} swish

add-user:
	docker run -it ${DOPTS} swish --add-user

help:
	docker run -it ${DOPTS} swish --help

