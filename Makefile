VOLUME=$(shell pwd)
PORT=3050
WITH_R=--volumes-from=rserve
IMAGE=swish

PUBLISH=--publish=${PORT}:3050
DOPTS=--rm ${PUBLISH} -v ${VOLUME}:/data ${WITH_R}

all:
	@echo "Targets"
	@echo
	@echo "image            Build the ${IMAGE} image"
	@echo "rserve           Run the rserve containtainer from image swipl/rserve"
	@echo "run              Run the image (detached)"
	@echo "authenticated    Run the image in authenticated mode"
	@echo "social           Run the image with social login"
	@echo "add-user         Add a user for authenticated mode"
	@echo "interactive      Run the image interactively"


rserve:
	docker run --detach --net=none --name rserve swipl/rserve

image:
	docker build -t ${IMAGE} .

run:
	docker run --detach ${DOPTS} ${IMAGE}

authenticated:
	docker run --detach ${DOPTS} ${IMAGE} --authenticated

social:
	docker run --detach ${DOPTS} ${IMAGE} --social

interactive:
	docker run -it ${DOPTS} ${IMAGE}

add-user:
	docker run -it ${DOPTS} ${IMAGE} --add-user

help:
	docker run -it ${DOPTS} ${IMAGE} --help

