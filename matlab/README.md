# Interfacing from MATLAB/GNU Octave for adaptive measurements

Open a terminal, and type:
```
cd tascartutorials/matlab
```
Make sure that the jack server is running (e.g., start it with `qjackctl`).

## Part 1: Loading/closing a scene, modifying its contents with OSC, and recording sounds from the scene

- Open the script [`part1_example1_1.m`](part1_example1_1.m) in the MATLAB or GNU Octave editor, and the file
[`part1_basic1.tsc`](part1_basic1.tsc) in a text editor. To open MATLAB, type `matlab &` in a terminal. Octave
can be started by typing `octave --gui &`.
- Follow the instructions in [`part1_example1_1.m`](part1_example1_1.m) section by section to load [`part1_basic1.tsc`](part1_basic1.tsc) into TASCAR,
modify scene parameters and record stimuli.

## Part II: Modifying an XML document, offline rendering
