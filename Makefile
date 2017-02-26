


all: build

build:
	date > trigger
	docker build -t squashfs .

load:
	docker run -it --rm --privileged squashfs
