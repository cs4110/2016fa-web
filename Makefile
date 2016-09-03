.PHONY: build clean

build: node_modules
	npm run build

clean:
	rm -rf build

node_modules: package.json
	npm install
