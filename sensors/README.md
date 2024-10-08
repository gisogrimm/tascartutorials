# Sensors, real-time interaction and data logging

## Prerequisites

* Open a terminal and navigate to the `tascartutorials/sensors` directory:
```bash
cd tascartutorials/sensors
```
* Ensure that JACK server is running (e.g., start it with `qjackctl &`).

## Step 1: Connect sensors

You will be using a Qualisys motion capture system and a self-made IMU/EOG sensor. Look at file `sensorinterface.tsc`. Start TASCAR. Load it into TASCAR and use `dump_osc 9877` in a terminal to see which OSC messages are arriving. You can stop the process with `Ctrl-C` (or `Strg-C` on a German keyboard).

Use command line tool `tascar_lslsl` to check which LSL streams are available in the lab.

## Step 2: Logging of sensor data

Look at file `datalogging.tsc`. It contains entries for EOG and optical tracking. Add Euler angles to the datalogging. First identify the path and size of samples by looking at the output of `dump_osc`. The correct entry should look like:

```
<osc path="/imu/xyzeuler" size="3"/>
```

## Step 3: Time code generation for video recordings

All our cameras were stolen, therefore we cannot demonstrate this today.

## Step 4: Real time interaction

You will need all loudspeakers in the lab. To switch them on, open a terminal and type:
```
speakerctl all on
```
If you are not in the Gesture Lab, then please adapt the speaker layout file to your own layout.

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
- video recording (not today, camerase stolen)
- EEG (not today, too complex)


### TASCAR modules

- oscheadtracker
- oscrelay
- datalogging
- lslactor
- ltcgen
