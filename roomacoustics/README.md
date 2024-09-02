# Image source model, diffuse sound fields and reverberation

## Prerequisites

Open a terminal and navigate to the `tascartutorials/roomacoustics` directory:
```bash
cd tascartutorials/roomacoustics
```

Ensure the JACK server is running (e.g., start it with `qjackctl &`).

## Step 1: Create early reflections with the Image Source Model

The image source model in TASCAR treats image sources in the same way as primary sound
sources. The only difference is that the signal and the position of the image source depend on the
properties of the reflectors and on the position and orientation of the primary sound source, the
reflectors and the receiver.

A single reflector can be added with the `<face/>` element, a set of reflectors (e.g., created in
3D-editing software) can be added with the `<facegroup/>` element, see Section 5.9 of the user
manual.
Please note that reflectors in TASCAR are acoustically transparent. To create intransparent objects,
use the `<obstacle/>` element (Section 5.10 in the manual).

Open the file [`ism.tsc`](ism.tsc) in a text editor. First, play around with the single reflector:  
```
<face name="single">
<position>0 -1 -0.5 -0.5</position>
</face>
```
Move around using the “simplecontroller” interface. Mute and unmute the reflector, and listen to the difference.

Replace the single reflector by a shoebox-shaped room:
```
<facegroup damping="0.2" name="shoebox" shoebox="5 4.4 2.9"/>
```
You may have noticed the damping and reflectivity attributes. These are filter coefficients of the reflection filters. These can be explicitly  set, or derived from materials. A number of material definitions is built into TASCAR, see section 5.9 of the manual. For example, to use the "concrete" material of that list, set the property `material="concrete"`.

Use a reflector modeled in a 3D editor, e.g., blender. The file format used by TASCAR is a
plain text format with one line per reflector face, in each line
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

To create diffuse reverberation in TASCAR, a diffuse sound field is generated from the output of the
image source model. In principle, this can be done by convolving the output of the image source
model with (simulated or recorded) first order Ambisonics impulse responses, or the diffuse sound
field signal can be modelled in real time, e.g. with Feedback Delay Network (FDN) algorithms. Both
methods can be applied with external tools (e.g. [jconvolver](https://kokkinizita.linuxaudio.org/papers/aella.pdf), [RAZR](https://medi.uni-oldenburg.de/razr/), [zita-rev1](https://kokkinizita.linuxaudio.org/linuxaudio/zita-rev1-doc/quickguide.html)) or with internal
methods (`<reverb type="foaconv"/>`, `<reverb type="simplefdn"/>`). For details, see
section 5.8 of the user manual.

## Step 3: Scattering in TASCAR

For visualization of scattering we added the 
[SDM](https://github.com/gisogrimm/tascar/tree/ master/scripts/sdm) toolkit, originally written by Sakari Tervo Jukka Pätynen. See subfolder [sdm](sdm). To use it, start Matlab, and add these paths:
```
addpath /usr/share/tascar/matlab/
addpath sdm
```

To render and visualize the FOA impulse response of the file [`scattering.tsc`](scattering.tsc), type `plot_irhist` in Matlab.
