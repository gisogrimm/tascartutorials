% -------------------------TASCAR WORKSHOP-------------------------- 
% -----------Taskgorup 2: Interfacing TASCAR from MATLAB------------
% -------------------------- EXAMPLE 2 -----------------------------

% In this example we want to show you how to modify the xml file from MATLAB
% and how to do the offline rendering. 


clc
clear
close all

addpath /usr/share/tascar/matlab/
javaaddpath ../netutil-1.0.0.jar

%% --- Choose a TASCAR scene you would like to edit: ---
doc = tascar_xml_open('/home/medi/Projects/tascarworkshop/matlab/task2_basic2.tsc');

%%  Change attributes of elements 
r_walls=0.8;
d_walls=0.2;
ismorder = 2;

%Change mirror order of scene:
doc = tascar_xml_edit_elements( doc, 'scene', 'mirrororder', ismorder);

%Change r&d filter coefficients of the walls
doc = tascar_xml_edit_elements( doc, 'facegroup', 'reflectivity', r_walls,'name','magicchamber');
doc = tascar_xml_edit_elements( doc, 'facegroup', 'damping', d_walls,'name','magicchamber');

%Change size of the shoebox room 
shoebox_size='3 5 3';
doc = tascar_xml_edit_elements( doc, 'facegroup', 'shoebox', shoebox_size ,'name','walls');

%% --- Add new elements to  xml file --- 

%Add a new source with a certain position and spherical interpolation
sceneNode = tascar_xml_get_element( doc,'scene') ;
srcNode = tascar_xml_add_element( doc, sceneNode{1}, 'source', [], 'name','new_source'); 
posNode = tascar_xml_add_element( doc, srcNode, 'position','0 2 0 1 4 5 2 2','interpolation','spherical'); 
soundNode = tascar_xml_add_element( doc, srcNode, 'sound', [], 'name','0');
pluginsNode = tascar_xml_add_element( doc, soundNode, 'plugins', []);
sndfileNode = tascar_xml_add_element( doc, pluginsNode,'sndfile',[],'name','${HOME}/tascar_scenes/sounds/daps/m4_script4_clean.wav','loop','0','level','60');

%% --- Removing elements from xml file ---
sceneNode = tascar_xml_get_element( doc,'scene') ;
positionnNode = tascar_xml_rm_element( doc, sceneNode{1}, 'obstacle', 'name','thewall'); 

%% --- Save the edited scene definition file ---
tascar_xml_save( doc, 'task2_basic2_modified.tsc' ) 



%% --- OFFLINE RENDERING ---

%% Impulse response rendering (does not require input signal, static) 

% open the unmodified scene in Tascar
[rendered_IR1,fs1] = tascar_ir_measure('input','render.scene:out_omni','output','render.scene:src.0');

% open the modified scene in Tascar
[rendered_IR2,fs2] = tascar_ir_measure('input','render.scene:out_omni','output','render.scene:src.0');


