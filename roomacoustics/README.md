# Image source model, diffuse sound fields and reverberation

## Prerequisites

Open a terminal and navigate to the `tascartutorials/roomacoustics` directory:
```bash
cd tascartutorials/roomacoustics
```

Ensure the JACK server is running (e.g., start it with `qjackctl &`).

## Step 1: Create early reflections with the Image Source Model

The Image Source Model (ISM) in TASCAR treats image sources in the same way as primary sound sources. The only difference is that the signal and position of the image source depends on the properties of the reflectors and the position and orientation of the primary sound source, the reflectors and the receiver.

A single reflector can be added with the `<face/>` element, a group of reflectors (e.g. created in 3D editing software) can be added with the `<facegroup/>` element, see section 5.9 of the user manual.  Note that reflectors in TASCAR are acoustically transparent. To create opaque objects use the `<obstacle/>` element (see section 5.10 of the manual).

Open the file [`ism.tsc`](ism.tsc) in a text editor. Play around with the single reflector first:

```
<face name="single">
<position>0 -1 -0.5 -0.5</position>
</face>
```

In TASCAR press the "play" button to start playback of the sounds. Rewind the time line to zero if you cannot hear any changes. The scene will loop when reaching its end.
Move around using the "simplecontroller" interface. Mute and unmute the reflector and listen to the difference.

Replace the single reflector with a shoebox-shaped room:

```
<facegroup damping="0.2" name="shoebox" shoebox="5 4.4 2.9"/>
```

In a closed room a higher order of reflections would be expected, but by default the ISM order is limited to the first order. To enable second order modelling, set the scene attribute `ismorder="2"`. Note that each image source is modelled in the same way as a primary source, with an explicit acoustic path model. Therefore, higher ISM orders require a lot of computing power.

You may have noticed the damping and reflectivity attributes. These are the filter coefficients of the reflection filters. These can be set explicitly or derived from materials. A number of material definitions are built into TASCAR, see section 5.9 of the manual. For example, to use the "concrete" material from this list, set the property `material="concrete"`.


Use a reflector modelled in a 3D editor such as Blender. The file format used by TASCAR is a plain text format with one line per reflector surface, in each line

```
x1 y1 z1 x2 y2 z2 x3 y3 z3 ...
```
To insert it into the TASCAR scene, type:
```
<facegroup importraw="shape_Cube.raw" name="magicchamber" damping="0.2">
   <orientation>0 -45 0 0</orientation>
</facegroup>
```
A direct import of OBJ or DAE files is planned, but not yet possible.

Now try out the obstacle, and compare the sound effects you hear with Figure 10 of the user
manual.
```
<obstacle name="thewall" transmission="0.1">
  <faces>0 -0.5 -0.5 0 -0.5 0.5 0 0.5 0.5 0 0.5 -0.5</faces>
<position>0
```

## Step 2: Diffuse reverberation

To create diffuse reverberation in TASCAR, a diffuse sound field is generated from the output of the image source model. In principle, this can be done by convolving the output of the image source model with (simulated or recorded) first order Ambisonics impulse responses, or the diffuse sound field signal can be modelled in real time, e.g. with Feedback Delay Network (FDN) algorithms. Both methods can be applied with external tools (e.g. [jconvolver](https://kokkinizita.linuxaudio.org/papers/aella.pdf), [RAZR](https://medi.uni-oldenburg.de/razr/), [zita-rev1](https://kokkinizita.linuxaudio.org/linuxaudio/zita-rev1-doc/quickguide.html)) or with internal methods (`<reverb type="foaconv"/>`, `<reverb type="simplefdn"/>`). See section 5.8 of the user manual for details.

Add convolution reverb with the internal tool
`<reverb type="foaconv"/>`:
```
<reverb name="reverb" type="foaconv"
irsname="nuclear_b_format.wav"
volumetric="37 16 9.1" maxlen="100000" image="false" gain="-10"/>
```

Note that TASCAR currently uses a partitioned convolution with a fixed partition size.  This is not very efficient for long impulse responses and short audio block sizes. In this case the use of the external tool `jconvolver` is recommended.

This code reduces the gain by 10dB to achieve a similar Direct to Reverberant Ratio (DRR) as the FDN based reverb.


Add FDN based reverb with the internal tool `<reverb type="simplefdn"/>`:
```
<reverb name="reverb" type="simplefdn"
volumetric="37 16 9.1" image="false" damping="0.4" absorption="0.3" gain="15"/>
```

Try different values for damping and absorption. It is possible to truncate the first loop in the feedback delay network and model the early reflections only in the ISM by setting the attribute `truncate_forward="1"`.

## Step 3: Scattering in TASCAR

For visualisation of scattering we added the 
[SDM](https://github.com/gisogrimm/tascar/tree/ master/scripts/sdm) toolkit, originally written by Sakari Tervo Jukka Pätynen. See the subdirectory [sdm](sdm). To use it, start Matlab, and add these paths:
```
addpath /usr/share/tascar/matlab/
addpath sdm
```

To render and visualize the FOA impulse response of the file [`scattering.tsc`](scattering.tsc), type `plot_irhist` in Matlab.

## Step 4: Render Impulse Responses

To render impulse responses of a TASCAR file, the command line tool `tascar_renderir` can be used:

```
tascar_renderir ism.tsc -o ir.wav
```

Now load the impulse response into Matlab and plot it:
```
[ir,fs] = audioread('ir.wav');
plot(ir)
```

To calculate the DRR, the Matlab script `drr.m` can be used:
```
drr(ir,fs)
```

The reverberation time can be calculated with the Matlab script `t60.m`, and interaural cross correlation can be calculated with `iacc.m`:

```
t60(ir,fs)
iacc(ir,fs)
```

If you prefer to measure an impulse response from a running TASCAR session in real-time, the Matlab tool `tascar_ir_measure.m` can be used:
```
[ir,fs] = tascar_ir_measure('input',{'render.scene:out_l','render.scene:out_r'},'output',{'render.scene:water.0.0'},'len',96000);
```
