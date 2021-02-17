.PHONY: all install build release capdefs test smoke gofmt irctest

GO ?= go
GOFMT ?= gofmt

GIT_COMMIT := $(shell git rev-parse HEAD 2> /dev/null)

capdef_file = ./irc/caps/defs.go

all: install

install:
	$(GO) install -v -ldflags "-X main.commit=$(GIT_COMMIT)"

build:
	$(GO) build -v -ldflags "-X main.commit=$(GIT_COMMIT)"

release:
	goreleaser --skip-publish --rm-dist

capdefs:
	python3 ./gencapdefs.py > ${capdef_file}

test:
	GOFMT=$(GOFMT) python3 ./gencapdefs.py | diff - ${capdef_file}
	cd irc && $(GO) test . && $(GO) vet .
	cd irc/caps && $(GO) test . && $(GO) vet .
	cd irc/cloaks && $(GO) test . && $(GO) vet .
	cd irc/connection_limits && $(GO) test . && $(GO) vet .
	cd irc/email && $(GO) test . && $(GO) vet .
	cd irc/flatip && $(GO) test . && $(GO) vet .
	cd irc/history && $(GO) test . && $(GO) vet .
	cd irc/isupport && $(GO) test . && $(GO) vet .
	cd irc/migrations && $(GO) test . && $(GO) vet .
	cd irc/modes && $(GO) test . && $(GO) vet .
	cd irc/mysql && $(GO) test . && $(GO) vet .
	cd irc/passwd && $(GO) test . && $(GO) vet .
	cd irc/sno && $(GO) test . && $(GO) vet .
	cd irc/utils && $(GO) test . && $(GO) vet .
	GOFMT=$(GOFMT) ./.check-gofmt.sh

smoke:
	oragono mkcerts --conf ./default.yaml || true
	oragono run --conf ./default.yaml --smoke

gofmt:
	GOFMT=$(GOFMT) ./.check-gofmt.sh --fix

irctest:
	git submodule update --init
	cd irctest && make integration
