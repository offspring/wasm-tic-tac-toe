
CMAKE_BUILD_DIR:=$(CURDIR)/cmake-bld.local
BUILD_TYPE:=Release

EMSDK_DIR?=$(CURDIR)/emsdk
EMSCRIPTEN_CMAKE?="$(EMSDK_DIR)/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake"

all:

$(CMAKE_BUILD_DIR):
	mkdir -p $(CMAKE_BUILD_DIR)
	cmake \
	  -DCMAKE_TOOLCHAIN_FILE=$(EMSCRIPTEN_CMAKE) \
	  -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE \
	  -DCMAKE_BUILD_TYPE:STRING=$(BUILD_TYPE) \
	  -S$(CURDIR) -B$(CMAKE_BUILD_DIR) -G Ninja

configure:
	rm -rf $(CMAKE_BUILD_DIR)
	$(MAKE) $(CMAKE_BUILD_DIR)

.PHONY: build
build: $(CMAKE_BUILD_DIR)
	cmake --build $(CMAKE_BUILD_DIR) --config $(BUILD_TYPE) --target all --verbose

.PHONY: clean
clean:
	cmake --build $(CMAKE_BUILD_DIR) --verbose --target clean

.PHONY: distclean
distclean:
	rm -rf $(CMAKE_BUILD_DIR)
	rm -rf dist

.PHONY: server
server:
	python3 -m http.server -d $(CURDIR)/dist

.PHONY: publish
publish:
	git subtree push --prefix dist origin gh-pages
