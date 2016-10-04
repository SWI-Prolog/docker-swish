VOLUME=swish-test
PORT=3050
WITH_R=--volumes-from=rserve

PUBLISH=--publish=${PORT}:3050
DOPTS=${PUBLISH} -v ${VOLUME}:/data ${WITH_R}

image:
	docker build -t swish .

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

