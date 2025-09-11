# First steps in TASCAR

The TASCAR toolbox is designed for creating and rendering virtual acoustic environments. It uses an XML scene definition file format to specify details such as the scene's objects, their positions and orientations, and the audio content.

The TASCAR scene definition file format comprises various elements, including the session, scene, receiver, source, sound and plug-ins. Each element has attributes that define its properties, such as position, orientation and gain. The toolbox also supports various audio plug-ins, including tone generators and speech analysis for lip synchronisation modelling.

## Prerequisites

Connect the audio interface to your computer, and ensure the JACK server is running (e.g., start it with `qjackctl &`). Then, open a terminal and navigate to the `tascartutorials/firststeps` directory:
```bash
cd tascartutorials/firststeps
```

## How to create a scene in TASCAR

Open a text editor of your choice (e.g. `gedit`, or `xmlcopyeditor` - the latter is good for editing TASCAR scenes). TASCAR session files are written in [XML](https://www.w3schools.com/xml/default.asp). The extension of TASCAR files is `.tsc`. The root element of a TASCAR session file is `<session>`. It
can contain one or more scenes `<scene>`, jack port connections
`<connect>`, or other modules `<modules>`. The simpliest session file can look like this:
```xml
<session license="CC0">
  <scene>
    <receiver/>
    <source>
      <sound/>
    </source>
  </scene>
</session>
```
When you load this session file, it will create an acoustic simulation with a colocated source and receiver. No audio content is defined, and no ports are connected, therefore you will not hear anything. For a more functional example, open and edit the file `firststeps.tsc`.

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

## Finding and fixing errors in session files

Of course, errors sometimes occur and there can be many reasons for them. For example, TASCAR will not load a session if critical errors are detected, such as a malformed session file. Sometimes non-critical problems are detected while loading a session or during runtime. These are displayed as warnings. It is highly recommended that you do not use a session in a production setup when a warning is displayed.

Errors and warnings are displayed at the command line and, where possible, in the main window's 'Warnings' tab. To view all warnings and errors, start TASCAR from the command line and monitor the output of that window, especially if something is behaving unexpectedly.

Important points to keep in mind when working with TASCAR:

- Do not try to start TASCAR while a second instance of TASCAR with the same file is still running or attempting to load a session.
- When a session does not load the first time, it will not load the second time either. First, fix the errors.
- TASCAR uses a network socket which is bound to UDP port 9877 by default. It is not possible to start multiple TASCAR sessions simultaneously without changing the port number explicitly.
- Most common errors are caused by malformed XML. Take care to close all elements correctly and pay attention to the hierarchy in the XML files.
- Take care when setting gains and levels. There is no automatic check for excessive sound levels.
- Read the error messages and warnings carefully, and try to understand their meaning.
