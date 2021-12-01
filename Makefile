VOLUME=$(shell pwd)
PORT=3050
WITH_R=--volumes-from=rserve

PUBLISH=--publish=${PORT}:3050
DOPTS=--rm ${PUBLISH} -v ${VOLUME}:/data ${WITH_R}
IMG=swipl/swish

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
	docker build -t $(IMG) .

run:
	docker run --detach ${DOPTS} $(IMG)

authenticated:
	docker run --detach ${DOPTS} $(IMG) --authenticated

social:
	docker run --detach ${DOPTS} $(IMG) --social

interactive:
	docker run -it ${DOPTS} $(IMG)

add-user:
	docker run -it ${DOPTS} $(IMG) --add-user

help:
	docker run -it ${DOPTS} $(IMG) --help

push:
	docker push $(IMG):latest
