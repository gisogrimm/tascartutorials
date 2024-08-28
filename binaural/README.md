# Interactive Binaural Synthesis, Head Tracking, and openMHA


## Prerequisites

* Open a terminal and navigate to the `tascartutorials/binaural` directory:
```bash
cd tascartutorials/binaural
```
* Ensure the JACK server is running (e.g., start it with `qjackctl &`).


## Step 1: Interactive binaural synthesis

TASCAR currently supports two methods of binaural synthesis: either use parametric binaural synthesis with a receiver of `type="hrtf"`, or convolution with HRIR, by rendering it to (virtual) loudspeakers, e.g., with a receiver of `type="hoa2d"`. In this step you may compare these options.

Look at the file `binaural.tsc`. The scene contains two speech sources and a diffuse background sound field. It also contains two receivers - a parametric HRTF simulation with the name "param", and a convolution with an HRIR database with the name "conv". Compare the sound of the two while navigating your listening position interactively with the "simplecontroller" module. To switch between the two you may use the mute buttons of the receivers.

## Step 2: Head tracking for interactive binaural synthesis

You may use our low-cost DIY head tracker with the `oscheadtracker` actor module. Uncomment the module, connect the head tracker to a power supply (e.g., USB port of your computer), keep it still during the first couple of seconds, and connect to its WLAN. To connect it to TASCAR, add the module `oscheadtracker` to the list of modules (uncomment the example code in file `binaural.tsc`). Again, try to compare binaural rendering methods, and play around with front-back confusion.

## Step 3: Connect the openMHA and measure SNR benefit in real-time

The file `snrbenefit.tsc` is a slightly modified version of the previous file. It uses different layers for target and noise signals, to allow measurement of SNR, and estimation of SNR benefit by applying a real-time version of the Hagerman & Olofsson (2004) method.
