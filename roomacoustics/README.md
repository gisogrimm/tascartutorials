# Image source model, diffuse sound fields and reverberation

In this session, you'll learn the basics of creating room acoustic environments in TASCAR using pre-built room models as examples. You'll gain hands-on experience in defining room dimensions, surfaces, and reverberation parameters, and see how these settings impact both diffuse and point sound sources.

You'll also delve into TASCAR's approach to implementing scattering, gaining a deeper understanding of how acoustic simulations work. Additionally, you'll explore the rendering of impulse responses to evaluate the acoustic characteristics of a room, including its reverberation time, echo patterns, and overall sound quality.

By the end of this session, you'll be able to create plausible room acoustic simulations in TASCAR.

See section 5.9 (Reflectors) in the TASCAR manual, and [zenodo.org/communities/audiovisual_scenes](https://zenodo.org/communities/audiovisual_scenes/) for open repositories with 3D-models of existing rooms.


## Prerequisites

Open a terminal and navigate to the `tascartutorials/roomacoustics` directory:
```bash
cd tascartutorials/roomacoustics
```

Ensure the JACK server is running (e.g., start it with `qjackctl &`).

## Step 1: Create early reflections with the Image Source Model

An Image Source Model (ISM) creates "image sources" by creating a virtual sound source at the position where it would appear to be, given a reflector, a primary source position, and for "visibility" testing also the receiver position. Higher order ISMs create additional image sources from the combination of image sources and reflectors.

The ISM in TASCAR treats image sources in the same way as primary sound sources. The only difference is that the signal and position of the image source depends on the properties of the reflectors and the position and orientation of the primary sound source, the reflectors and the receiver.

A **single rectangular reflector** can be added with the `<face/>` element, a group of reflectors (e.g. created in 3D editing software) can be added with the `<facegroup/>` element, see section 5.9 of the user manual.  Note that reflectors in TASCAR are acoustically transparent, which means that any sound will pass through them without any modifications. To create opaque objects use the `<obstacle/>` element (see section 5.10 of the manual).

Open the file [`ism.tsc`](ism.tsc) in a text editor. Play around with the single rectangular reflector first:

```
<face name="single">
<position>0 -1 -0.5 -0.5</position>
</face>
```

In TASCAR press the "play" button to start playback of the sounds. Rewind the time line to zero if you cannot hear any changes. The scene will loop when reaching its end.
Move around using the "simplecontroller" interface. Mute and unmute the reflector and listen to the difference.

Now replace the single reflector with a **shoebox-shaped room**:

```
<facegroup damping="0.2" name="shoebox" shoebox="5 4.4 2.9"/>
```

In a closed room a higher order of reflections would be expected, but by default the ISM order is limited to the first order. To enable second order modelling, set the scene attribute `ismorder="2"`. Note that each image source is modelled in the same way as a primary source, with an explicit acoustic path model. Therefore, higher ISM orders require a lot of computing power. In a scene with one primary source and a shoebox shaped room, order 1 results in a total number of 7 sources, order 2 in 37 sources, order 3 in 187, order 4 in 937, order 5 in 4867 sources and so on, with an exponential growth.

You may have noticed the damping and reflectivity attributes. These are the filter coefficients of the reflection filters. These can be set explicitly or derived from materials. A number of material definitions are built into TASCAR, see section 5.9 of the manual for a list of pre-defined materials. For example, to use the "concrete" material from this list, set the property `material="concrete"`.


The next step is to use a **complex reflector** constructed from arbitrary polygon shapes modelled in a 3D editor such as Blender. Unlike computer graphics, where triangularised objects are often used, TASCAR uses flat polygons as reflectors for computational reasons. This is because it creates only a single image source per reflector and primary source, whereas multiple sources would be created in the case of multiple triangles. Please note that the face normal is relevant in TASCAR because sources are only reflected if they and the receiver are on the side of the reflector where the normal points. The right-hand rule is applied to calculate the face normal, i.e. if the vertices on the x-y plane are arranged in a counterclockwise order, the face normal points upwards in the positive z-direction.


The file format used by TASCAR is a plain text format with one line per reflector surface, in each line

```
x1 y1 z1 x2 y2 z2 x3 y3 z3 ...
```
To insert it into the TASCAR scene, type:
```
<facegroup importraw="shape_Cube.raw" name="magicchamber" damping="0.2">
   <orientation>0 -45 0 0</orientation>
</facegroup>
```
A direct import of OBJ or DAE files is planned, but unfortunately not yet possible.

Finally, try out the **obstacle**, and compare the sound effects you hear with Figure 10 of the user
manual.
```
<obstacle name="thewall" transmission="0.1">
  <faces>0 -0.5 -0.5 0 -0.5 0.5 0 0.5 0.5 0 0.5 -0.5</faces>
  <position>
	0 0.75 2 0
	10 0.75 -2 0
  </position>
</obstacle>
```

## Step 2: Late reverberation

In room acoustics, the impulse response is the time-domain representation of how a room responds to a brief, sudden sound, such as a click or a tap. It describes how sound waves bounce off surfaces, decay and interact with the environment. In room acoustic simulation, the impulse response is usually divided into two parts: an early part, which is processed by the image source model, and a late part that is mostly diffuse (i.e. isotropic and spatially decorrelated) due to the numerous reflections.

In TASCAR, diffuse sound fields are rendered using first-order ambisonics (FOA). Ambisonics is a surround sound recording and playback technique that captures and reproduces audio in three dimensions. It uses a specific microphone setup and encoding process to capture the spatial information of the sound field. To create late reverberation in TASCAR, a diffuse sound field is generated from the image source model's output. This can be achieved by convolving the model's output with first-order ambisonics impulse responses (simulated or recorded), or by modelling the diffuse sound field in real time with Feedback Delay Network (FDN) algorithms. An FDN network comprises multiple sound paths, reflection filters, delay lines and a mixing matrix that combines the network's output with its input.

Both methods, convolution and FDN, can be applied with external tools (e.g. [jconvolver](https://kokkinizita.linuxaudio.org/papers/aella.pdf), [RAZR](https://medi.uni-oldenburg.de/razr/), [zita-rev1](https://kokkinizita.linuxaudio.org/linuxaudio/zita-rev1-doc/quickguide.html)) or with internal methods (`<reverb type="foaconv"/>`, `<reverb type="simplefdn"/>`). See section 5.8 of the user manual for details.

Add convolution reverb with the internal tool
`<reverb type="foaconv"/>`:
```
<reverb name="reverb" type="foaconv"
irsname="nuclear_b_format.wav"
volumetric="37 16 9.1" maxlen="50000" image="false" gain="-10"/>
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
[SDM](https://github.com/gisogrimm/tascar/tree/ master/scripts/sdm) toolkit, originally written by Sakari Tervo Jukka Pätynen. See the subdirectory [sdm](sdm). To use it, start Matlab in the current `roomacoustics` folder, and add these paths:
```
addpath /usr/share/tascar/matlab/
addpath sdm
```

To render and visualize the FOA impulse response of the file [`scattering.tsc`](scattering.tsc), type `plot_irhist` in GNU/Octave or Matlab. Play around with the parametrization of scattering. Please note that the signal processing toolbox is required (in Octave, type `pkg load signal`).

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
The Matlab / GNU/Octave toolbox of TASCAR can calculate some commonly used roomacoustic measures:

- **DRR** (`drr.m`) : The DRR (direct-to-reverberant energy ratio) is the ratio of the signal energy of the direct path to the signal energy of the reflected path. This is typically achieved by splitting the impulse response after 5 ms and convolving the signal with both parts of the response. Values are usually given as dB values, i.e. DRR = 10 log₁₀(E_(direct)/E_(reflect)).
- **Reverberation time** (`t60.m`) : The reverberation time is the period during which the impulse response decays by a given ratio, typically 60 dB (1/1000). Depending on the noise floor and the characteristics of the impulse response, other values are sometimes used; for example, 30 dB. However, in this case, the resulting time is scaled to match that of 60 dB.
- **IACC** (`iacc.m`) : Interaural cross-correlation is the correlation between signals recorded in the left and right ears, for example with an artificial head in real rooms or with the HRTF receiver type in a simulated scene. An IACC close to one is caused by a single source without reflections. A low IACC indicates that the diffuse components of the signal, such as late reverberation, dominate.

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
This tool can also be used for measuring impulse responses from a virtual sound source to an artificial head in your lab. In that case, replace 
```
'input',{'render.scene:out_l','render.scene:out_r'}
```
by
```
'input',{'system:capture_1','system:capture_2'}
```
and connect the artificial head to inputs 1 and 2.

## Step 5: Real-time processing of own voice

To process your own microphone with the room acoustics of your TASCAR scene, simply connect the input jack port with the jack port of the sound source. In any variant of `ism*.tsc`, you may remove or mute the `<sndfile .../>` plugin, and add on `<session>` level (typically at the end of the session) a line to permanently connect the ports:
```XML
<connect src="system:capture_1" dest="render.scene:water.0.0"/>
```
Now you should hear your own voice with the early reflections and reverberation of the scene.

Sometimes it is not desirable to simulate the direct source path, e.g., when using a loudspeaker system with other listeners in the same space. In that case, you may set the attribute `ismmin` of the `<sound/>` element to 1:
```XML
<sound ismmin="1"/>
```
However, if you are using also the diffuse reverberation, please note that that plugin is configured t process only the direct path. To solve this problem, the `layers` attribute can be used. Any sound, diffuse sound field and receiver can be restricted to a set of layers. To render the ISM only in one layer, and the reverberation in another layer, duplicate the sound vertex, and configure the layer attributes:
```XML
<sound name="water" layers="1" ismmin="1">...</sound>
<sound name="water_rev" layers="2">...</sound>
```
Now move the receiver to layer 1:
```XML
<receiver layers="1" .../>
```
The reverb plugin should have an input in layer 2 and an output in layer 1:
```XML
<reverb layers="2" outputlayers="1".../>
```
Do not forget to connect also the new sound to the microphone, using a second `<connect .../>` element.

For interactive processing of your own voice (or any other real-time input), you may want to decrease the overall latency. To do so, you need to configure the jack sound server to use a smaller fragment size, e.g., 64 samples. First, exit TASCAR, and stop the processing. Now, in qjackctl, stop jack and open the setup window. Here you can select a shorter fragment size. Please note that short fragment sizes require a low-delay real-time optimized operating system, e.g., a dedicated Linux kernel, or MacOS.

In TASCAR, many functions are called on every processing cycle, e.g., the geometry is updated at the boundaries of each audio block. This results in an increase of computational load with smaller fragment sizes. If the CPU load displayed in jack (or in the status bar of TASCAR) reaches values above 50-70% and you experience dropouts, you may need to reduce the complexity of the scene:

- use lower ISM order
- use fewer reflectors
- use FDN instead of convolution reverb
- use fewer primary sound sources

On extremely optimized Linux systems or on MacOS, a fragment size of 1-2 ms should be possible with a total of several 100 sound sources. The OVBOX (essentially TASCAR on a Raspberry Pi with dedicated Raspbian OS), fragment sizes of 1-2 ms are possible with approx. 10-30 sound sources. On a non-optimized Linux PC, the smallest possible fragment sizes are probably in the range of 5-10 ms. The total round trip latency is two times the fragment size, plus delays in the simulation, plus hardware delay due to USB transmission, anti-aliasing filters and similar.
