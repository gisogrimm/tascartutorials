# First steps

## Prerequisites

* Connect the audio interface to your computer
* Open a terminal and navigate to the `tascartutorials/firststeps` directory:
```bash
cd tascartutorials/firststeps
```
* Ensure the JACK server is running (e.g., start it with `qjackctl &`).

## How to create a scene in TASCAR

* Open the **user manual** [locally](file:///usr/share/doc/tascar/manual.pdf) or [on github](https://github.com/gisogrimm/tascar/wiki/master/manual.pdf)You can use
the manual as an important source of information throughout the workshop.

* Open a text editor (e.g. `gedit`, or `xmlcopyeditor` - the latter is good for editing TASCAR scenes) and open the basic example `firststeps.tsc`. You can create your own copy,
e.g. `Group1_Task1.tsc`. This can be your own scene definition xml file.

* Start TASCAR, either from the applications menu, or the command line, which is the preferred
way, because in case of problems it may print additional information to the command line.

* Load your scene into TASCAR. Compare your scene definition file with what you see in the
TASCAR window. Try to identify the objects in the scene and look at the xml window to see
how they are defined and what other parameters they have. You can always change/add/modify
things in the scene, using your editor. To see and hear what happens, press the "reload" button.

* Visualize the audio signal flow chart with [patchage](https://drobilla.net/software/patchage.html), [Catia](https://kx.studio/Applications:Catia) or [qjackctl](https://qjackctl.sourceforge.io/), and have a look at the
audio ports. Try to recognize the ports corresponding to sources and receiver in the scene. Try
to connect/disconnect ports.

* Be creative and compose your own scene. Use chapters 3-5 of the user manual - there
you will find an introduction to creating a scene and a description of all the configurable parameters. Have a look at other `tsc` files, for example in the `glabscenes` directory (if you are using any of our lab computers) or in
`/usr/share/tascar/examples/` You can also open them from the TASCAR menu "File"
-> "Examples" (Ctrl-X). You can add any of the following objects to your scene:

    * point sources (`<source ...><sound/></source>`) (5.3)
    * diffuse sound fields (`<diffuse ...>`) (5.4)
    * receiver (`<receiver .../>`) (5.5)
    * reflectors (`<face .../>` or `<facegroup .../>`) (5.9)


* On our lab computers, open directory with TASCAR scenes: `glabscenes/` - you will find many
examples of TASCAR scenes as well as tons of sound samples there. Another good source of sounds is [freesound](https://freesound.org/) All objects can move or
change their orientation. You can assign any available sound samples to your sources. You can
create different rooms and try different receivers. Be creative and have fun!