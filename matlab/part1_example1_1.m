% -------------------------TASCAR TUTORIAL-------------------------- 
% Interfacing from MATLAB/GNU Octave for adaptive measurements
% ------------------------------------------------------------------

%% initialization, setup paths

clc
clear
close all

% TASCAR-related MATLAB scripts are stored:
addpath /usr/share/tascar/matlab/


%% Part 1.1: Load an existing scene

% load the scene in tascar:
h_temp=tascar_ctl('load', 'part1_basic1.tsc');
pause(3);

%% Part 1.2: Modify parameters of the opened scene

% Here is how to modify the TASCAR scene from MATLAB.  The scene
% parameters can be modified from MATLAB using the 'send_osc.m'
% function. You can set a breakpoint after the line where the scene is
% loaded, and when the script stops at the breakpoint, go to VIEW->OSC
% Variables in the TASCAR window - you will see a list of parameters
% that can be changed.  You can experiment by setting breakpoints
% after each use of 'send_osc' and each time see what has changed in
% the scene or what action has been taken.

%% Change the position and orientation of the object:
pos_x = 1;
pos_y = 2;
pos_z = 1;
euler_x = 10;
euler_y = 30;
euler_z = 0;
send_osc(h_temp,'/scene/src/pos' ,pos_x, pos_y, pos_z, euler_z, euler_y,euler_x)

%% start playing back the scene:
send_osc(h_temp, '/transport/start')

%% Change the gain of an object:
G=10;
send_osc(h_temp,'/scene/src/0/gain' ,G)

%% stop playing back the scene:
send_osc(h_temp,'/transport/stop')

%% Change the position on the time line:
time_point = 0.7;
send_osc(h_temp,'/transport/locate',time_point);

%% Part 1.3: Play & record

% The following shows how to play and record TASCAR scene content
% using the `tascar_jackio' tool.  It is necessary to specify the jack
% audio ports corresponding to the sources and receivers. You can
% again set a breakpoint after the line where the scene is loaded and
% when the script stops at the breakpoint, go to the QjackCtl, click
% the 'Connect' button and look at the jack port types and their
% names.  You can also type 'jack_lsp -p' in the terminal to see the
% list of available jack ports.

% Specify jack ports:

% create a cell string array with the names of writable clients (e.g. loudspeakers):
c_Write={'render.scene:src.0.0'};
% create a cell string array with the names of readable clients (e.g. microphones): 
c_Read={'render.scene:outomni.0'};

% set stimulus duration:
duration = 3;

% Use function tascar_jackio:

% For help type in the command window:
% tascar_jackio help 
% help tascar_jackio

% get the sample rate and buffer settings of your audio system:
[tmp,fs,bufsize] = tascar_jackio(0);

% To play back and record the scene with only its original content
% (from the scene definition file), the test signal must only contain
% zeros:

% Create a test signal, with a column for each entry in the variable c_Write:
test_sig = zeros(round(duration*fs),1);

transportStart = 5; 
[rec_signal_orig,fs,bufsize,load,xruns,sCfg] = tascar_jackio(test_sig, ...
    'output' ,c_Write , 'input',  c_Read, 'starttime', transportStart);
figure
plot(rec_signal_orig);

% To play a sound created in Matlab and record it in the scene, the
% stimulus can be created as a column vector, with one column per
% entry in the variable c_Write.

% create a Gaussian noise test signal:
test_sig = 0.03*randn(round(duration*fs),1);

transportStart=5; 
[rec_signal_withnoise,fs,bufsize,load,xruns,sCfg]=tascar_jackio(test_sig, ...
    'output' ,c_Write , 'input',  c_Read, 'starttime', transportStart);
hold on
plot(rec_signal_withnoise)

% reverse order of plots to make the softer one visible:
h = get(gca,'Children');
set(gca,'Children',h(end:-1:1));

%% Part 1.4: Close a TASCAR scene:

tascar_ctl('kill',h_temp);
