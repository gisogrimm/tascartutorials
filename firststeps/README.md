# First Steps in TASCAR

The TASCAR toolbox is designed for creating and rendering virtual acoustic environments. It uses an XML scene definition file format to specify details such as the scene's objects, their positions and orientations, and the audio content.

The TASCAR scene definition file format comprises various elements, including `session`, `scene`, `receiver`, `source`, `sound`, and plugins. Each element has attributes that define its properties, such as position, orientation, and gain. The toolbox also supports various audio plugins, including tone generators and speech analysis tools for lip-sync modeling.

## Prerequisites

Connect your audio interface to your computer, and ensure the JACK server is running (e.g., start it with `qjackctl &`). Then, open a terminal and navigate to the `tascartutorials/firststeps` directory:

```bash
cd tascartutorials/firststeps
```

## How to Create a Scene in TASCAR

Open a text editor of your choice (e.g., `gedit` or `xmlcopyeditor` - the latter is particularly useful for editing TASCAR scenes). TASCAR session files are written in [XML](https://www.w3schools.com/xml/default.asp). The file extension for TASCAR files is `.tsc`. The root element of a TASCAR session file is `<session>`, which can contain one or more scenes (`<scene>`), JACK port connections
(`<connect>`), or other modules (`<modules>`).

A minimal session file might look like this:

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

When you load this session file, it creates an acoustic simulation with a colocated source and receiver. No audio content is defined, and no ports are connected, so you will hear nothing. For a more functional example, open and edit the file `firststeps.tsc`.

Now, start TASCAR either from the Applications menu or from the command line. The latter is preferred, as it may display additional diagnostic information if problems occur:

```bash
tascar &
```

Load your scene into TASCAR. Compare the scene definition file with what you see in the TASCAR window. Identify the objects in the scene, then examine the XML window to see how they are defined and what parameters are available. You can always modify, add, or remove elements using your text editor. Press the **Reload** button to see and hear the changes.

You can visualize the audio signal flow using [patchage](https://drobilla.net/software/patchage.html), [Catia](https://kx.studio/Applications:Catia), or [qjackctl](https://qjackctl.sourceforge.io/), and inspect the audio ports. This can be helpful for debugging audio routing. Try to identify the ports corresponding to sources and receivers in the scene. Experiment with connecting and disconnecting ports. Useful command-line tools for listing ports include `jack_lsp` and `tascar_lsjackp`.

Get creative and design your own scene. Refer to Chapters 3–5 of the user manual for an introduction to scene creation and a detailed description of all configurable parameters. Explore other `.tsc` files—for example, they may be located in the `glabscenes` directory on lab computers, or in `/usr/share/tascar/examples/`. Alternatively, you can open them from the TASCAR menu: **File** → **Examples** (Ctrl+X).

You can add the following objects to your scene:

- Point sources (`<source ...><sound/></source>`) (Section 5.3)
- Diffuse sound fields (`<diffuse ...>`) (Section 5.4)
- Receivers (`<receiver .../>`) (Section 5.5)
- Reflectors (`<face .../>` or `<facegroup .../>`) (Section 5.9)

On lab computers, navigate to the `glabscenes/` directory—you’ll find many example TASCAR scenes as well as a large collection of sound samples. Another excellent source of audio is [freesound.org](https://freesound.org/).

All objects can move or change their orientation. You can assign any available sound sample to your sources. Create different room environments and experiment with various receiver configurations. Be creative and have fun!

## Finding and Fixing Errors in Session Files

Errors occasionally occur, and there are many possible causes. For example, TASCAR will fail to load a session if critical errors are detected—such as a malformed XML file. Non-critical issues may also be reported during loading or runtime; these appear as warnings. It is strongly recommended that you do not use a session in a production environment if warnings are displayed.

### Common Errors

- **Malformed XML**: Missing closing tags (e.g., `<source>` without `</source>`).
  *Fix*: Ensure all tags are properly closed and nested correctly.
  
- **Missing Sound License**: TASCAR issues a warning if the license type of a sound file is missing.
  *Fix*: Add the license information in a `.license` file (see Manual for details).

Errors and warnings are displayed in the command-line output and, where applicable, in the main window’s **Warnings** tab. To view all messages, start TASCAR from the command line and monitor the output—this is especially helpful when something behaves unexpectedly.

### Important Tips When Working with TASCAR

- Do not attempt to start TASCAR while another instance is already running or attempting to load the same session file.
- If a session fails to load the first time, it will not load the second time either. Fix the errors before retrying.
- TASCAR uses a network socket bound to UDP port 9877 by default. You cannot run multiple TASCAR sessions simultaneously without explicitly changing the port number.
- Most common errors stem from malformed XML. Be meticulous about closing all elements and maintaining proper XML hierarchy.
- Exercise caution when setting gains and levels—TASCAR performs no automatic checks for excessive sound levels.
- Read error messages and warnings carefully, and try to understand their meaning to resolve issues efficiently.
