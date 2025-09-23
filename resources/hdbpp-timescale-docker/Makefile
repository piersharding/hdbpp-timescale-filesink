NAME=hdbpp-timescale
TIMESCALEDB_VER=latest
PG_VER=pg13

default: image

build-files/.built: Dockerfile
	mkdir -p build-files/
	cp -rf ../schema build-files/
#	docker build --build-arg PG_VERSION=$(PG_VER) --build-arg TDB_VERSION=${TIMESCALEDB_VER} -t $(NAME):latest --target hdbpp-timescale .
	docker build --build-arg PG_VERSION=$(PG_VER) --build-arg TDB_VERSION=${TIMESCALEDB_VER} -t $(NAME)-full:latest .
	touch build-files/.built

lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

image: build-files/.built

push: build-files/.built
# User must set this environment variable if they want to push the image to a docker repo
ifndef DOCKER_REGISTRY
	$(error DOCKER_REGISTRY is not set)
endif

	docker tag ${NAME}:latest ${DOCKER_REGISTRY}/${NAME}
	docker push ${DOCKER_REGISTRY}/${NAME}

clean:
	rm -fr build-files

.PHONY: default image clean
