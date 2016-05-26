image:
	docker build -t swish .

run:
	docker run --detach --publish=3050:3050 swish
