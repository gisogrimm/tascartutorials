# Real-time interaction, data logging, and integration of sensors

In this tutorial you will learn how to collect and process data from external sensors in real time using TASCAR, Open Sound Control (OSC) and the Lab Streaming Layer (LSL). Explore interactive virtual acoustic environments by creating your own gesture interface, tracking head and object movements or gaze directions via EOG or optical tracking to control components of the scene.

In the end, you will be able to access and manipulate sensor data in TASCAR and GNU Octave/Matlab, as well as use TASCAR's data logging capabilities to record sensor data time-synchronised with your virtual environment.

This tutorial assumes you have at least one sensor available which is sending OSC messages or LSL streams. We use a [self-made head tracker](https://github.com/gisogrimm/headtracker) in our lab.


## Prerequisites

Open a terminal and navigate to the `tascartutorials/sensors` directory:
```bash
cd tascartutorials/sensors
```
Ensure that JACK server is running (e.g., start it with `qjackctl &`).

Further information on controlling TASCAR via the OSC protocol can be found in Section 2.2 "Network remote control via OSC" of the [TASCAR manual](https://www.tascar.org/manual.pdf) and in the tutorial "[Interfacing TASCAR with OSC](../oscif/README.md)".


## Step 1: Connect sensors

### Headtracker
Look at file `sensorinterface.tsc`. Our aim is to control an object in a TASCAR scene using a headtracker. Start TASCAR using `tascar&` and load the scene `sensorinterface.tsc` into TASCAR. There are different sensors you can use:

#### i. self made sensor with an IMU using USB 
You will be using a self-made sensor consisting of an Inertial Measurement Unit (IMU) to capture head movement. The sensor is connected to the computer using USB. 

If you are using the USB serial port sensor on Linux, you need to make sure that the current user is part of the `dialout` group. To check, type `id` in a terminal, and see if the group `dialout` is listed. If not, you need to perform this line, and then log out and log in again (in some cases, a restart of the computer is required):
```bash
sudo usermod -a -G dialout ${USER}
```

#### ii. self made sensor with an IMU using OSC
You will be using a self-made sensor consisting of an Inertial Measurement Unit (IMU) to capture head movement. The recorded data will be send to tascar via OSC. To use this sensor you need a wifi enabled computer. 

Use `dump_osc 9877` in a terminal to see which OSC messages are arriving. You can stop the process with `Ctrl-C` (or `Strg-C` on a German keyboard).

#### iii. Optical tracking
If you are currently in the Gesture Lab you can use a Qualisys motion capture system, which uses multiple cameras to track the movement of reflective markers attached to a head-mounted crown.

Use command line tool `tascar_lslsl` to check which LSL streams are available in the lab.



In addition you can use an Electrooculogram (EOG) to measure eye orientation.




## Step 2: Logging of sensor data

Look at file `datalogging.tsc`. It contains entries for EOG and optical tracking. Add Euler angles to the datalogging. First identify the path and size of samples by looking at the output of `dump_osc`. The correct entry should look like:

```
<osc path="/imu/xyzeuler" size="3"/>
```

## Step 3: Real time interaction

You will need all loudspeakers in the lab. To switch them on, open a terminal and type:
```
speakerctl all on
```
If you are not in the Gesture Lab, then please adapt the speaker layout file to your own layout, or use the headphone receiver type (`<receiver type="hrtf">`).

Look at file `interaction.tsc`. Try and understand the effect of the lslactor module. Add control of the position of the receiver, by adding a second `lslactor` element. You may use the crown to control the position.

---

### Protocols

- OSC
- LSL
- jack synchronization
- LTC (for video sync)
- MIDI (user input)

### Sensors

- optical headtracker
- headtracker IMU
- EOG
- video recording (not today)
- EEG (not today, too complex)


### TASCAR modules

- oscheadtracker
- oscrelay
- datalogging
- lslactor
- ltcgen
