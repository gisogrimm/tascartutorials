# Interfacing TASCAR with OSC

The majority of TASCAR options can be controlled remotely via the Open Sound Control (OSC)
(OSC) protocol. For complete OSC specifications, visit [OpenSoundControl.org](https://opensoundcontrol.stanford.edu/). An OSC message consists of an address path string and a format string, which specifies the type of data that follows. OSC messages can be sent over a network using either the [User Datagram Protocol (UDP)](https://en.wikipedia.org/wiki/User_Datagram_Protocol) or the [Transmission Control Protocol (TCP)](https://en.wikipedia.org/wiki/Transmission_Control_Protocol). With UDP, the transmission state is not checked, meaning that messages may be lost during transmission. TCP can guarantee correct transmission (or report an error), but this comes at the cost of longer and less predictable transmission times.

You may use the Linux command line terminal, GNU/Octave or Matlab. To start GNU/Octave on our computers, please open a Terminal, and type:
```bash
octave --gui &
```
Matlab can be started on most computers with:
```bash
matlab -softwareopengl &
```


There is a huge list of tools for sending OSC messages. For the command line, we typically use the `send_osc` tool from the `pyliblo-utils` Debian package. For GNU/Octave and Matlab, the TASCAR installation includes a Java-based tool with the same name (or `send_osc_tcp` for TCP). To add the TASCAR tools for GNU/Octave and Matlab on Linux, type in the Octave or Matlab command window:
```
addpath /usr/share/tascar/matlab/
```

## Step 1: Control playback of a session, and gains of sounds

For this tutorial you can use the session file from the "first steps" tutorial, `firststeps/firststeps.tsc`. Open this session file with TASCAR (in the terminal):
```bash
tascar ../firststeps/firststeps.tsc &
```
On the left side of the main window, you can see the tabs '`1 Map`', '`2 Mixer`', '`3 XML source`', '`4 OSC variables`' and so on. Go to tab '`4 OSC variables`'. Each line in this view represents one internal variable or state control, which can be accessed with OSC. The first entry in each row is the address string, followed by the format string (in brackets). Other optional elements are "r", to indicate that the variable is readable (see below), a suggested value range, the unit string, and a brief documentation. To start the playback of this session, you may type:

| terminal                         | GNU/Octave or Matlab                                |
|----------------------------------|-----------------------------------------------------|
| `send_osc 9877 /transport/start` | `send_osc( 'localhost', 9877, '/transport/start');` |


Similarly, to stop the session, type:

| terminal                        | GNU/Octave or Matlab                               |
|---------------------------------|----------------------------------------------------|
| `send_osc 9877 /transport/stop` | `send_osc( 'localhost', 9877, '/transport/stop');` |


To play only a certain time interval, e.g., from second 5 to 10, type:

| terminal                                  | GNU/Octave or Matlab                                            |
|-------------------------------------------|-----------------------------------------------------------------|
| `send_osc 9877 /transport/playrange 5 10` | `send_osc( 'localhost', 9877, '/transport/playrange', 5, 10);` |


Some OSC librararies, including the one used by TASCAR, can use "globbing" in the path string, i.e., by sending to `'/scene/water/*/gain'`, in this case to control two OSC variables:
```
/scene/water/0/gain
/scene/water/1/gain
```
To set the gain to -10 dB, type:

| terminal                                | GNU/Octave or Matlab                                        |
|-----------------------------------------|-------------------------------------------------------------|
| `send_osc 9877 /scene/water/*/gain -10` | `send_osc( 'localhost', 9877, '/scene/water/*/gain', -10);` |


**Important Warning:** TASCAR is not checking for excessive gains. Be sure not to enter a huge number, e.g., never use `send_osc 9877 /scene/water/*/gain 100` or so. This would extremely loud and distored sounds. Especially with headphones or with hardware which can reproduce high sound pressure levels, you may damage your hearing. It is recommended to always take of the headphones before changing the gain ot playback state.



## Step 2: Changing position and orientation of objects

Any object in a TASCAR scene will have three variables linked to the position and orientation:

```
/scene/backwall/pos  (fff)  XYZ Translation in m
/scene/backwall/pos  (ffffff)  XYZ Translation in m and ZYX Euler angles in degree
/scene/backwall/zyxeuler  (fff)  ZYX Euler angles in degree
```

`pos` with three parameters controls the translation in Cartesian coordinates. Please note the right-hand orientation of the coordinate system in TASCAR - x is to the front, y to the left, and z to the top.

`pos` with six parameters controls the translation and the ZYX Euler angles in a single step. Z-rotation is the rotation around the Z axis, with positive angles to the left.

Similarly, `zyxeuler` are the Euler angles without translating an object.

To shift the "backwall" object by 30 cm to the left and 1 m to the front relative to the position defined in the XML file, one can call this command in GNU/Octave or Matlab:
```
send_osc('localhost', 9877, '/scene/backwall/pos', 1, 0.3, 0 );
```

To tilt it by 10 degrees, write:
```
send_osc('localhost', 9877, '/scene/backwall/zyxeuler', 0, 10, 0 );
```

To verify your changes, please check the different view settings (top view, side view, 3D view) in the map window of TASCAR.

## Step 3: Scripting TASCAR with OSC messages

TASCAR can read OSC variables also from text files. The format of the files is straight forward: each line contains a variable, starting with the path, followed by an arbitrary number of parameters. Some (non-OSC) special definitions can be used: a hash tag to write comments, a line starting with a comma followed by a number to wait for the given amount of time, and an "@" followed by a number to execute the given line at a certain session time:
```
# when reaching second 7 then stop:
@7 /transport/stop
# rewind:
/transport/locate 0
# wait for one second:
,1
# start playback
/transport/start
# wait 2 seconds:
,2
# set position of backwall:
/scene/backwall/pos -1 0 0
```
The file extension used for such files is typically `.tosc` (for TASCAR OSC file). Save this to the file "script.tosc" in the same folder as the session file. Reading such files is triggered using an OSC command:
```
send_osc('localhost',9877,'/runscript','script.tosc')
```
Please note that messages starting with "@" (timed messages) will be kept in memory until they are cleared with
```
send_osc('localhost',9877,'/timedmessages/clear');
```

## Step 4: Reading internal states and values

Some of the variables which can be set via OSC can also be read out via OSC. In the "OSC variables" tab these variables are indicated with the letter "r" after the format string. To read the current value, you need to create an OSC server to which the values will be sent. On the command line, this can be done with the command:
```bash
dump_osc 9000
```
This will create a UDB server listening on port 9000. Creating a server in Matlab is more difficult, see the script [example_receive_osc.m](https://github.com/gisogrimm/tascar/blob/master/scripts/example_receive_osc.m) for an example.

To receive the current value of a variable, you can send an OSC message to the variable path, appended by "/get", with two special parameters: the first is a valid OSC target address, e.g., 'osc.udp://localhost:9000/', and the second is a target path. For example, to read the value of '`/scene/backwall/scattering`', type in the terminal:
```bash
send_osc 9877 /scene/backwall/scattering/get osc.udp://localhost:9000/ /var
```
Or alternatively in GNU/Octave or Matlab:
```matlab
send_osc( 'localhost', 9877 '/scene/backwall/scattering/get', 'osc.udp://localhost:9000/', '/var');
```

The response will be something like this (in this example using `dump_osc`):
```
/var ,sf /scene/backwall/scattering 0.0
```
Here, the path is the same path provided in the `/get` message. The next is the format string, followed by the variable path and its current value.
