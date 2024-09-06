# Interfacing with MATLAB/GNU Octave for Adaptive Measurements

## Prerequisites
* Connect soundcard to computer

* Open a terminal and navigate to the `tascartutorials/matlab` directory:
```bash
cd tascartutorials/matlab
```
* Ensure the JACK server is running (e.g., start it with `qjackctl &`).

## Part I: Loading/closing a scene, modifying its contents with OSC and recording sounds from the scene


### Step 1: Opening the script and scene file

* To open MATLAB, type `matlab &` in a terminal.
* To open Octave, type `octave --gui &` in a terminal.
* Open the script [`part1_load_osc_and_record.m`](part1_load_osc_and_record.m) in the MATLAB or GNU Octave editor.
* Open the file [`part1.tsc`](part1.tsc) in a text editor.

### Step 2: Follow the instructions in the script

* Follow the instructions in [`part1_load_osc_and_record.m`](part1_load_osc_and_record.m) section by section to:
	+ Load the scene file [`part1.tsc`](part1.tsc) into TASCAR.
	+ Modify scene parameters.
	+ Record stimuli.

## Part II: Modifying an XML document, offline rendering

### Step 1: Load scene and scene definition file

* Load [`part2.tsc`](task2_basic2.tsc) into TASCAR.
* View the corresponding scene definition file in a text editor.

### Step 2: Modify the scene definition file using MATLAB/Octave scripts

* Use [`part2_edit_xml_and_render_ir.m`](task2_example2.m) to modify the [`part2.tsc`](task2_basic2.tsc) scene definition file and save it to a new file.
* Open both the unmodified and modified scene definition files in a text editor.
* Open both files in TASCAR to see and hear the changes.

### Step 3: Render the static impulse response and image source model

* Using [`part2_edit_xml_and_render_ir.m`](task2_example2.m), render the static impulse response and image source model of the modified and unmodified scenes.
* Compare the rendered signals to see the effects of the modifications.

## Part III: AFC experiment

Design your own AFC experiment with TASCAR and the TASCAR MATLAB tools. Can you measure the Minimum Audible Angle (MAA) in noise as a function of noise direction? Or the spatial release of masking?

Have a look at the TASCAR file [`maa.tsc`](maa.tsc) and adjust it if necessary. You can use the small AFC toolbox in this directory. Enter 
```
afcgui maa subjectid
```
in MATLAB to start a sample measurement. Modify the functions [`afccfg_maa.m`](afccfg_maa.m) and [`afc_maa_play_interval.m`](afc_maa_play_interval.m) according to your needs.
