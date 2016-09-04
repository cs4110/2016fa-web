.PHONY: build clean view serve

build: node_modules
	npm run build

serve: node_modules
	npm run serve

clean:
	rm -rf build

view:
	open build/index.html

node_modules: package.json
	npm install
