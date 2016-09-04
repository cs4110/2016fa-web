.PHONY: build clean view

build: node_modules
	npm run build

clean:
	rm -rf build

view:
	open build/index.html

node_modules: package.json
	npm install
