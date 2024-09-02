clear all
close all

% render FOA impulse response:
system('LD_LIBRARY_PATH='''' tascar_renderir scattering.tsc -f 48000 -o ir.wav');

% load IR:
[ir,fs] = audioread('ir.wav');

% create SDM array:
p = createSDMStruct('DefaultArray','Bformat','fs',fs,'winLen',15);

% decompose IR:
DOA{1} = SDMbf(ir, p);

% visualize IR histogram:
P{1} = ir(:,1);
set(0,'DefaultTextInterpreter','latex')
v = createVisualizationStruct('DefaultRoom','SmallRoom',...
                              'fs',fs,'t',[ 2 5 10 20 50 100 200 1000]);
% remove saturation of lines and make thicker:
v.colors = 0.1+0.7*v.colors;
v.linewidth = v.linewidth*1.2;
v.plane = 'lateral';
spatioTemporalVisualization(P, DOA, v);
%v.plane = 'transverse';
%spatioTemporalVisualization(P, DOA, v)
%v.plane = 'median';
%spatioTemporalVisualization(P, DOA, v)
