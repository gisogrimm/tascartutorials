# Interactive Binaural Synthesis, Head Tracking, and openMHA


## Prerequisites

Open a terminal and navigate to the `tascartutorials/binaural` directory:
```bash
cd tascartutorials/binaural
```

Ensure the JACK server is running (e.g., start it with `qjackctl &`). The files of this tutorial require a sampling rate of 44100 Hz and a fragment size of 512 samples.


## Step 1: Interactive binaural synthesis

TASCAR currently supports two methods of binaural synthesis: either use parametric binaural synthesis with a receiver of `type="hrtf"`, or convolution with HRIR, by rendering it to (virtual) loudspeakers, e.g., with a receiver of `type="hoa2d"`. In this step you may compare these options.

Look at the file [`binaural.tsc`](binaural.tsc). The scene contains two speech sources and a diffuse background sound field. It also contains three receivers - a parametric HRTF simulation with the name "param", a convolution with a hearing aid HRIR database with the name "hrir_kayser", and a convolution with a HRIR database of KU100 artificial head. Compare the sound of the two while navigating your listening position interactively with the "simplecontroller" module. To switch between the receiver types you may use the mute buttons of the receivers.

Compare the receiver definition of the `hrir_kayser` and the `hrir_ku100` receivers. Look at the loudspeaker definition file [`speaker_kayser_30.spk`](speaker_kayser_30.spk).

The SOFA file [HRIR_L2702_NF150.sofa](HRIR_L2702_NF150.sofa) was published by the audio group at TH Köln under a CC BY-SA 4.0 license, see [Neumann KU 100 SOFA files](http://audiogroup.web.th-koeln.de/ku100nfhrir.html) for details.

The database of in-ear and behind-the-ear HRIR is part of this publication:

Kayser, H., Ewert, S. D., Anemüller, J., Rohdenburg, T., Hohmann, V. & Kollmeier, B. (2009). Database of Multichannel In-Ear and Behind-the-Ear Head-Related and Binaural Room Impulse Responses. EURASIP Journal on Advances in Signal Processing, 2009(1). [doi:10.1155/2009/298605](https://doi.org/10.1155/2009/298605)

## Step 2: Head tracking for interactive binaural synthesis

You may use our low-cost DIY head tracker with the `oscheadtracker` actor module. Uncomment the module, connect the head tracker to a power supply (e.g., USB port of your computer), keep it still during the first couple of seconds, and connect to its WLAN. To connect it to TASCAR, add the module `oscheadtracker` to the list of modules (uncomment the example code in file `binaural.tsc`). Again, try to compare binaural rendering methods, and play around with front-back confusion.

## Step 3: Connect the openMHA

The file `snrbenefit.tsc` is a slightly modified version of the previous file. It uses different layers for target and noise signals, to allow measurement of SNR.

Now we use two receivers, one in each layer. Before we add hearing aid signal processing you may try to listen to both S and N separately by muting one of the two receivers.

Now we add an adaptive differential microphone with the openMHA. To start the MHA with an adaptive differential microphone and an optional beamformer for hearing loss correction, you can type this line in the terminal:
```bash
mha ?read:mha_bf_compression.cfg cmd=start
```
Alternartively, you may use a `system` TASCAR module to start this process (and end it when closing TASCAR), by adding these lines to the modules section of the file `snrbenefit.tsc`:
```
<modules>
   ...
   <system command="mha ?read:mha_bf_compression.cfg cmd=start"/>
</modules>
```

Now we can connect our receivers (which actually generate the BTE microphone signals) to the hearing aid, using the `<connect .../>` elements. To ensure that the MHA is properly started before attempting to connect, we can wait for its jack ports to be available, by adding this line to the module block:
```
  <waitforjackport ports="MHA:in_1 MHA:in_2 MHA:in_3 MHA:in_4"/>
```
Instead of connecting the receivers directly to the sound card, we can connect them to the MHA:
```
<connect src="render.scene:out_s.conv.[0123]" dest="MHA:in_[1234]"/>
```

The MHA can be controlled with it's Matlab control interface. To launch this interface, start Matlab or GNU Octave, add the openMHA library path, and start the `mhacontrol` tool:
```
addpath /usr/lib/openmha/mfiles/
mhacontrol
```

To disable the adaptive differential microphone, select "route", to enable it, select "adm".

## Step 4: Measure SNR benefit

For the estimation of SNR benefit of an adaptive (and therefore non-LTI) system it is possible to apply the method of Hagerman & Olofsson (2004) to estimate output SNR of the hearing device:

Hagerman, B. & Olofsson, Å. (2004). A method to measure the effect of noise reduction algorithms using simultaneous speech and noise. Acta Acustica United with Acustica, 90(2), 356–361.

The key concept of this method is to process the signal twice, once with S+N as an input signal, and once with S-N as an input signal. The assumption is that the processing does not depend on the sign of the noise signal. The estimated processed target signal is then $\hat S = \frac12 (O_{S+N} + O_{S-N})$, the estimated processed noise signal is $\hat N = \frac12 (O_{S+N} - O_{S-N})$.

Here we can create both mixtures with TASCAR, and run two instances of the MHA simultaneously.
