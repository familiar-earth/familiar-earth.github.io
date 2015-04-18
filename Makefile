all: demo

DEMO_NAME = Demo
SRC_DEMO_NAME = Interpolation
CJS_DIST      = Cesium-1.8

CJS_DIST_FILE = $(CJS_DIST).zip
CJS_DIST_URL  = https://cesiumjs.org/releases/$(CJS_DIST_FILE)

DEMO_FILE = $(CJS_DIST)/Apps/Sandcastle/gallery/$(DEMO_NAME).html
SRC_DEMO_FILE = $(CJS_DIST)/Apps/Sandcastle/gallery/$(SRC_DEMO_NAME).html

demo: $(DEMO_FILE)

clean:
	rm -f $(DEMO_FILE)

realclean: clean
	rm -f $(CJS_DIST)/.unzipped
	rm -rf $(CJS_DIST)
	rm -f $(CJS_DIST_FILE)

server: all
	@echo http://localhost:8000/$(DEMO_FILE)
	python -m SimpleHTTPServer

$(CJS_DIST_FILE):
	curl -RO $(CJS_DIST_URL)

$(CJS_DIST)/.unzipped: $(CJS_DIST_FILE)
	unzip $< -d $(CJS_DIST)
	touch $@

$(DEMO_FILE): $(SRC_DEMO_FILE) $(CJS_DIST)/.unzipped
	cat < $< > $@

.PHONY: all clean realclean server demo
