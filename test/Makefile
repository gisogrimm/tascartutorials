ALLTSC = $(shell find .. -name "*.tsc")

all: validate

validate: $(ALLTSC:.tsc=.validated)

%.validated: %.tsc
	(tascar_validatetsc -v $< && tascar_renderfile -w -o $@.wav $< -r 48000 -f 1024 -u 1 ) || (echo "$(<):1:";false)
	echo ok > $@

../sensors/sensorinterface.validated: ../sensors/sensorinterface.tsc
	tascar_validatetsc -v $< || (echo "$(<):1:";false)
	echo ok > $@

../sensors/datalogging.validated: ../sensors/datalogging.tsc
	tascar_validatetsc -v $< || (echo "$(<):1:";false)
	echo ok > $@

