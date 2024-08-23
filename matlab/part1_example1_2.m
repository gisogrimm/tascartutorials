% -------------------------TASCAR TUTORIAL-------------------------- 
% Interfacing from MATLAB/GNU Octave for adaptive measurements
% ------------------------------------------------------------------

%% initialization, setup paths

clc
clear
close all

% TASCAR-related MATLAB scripts are stored:
addpath /usr/share/tascar/matlab/


%% Part 1.3: Generate and load a scene

% There is a possibility to generate a simple TASCAR scene from matlab. 
% This simple scene contains one speaker based receiver, and sources and 
% virtual loudspeakers equally distributed on a circle around the receiver. 

% choose parameters
NrSources=4;
NrSpeakers=16;
ReceiverType='hoa2d';
test_filename='my_new_generated';

%generate a scene 
tascar_ctl('createscene',...
    'filename', [test_filename, '.tsc'] , ...
    'nrsources',NrSources, 'nrspeakers', NrSpeakers, ...
    'rec_type',ReceiverType);

%load the generated scene in tascar & wait for a while
h_temp=tascar_ctl('load',[test_filename,'.tsc']);
pause(5);

% connect ports:
for k=1:16
  tscport = sprintf('render.%s:out.%d',test_filename,k-1);
  hwport = sprintf('system:playback_%d',k);
  system(['LD_LIBRARY_PATH='''' jack_connect ',tscport,' ',hwport]);
end


%% ---------  2. Modify parameters of the opened scene ---------------



% Do it yourself if you want :-) 



%% -----------------  3. Play & record  -----------------

%% --------------  3.1. Specify jack ports  -----------------

% make a cell with writeble clients names (see QjackCtl  or type 'jack_lsp -p' in terminal):
c_ReadPorts=cell(NrSpeakers,1);
for kk=1:NrSpeakers
    c_ReadPorts{kk}=['render.my_new_generated:','out.',num2str(kk-1)];
end
% make a cell with readable clients names (see QjackCtl  or type 'jack_lsp -p' in terminal):
c_WritePorts=cell(NrSources,1);
for nn=1:NrSources
    c_WritePorts{nn}=['render.my_new_generated:','src_',num2str(nn),'.0'];
end

%% --------------  3.2. Use function tascar_jackio  -----------------

%create a test signal whose size fits the number of sources in the scene

% WARNING: maximal fullscale values refer to approximately 120 dB spl! 

test_sig = (rand(44100*5,4)-0.5)*0.001;

%play back the test signal in the scene & record the receiver output
y=tascar_jackio ...?

%% --------------  4. Close a TASCAR scene  -----------------
tascar_ctl('kill',h_temp);
