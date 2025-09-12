# Interactive communication and data transmission via the internet

The [OVBOX system](https://ovbox.de) was originally developed during the pandemic for streaming rhythmic music online. Its key features are low-latency transmission and audio spatialisation. It consists of an internal system for exchanging and distributing UDP messages and a TASCAR audio processing subset.

For this tutorial, we will assume that you have an OVBOX based on a Raspberry Pi and a desktop client (we will provide these during the TASCAR workshop). Basic knowledge of TASCAR and network communication is required.

## Step 1: low-delay acoustic communication with the OVBOX

Connect the Raspberry Pi-based OVBOX as described on the [wiki pages](https://github.com/gisogrimm/ovbox/wiki). Use either headphones and a microphone, or a headset. Connect a sound card and a headset (or headphones and a microphone) to the computer running the desktop client.

Now log onto the [configuration server](https://login.ovbox.de) of the OVBOX system. When using the components from our lab, then we will provide the login credentials. If you put both devices into the same session ("room" on the configuration server), you should be able to hear each other as well as your own voice.

Hints: At your sound card, disable "direct monitor", and enable the phantom power supply (48V) for your microphone. To decrease the volume of your own monitor signal, change the configuration of your device in the web interface, and decrease the "self monitor gain", e.g., by 3 dB.

## Step 2: Using a head tracker for dynamic binaural rendering and remote source movement

## Step 3: Recording of audio signals

## Step 4: Recording of speech levels and head movement