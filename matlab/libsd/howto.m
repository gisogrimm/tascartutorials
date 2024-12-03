%% Frequently Asked Questions

%----------------------------------------------------------------------
% Where can I find the source?

% install TASCAR or download it from
% https://github.com/gisogrimm/tascar/blob/master/scripts/libsd.m

%----------------------------------------------------------------------
% How does it work in general?

addpath('/usr/share/tascar/matlab');
lsd = libsd();

lsd

%----------------------------------------------------------------------
% What is it good for?

% Maybe nothing. Here an example to measure CPU temperature as a
% function of load:
sData = struct;
sData.fields = {'niter','fun','temp','logduration'};
sData.values = {[1e0,1e4,1e7],{'sin','log'}};
sData = lsd.eval( sData, @get_cpu_temp_after_load, ...
                  'brand', true, 'display', true, 'nrep', 8 );
lsd.plotwizzard(sData); % (sorry for the typo, will change in the future)



%----------------------------------------------------------------------
% how can I get help for a specific function?

lsd.help.plot()


%----------------------------------------------------------------------
% How can the data sets from different subjects be merged and plotted?
% Wie können die Datensätze von verschiedenen Probanden zusammengeführt und geplottet werden?

s1 = load('Pilotmessung2_Giso_01.11.2024_16-10.mat');
s2 = load('Pilotmessung2_Lukas_01.11.2024_15-53.mat');
sData = lsd.merge_addpar(s1.sData, s2.sData);
sData.fields
sData.fields{1} = 'subject';
sData.values{1} = {'Giso','Lukas'};
lsd.plotwizzard(sData); % (sorry for the typo, will change in the future)

% alternative way:
sDir = dir('Pilot*.mat');
cData = {};
cLabels = {};
for k=1:numel(sDir)
    s = load(sDir(k).name);
    cData{k} = s.sData;
    cLabels{k} = sDir(k).name(15:end);
end
%cData = { s1.sData, s2.sData }; % append more data sets if needed
%cData{end+1} = load()
sData = lsd.merge_addpar( cData{:} );
sData.fields{1} = 'subject';
sData.values{1} = cLabels;

%----------------------------------------------------------------------
% How can I save plots?
% Wie kann ich Plots speichern?

sPlotPar = struct();
sPlotPar.fontsize = 10;
% with smaller font size:
lsd.plot(sData, 4, 5, sPlotPar, 'average','median', 'parameter',2, 'restrictions',{{3,3}});
% with default values:
fh = lsd.plot(sData, 4, 5, struct(), 'average','median', 'parameter',2, 'restrictions',{{3,3}});
hold('on');
plot(1:numel(sData.values{4}),sData.values{4},'k-');
saveas(fh, [get(fh,'Name'),'.eps'], 'epsc' );
saveas(fh, [get(fh,'Name'),'.svg'], 'svg' );

%----------------------------------------------------------------------
% Is it possible to perform a linear fit or a fit with another
% function for the merged data sets and to determine the error square?
%
% Ist es möglich für die zusammengeführten Datensätze einen linearen
% Fit oder einen Fit mit einer anderen Funktion durchzuführen und das
% Fehlerquadrat zu ermitteln?

sDataWideband = lsd.restrict( sData, 'freqrange','wideband' );
sDataWideband0 = lsd.restrict( sDataWideband, 'prewarmode','prewarmode0' );
sDataWideband0 = lsd.squeeze( sDataWideband0 )
sDataWideband1 = lsd.restrict( sDataWideband, 'prewarmode','prewarmode1' );
sDataWideband1 = lsd.squeeze( sDataWideband1 )

v_angles = sDataWideband0.values{2}( sDataWideband0.data(:,2) )';
v_est_angles = sDataWideband0.data(:,3);

[P,S] = polyfit( v_angles, v_est_angles, 1 );

rms_error_deg = sqrt(mean( (v_angles - v_est_angles).^2 ))

%----------------------------------------------------------------------
% Is it possible to automatically output the standard deviations and
% mean values for a data set in which a condition was measured
% multiple times or for several merged data sets with the plot as a
% matrix?
%
% Kann ich mir die Standardabweichungen und Mittelwerte für einen
% Datensatz bei dem eine Kondition mehrfach gemessen wurde oder für
% mehrere zusammengeführte Datensätze automatisch mit dem Plot als
% Matrix ausgeben lassen?

sMean = lsd.average( sData, 'subject', {@mean, @std} )
sMeanRep = lsd.average( sData, [], {@mean, @std} )

v_angles = sData.values{4}( sData.data(:,4) )';
v_est_angles = sData.data(:,5);
sDataErr = sData;
sDataErr.data(:,end+1) = (v_angles - v_est_angles).^2;
sDataErr.fields{end+1} = 'sqrdiff';

%----------------------------------------------------------------------
% Are there other tools for statistical analysis?
% Gibt es weitere Tools für die statistische Auswertung?

lsd.csv( sData, 'export.csv' ); % export, then use external tools like R or SPSS

p = lsd.anovan(sDataErr, 8, 2:3 )
lsd.posthoc(sDataErr, 8, 2:3)


% helper function for example experiment. Get temperature of CPU after
% creating some CPU load:
function [temp,duration] = get_cpu_temp_after_load( niter, fun )
    fun_ = @sin;
    switch fun
      case 'sin'
        fun_ = @sin;
      case 'log'
        fun_ = @log;
    end
    pause(2);
    res = 0;
    h_time = tic();
    for k=1:niter
        res = fun_(res*rand(1,1));
    end
    duration = log10(toc(h_time));
    [err,temp] = system('cat /sys/class/thermal/thermal_zone*/temp');
    temp = 0.001*max(str2num(temp));
end
