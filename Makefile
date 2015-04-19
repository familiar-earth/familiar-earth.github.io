all: demo

DEMO_NAME       = Demo
SRC_DEMO_NAME   = Interpolation
CJS_DIST        = Cesium-1.8
CAMPAIGN        = HS3-2013
AIRCRAFT        = N871NA
FLIGHT_DATE     = 2013-09-15
FLIGHT          = 16Sep2013-1214

CJS_DIST_FILE   = $(CJS_DIST).zip
CJS_DIST_URL    = https://cesiumjs.org/releases/$(CJS_DIST_FILE)

SRC_DEMO_FILE   = $(CJS_DIST)/Apps/Sandcastle/gallery/$(SRC_DEMO_NAME).html

DEMO_HTML       = $(DEMO_NAME).html
DEMO_JS         = $(DEMO_NAME).js
DEMO_CSV        = $(DEMO_NAME).csv

IWG1_URL_PRE    = http://asp-archive.arc.nasa.gov/$(CAMPAIGN)/$(AIRCRAFT)/$(FLIGHT_DATE)/
IWG1_FLIGHT     = IWG1.$(FLIGHT)
IWG1_XML        = IWG1.xml
IWG1_FLIGHT_URL = $(IWG1_URL_PRE)$(IWG1_FLIGHT)
IWG1_XML_URL    = $(IWG1_URL_PRE)$(IWG1_XML)
IWG1_FIELDS     = IWG1.csv

demo: $(DEMO_HTML) $(DEMO_JS) $(DEMO_CSV)

clean:
	$(RM) $(DEMO_JS) $(DEMO_CSV)
	$(RM) $(IWG1_FIELDS)

realclean: clean
	$(RM) $(CJS_DIST)/.unzipped
	$(RM) -r $(CJS_DIST)
	$(RM) $(CJS_DIST_FILE)
	$(RM) $(IWG1_FLIGHT) $(IWG1_XML)

server: all
	@echo http://localhost:8000/$(DEMO_HTML)
	python -m SimpleHTTPServer

$(CJS_DIST_FILE):
	curl -RO $(CJS_DIST_URL)

$(CJS_DIST)/.unzipped: $(CJS_DIST_FILE)
	unzip $< -d $(CJS_DIST)
	touch $@

$(IWG1_FLIGHT):
	curl -RO $(IWG1_FLIGHT_URL)

$(IWG1_XML):
	curl -RO $(IWG1_XML_URL)

$(IWG1_FIELDS): $(IWG1_XML)
	./convert_iwg1_xml_to_csv < $< > $@

$(DEMO_CSV): $(IWG1_FIELDS) $(IWG1_FLIGHT)
	cat $(IWG1_FIELDS) $(IWG1_FLIGHT) > $@

$(DEMO_JS): $(DEMO_CSV)
	./build_demo_js --campaign=$(CAMPAIGN) --aircraft=$(AIRCRAFT) --flight=$(FLIGHT) < $< > $@

.PHONY: all clean realclean server demo
