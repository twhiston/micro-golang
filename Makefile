ifneq ($(MAKECMDGOALS),test)
include ./context/$(context)/env_make
else
include ./tests/env_make
endif

.PHONY: build push shell run start stop rm release buildtest test clean default all

all: clean build push

build:
	docker build -t $(NS)/$(REPO):$(VERSION) ./context/$(context)

push:
	docker push $(NS)/$(REPO):$(VERSION)

shell:
	docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

buildtest:
	docker build -t $(NS)/$(REPO):$(VERSION) ./tests


test: buildtest
	  docker run --rm $(NS)/$(REPO):$(VERSION)

clean:
	docker rmi -f $(shell docker inspect --format="{{.Id}}" $(NS)/$(REPO):$(VERSION) )

default: build