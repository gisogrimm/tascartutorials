# First steps in TASCAR

The TASCAR toolbox is designed for creating and rendering virtual acoustic environments. It uses an XML scene definition file format to specify details such as the scene's objects, their positions and orientations, and the audio content.

The TASCAR scene definition file format comprises various elements, including the session, scene, receiver, source, sound and plug-ins. Each element has attributes that define its properties, such as position, orientation and gain. The toolbox also supports various audio plug-ins, including tone generators and speech analysis for lip synchronisation modelling.

## Prerequisites

Connect the audio interface to your computer, and ensure the JACK server is running (e.g., start it with `qjackctl &`). Then, open a terminal and navigate to the `tascartutorials/firststeps` directory:
```bash
cd tascartutorials/firststeps
```

## How to create a scene in TASCAR

Open a text editor of your choice (e.g. `gedit`, or `xmlcopyeditor` - the latter is good for editing TASCAR scenes) and open the basic example `firststeps.tsc`. You can create your own copy of this file, e.g. `Group1_Task1.tsc`. This will be your own scene definition XML file.

Now, start TASCAR either from the Applications menu or from the command line. The latter is the preferred method because, if there are any problems, it may print additional information to the command line.
```bash
tascar &
```

Load your scene into TASCAR. Compare the scene definition file with what you can see in the TASCAR window. Identify the objects in the scene, then look at the XML window to see how they are defined and what other parameters they have. You can always change, add to or modify things in the scene using your editor. Press the 'reload' button to see and hear what happens.

You can visualize the audio signal flow chart with [patchage](https://drobilla.net/software/patchage.html), [Catia](https://kx.studio/Applications:Catia) or [qjackctl](https://qjackctl.sourceforge.io/), and have a look at the audio ports. Try to recognize the ports corresponding to sources and receiver in the scene. Try to connect/disconnect ports.

Get creative and design your own scene. Refer to chapters 3–5 of the user manual for an introduction to scene creation and a description of all the configurable parameters. Take a look at the other 'tsc' files. For example, you can find them in the 'glabscenes' directory if you are using one of our lab computers, or in '/usr/share/tascar/examples/'. Alternatively, you can open them from the TASCAR menu: 'File' -> 'Examples' (Ctrl+X). You can add any of the following objects to your scene:

- point sources (`<source ...><sound/></source>`) (5.3)
- diffuse sound fields (`<diffuse ...>`) (5.4)
- receiver (`<receiver .../>`) (5.5)
- reflectors (`<face .../>` or `<facegroup .../>`) (5.9)

On our lab computers, open directory with TASCAR scenes: `glabscenes/` - you will find many examples of TASCAR scenes as well as tons of sound samples there. Another good source of sounds is [freesound](https://freesound.org/) All objects can move or change their orientation. You can assign any available sound samples to your sources. You can create different rooms and try different receivers. Be creative and have fun!
