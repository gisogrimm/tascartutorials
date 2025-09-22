# Sensors, real-time interaction and data logging

In this tutorial you will learn how to collect and process data from external sensors in real time using TASCAR and Open Sound Control (OSC). Explore interactive virtual acoustic environments by creating your own gesture interface, tracking head and object movements or using optical tracking to control components of the scene.

In the end, you will be able to access and manipulate sensor data in TASCAR.

This tutorial assumes you have at least one sensor available which is sending OSC messages or is connected to your computer via USB. We use a [self-made head tracker](https://github.com/gisogrimm/headtracker) and an optical tracking system in our lab.

---

## Prerequisites

Open a terminal and navigate to the `tascartutorials/sensors` directory:
```bash
cd tascartutorials/sensors
```
Ensure that JACK server is running (e.g., start it with `qjackctl &`).

Further information on controlling TASCAR via the OSC protocol can be found in Section 2.2 "Network remote control via OSC" of the [TASCAR manual](https://www.tascar.org/manual.pdf) and in the tutorial "[Interfacing TASCAR with OSC](../oscif/README.md)".

---

## Step 1: Connect sensors

Look at file `sensorinterface.tsc`. Our aim is to control an object in a TASCAR scene using a headtracker. There are different sensors you can use. Select a sensor which is available to you from the sensors listed below. Have a look at the modules in your TASCAR scene. Comment out all sensors you are not using. Connect the sensor to your computer or a power supply if necessary. Start TASCAR using `tascar&` and open the scene `sensorinterface.tsc`.

### i. self made IMU sensor (using USB) 
You will be using a self-made sensor consisting of an Inertial Measurement Unit (IMU) to capture head movements. The sensor is connected to the computer using USB. 

If you are using the USB serial port sensor on Linux, you need to make sure that the current user is part of the `dialout` group. To check, type `id` in a terminal, and see if the group `dialout` is listed. If not, you need to perform this line, and then log out and log in again (in some cases, a restart of the computer is required):
```bash
sudo usermod -a -G dialout ${USER}
```

### ii. self made IMU sensor (using OSC)
You will be using a self-made sensor consisting of an Inertial Measurement Unit (IMU) to capture head movements. The recorded data will be send to tascar via OSC. To use this sensor you need a wifi enabled computer. The sensor needs to be connected to a power supply.

### iii. Optical tracking
If you are currently in the Gesture Lab you can use a Qualisys motion capture system, which uses multiple cameras to track the movement of reflective markers.

---

## Step 2: Real time interaction

Please adapt the speaker layout file to your current layout. In the lab use a 3-D vbap receiver to utilize all 45 loudspeakers (`<receiver type="vbap3d">`) and for headphones use a hrtf receiver (`<receiver type="hrtf">`).

### i. In the lab
Comment out `<sound x="1">` in order to place the object you want to control in the coordinate origin.

You are not using headphones, therefore comment out `<connect src="render.scene:out_[lr]" dest="system:playback_[12]"/>` in your tascar scene.

Use the soundtype cardioid.

### ii. In the office
Connect headphones to a soundcard and the soundcard to your computer and use `<connect src="render.scene:out_[lr]" dest="system:playback_[12]"/>` in your TASCAR scene.

This sensor is mounted to headphones. Move the object you want to control with your sensor using `<sound x="1">`. It has now a different position than your receiver.

Comment out ` <sound type="cardioidmod">`.

---

## Step 3: Logging of sensor data

Look at the module `pos2osc` in `sensorinterface.tsc`. It sends the data of your sensor to the datalogging using OSC messages. Use the module `datalogging` to save the data.

We use a temperature sensor which sends the data to the port 9800 every 30 seconds and can be accessed with all lab/office computers. First identify the path and size of samples by looking at the output of `dump_osc 9800`. Use the module `oscserver` to add a second port to tascar. Add another osc path to your datalogging to record temperature and humidity.
 
---

### Protocols

- OSC
- jack synchronization
- LSL
- LTC (for video sync)
- MIDI (user input) 

### Sensors

- optical headtracker
- headtracker IMU
- EOG (not today)
- video recording (not today)
- EEG (not today)


### TASCAR modules

- oscheadtracker
- serialheadtracker
- glabsensors
- oscactor
- pos2osc
- datalogging
- oscserver

