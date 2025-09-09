![validate](https://github.com/gisogrimm/tascartutorials/actions/workflows/validate.yml/badge.svg)


# TASCAR tutorials

This repository contains a series of TASCAR tutorials. TASCAR is a toolbox for low-delay and interactive acoustic scene creation and rendering [<a href="#ref1">1</a>]. For more information, please visit the [TASCAR official website](https://tascar.org/).


These tutorials form the basis of our annual TASCAR workshop. The files are constantly being improved. If you have any suggestions, please submit a pull request.

You can download the tutorial files and all the necessary sound files [from github](https://github.com/gisogrimm/tascartutorials/archive/refs/heads/main.zip). All session files were tested with TASCAR version 0.234.4.

While some of these tutorials require equipment specific to our laboratory, most can be followed on any PC running Linux, Mac OS or Windows. TASCAR and the Jack Audio Connection Kit (JACK) must be installed for all tutorials, as well as an audio interface with either a loudspeaker system or headphones connected to it. To interactively render your own voice, you will also need a microphone or headset.

The *user manual* can be found [on github](https://github.com/gisogrimm/tascar/wiki/master/manual.pdf), or if you installed TASCAR with your packet manager also [locally](file:///usr/share/doc/tascar/manual.pdf). You can use the manual as a valuable reference for all the workshop tutorials.


## List of topics:

- [First steps in TASCAR](firststeps/README.md)<br/>
  This is where to start if you have never created a TASCAR session file before. It explains how to create the first dynamic scene in TASCAR.

- [Image source model, diffuse sound fields and reverberation](roomacoustics/README.md)<br/>
  This tutorial demonstrates the room acoustic modelling features of TASCAR and provides a low-delay interactive rendering of a room.

- [Sensors, real-time interaction and data logging](sensors/README.md)<br/>
  This tutorial explains how to connect a Qualisys motion capture system and an open-hardware IMU/EOG sensor to control orientation and position of objects in TASCAR, and to record the movement data in the datalogging system.

- [Interfacing from MATLAB/GNU Octave for adaptive measurements](matlab/README.md)<br/>
  Use OSC to exchange data with, and control the state of TASCAR from within MATLAB or GNU Octave.

- [Interactive Binaural Synthesis, Head Tracking, and openMHA](binaural/README.md)<br/>
  This tutorial explains how to render binaural signals and how to use a head tracker to achieve dynamic binaural rendering. It also demonstrates how to combine the output with the [hearing aid software, openMHA](https://www.openmha.org/).

- [Interactive communication and data transmission via the internet](ovbox/README.md)<br/>
  The OVBOX, a network communication tool built upon TASCAR, enables the transmission of low-delay audio and behavioural data.

- [Programming TASCAR: Develop your own plugins](dev/README.md)<br/>
  If you require additional features for your project, you can extend TASCAR to meet your needs using the development interfaces.



The files are made available under a [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) licence.


## References:

[<a name="ref1">1</a>] Grimm, G., Luberadzka, J. & Hohmann, V. (2019). A toolbox for rendering virtual acoustic environments in the context of audiology. Acta Acustica United with Acustica, 105(3), 566–578. https://doi.org/10.3813/AAA.919337
