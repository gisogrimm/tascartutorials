ALLTSC = $(shell find .. -name "*.tsc")

all: validate

validate: $(ALLTSC:.tsc=.validated)

%.validated: %.tsc
	tascar_validatetsc $< || (echo "$(<):1:";false)
	echo ok > $@
