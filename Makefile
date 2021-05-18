PROTOC ?= protoc
PROTO_FILES := $(wildcard src/*.proto)
PBS_CS = $(PROTO_FILES:src/%.proto=generated-cs/%.cs)
PBS_TS = $(PROTO_FILES:src/%.proto=generated-ts/%.d.ts)
export PATH := node_modules/.bin:/usr/local/include/:$(PATH)

VERSION = 3.17.0

install_mac: install
	brew install protobuf

install_ubuntu: install
	# Make sure you grab the latest version
	curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v$(VERSION)/protoc-$(VERSION)-linux-x86_64.zip

	# Unzip
	unzip protoc-$(VERSION)-linux-x86_64.zip -d protoc3

	# Move protoc to /usr/local/bin/
	chmod +x protoc3/bin/protoc

	sudo cp -r protoc3/bin/* /usr/local/bin/
	# Move protoc3/include to /usr/local/include/
	sudo cp -r protoc3/include/* /usr/local/include/

  # delete the files
	rm protoc-$(VERSION)-linux-x86_64.zip
	rm -rf protoc3

install:
	npm install
	npm i -D ts-protoc-gen
	npm i -S google-protobuf@$(VERSION)
	npm i -S @types/google-protobuf@latest

generated-cs/%.cs: src/%.proto
	@mkdir -p generated-cs
	${PROTOC} -I="$(PWD)/src" --csharp_out="$(PWD)/generated-cs" "$(PWD)/src/$*.proto"

generated-ts/%.d.ts: src/%.proto
	@mkdir -p generated-ts
	${PROTOC} -I="$(PWD)/src" --js_out=import_style="commonjs_strict,binary:$(PWD)/generated-ts" --ts_out="$(PWD)/generated-ts" "$(PWD)/src/$*.proto"
	@echo 'exports.default = proto;' >> ./generated-ts/$*_pb.js

build: ${PBS_CS} ${PBS_TS}
	${PROTOC} --version

.PHONY: build