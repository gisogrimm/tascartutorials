# Interfacing TASCAR with OSC

The majority of TASCAR options can be controlled remotely via the Open Sound Control (OSC)
(OSC) protocol. For complete OSC specifications, visit [OpenSoundControl.org](https://opensoundcontrol.stanford.edu/). An OSC message consists of an address path string and a format string, which specifies the type of data that follows. OSC messages can be sent over a network using either the [User Datagram Protocol (UDP)](https://en.wikipedia.org/wiki/User_Datagram_Protocol) or the [Transmission Control Protocol (TCP)](https://en.wikipedia.org/wiki/Transmission_Control_Protocol). With UDP, the transmission state is not checked, meaning that messages may be lost during transmission. TCP can guarantee correct transmission (or report an error), but this comes at the cost of longer and less predictable transmission times.

A huge list of tools to send OSC messages exist. For the command line, we typically use `send_osc` from the `pyliblo-utils` debian package. For GNU/Octave and Matlab, a java-based tool, also called `send_osc` (or `send_osc_tcp` for TCP) is part of the TASCAR installation. On Linux, type 
```
addpath /usr/share/tascar/matlab/
```
to add the TASCAR tools for GNU/Octave and Matlab.


There is a huge list of tools for sending OSC messages. For the command line, we typically use the `send_osc` tool from the `pyliblo-utils` Debian package. For GNU/Octave and Matlab, the TASCAR installation includes a Java-based tool with the same name (or `send_osc_tcp` for TCP). To add the TASCAR tools for GNU/Octave and Matlab on Linux, type:
```
addpath /usr/share/tascar/matlab/
```

## Step 1: Control playback of a session, and gains of sounds

For this tutorial you can use the session file from the "first steps" tutorial, `firststeps/firststeps.tsc`. Open this session file with TASCAR:
```bash
tascar ../firststeps/firststeps.tsc &
```
On the left side of the main window, you can see the tabs '`1 Map`', '`2 Mixer`', '`3 XML source`', '`4 OSC variables`' and so on. Go to tab '`4 OSC variables`'. Each line in this view represents one internal variable or state control, which can be accessed with OSC. The first entry in each row is the address string, followed by the format string (in brackets). Other optional elements are "r", to indicate that the variable is readable (see below), a suggested value range, the unit string, and a brief documentation. To start the playback of this session, you may type in the command line window:
```bash
send_osc 9877 /transport/start
```
Similarly, to stop the session, type:
```bash
send_osc 9877 /transport/stop
```
To play only a certain time interval, e.g., from second 5 to 10, type:
```bash
send_osc 9877 /transport/playrange 5 10
```

Some OSC librararies, including the one used by TASCAR, can use "globbing" in the path string, i.e., by sending to `'/scene/water/*/gain'`, in this case to control two OSC variables:
```
/scene/water/0/gain
/scene/water/1/gain
```
To set the gain to -10 dB, type:
```bash
send_osc 9877 /scene/water/*/gain -10
```
**Important Warning:** TASCAR is not checking for excessive gains. Be sure not to enter a huge number, e.g., never use `send_osc 9877 /scene/water/*/gain 100` or so. This would extremely loud and distored sounds. Especially with headphones or with hardware which can reproduce high sound pressure levels, you may damage your hearing. It is recommended to always take of the headphones before changing the gain ot playback state.

## Step 2: Changing position and orientation of objects

## Step 3: Scripting TASCAR with OSC messages

## Step 4: Reading internal states and values

