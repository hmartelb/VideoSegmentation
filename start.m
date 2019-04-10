%%
% shot detection measures
%%

videoNames = ['cuentaatras.avi','bigbang.avi','timelapse.avi','vipscenevideoclip.avi']

disp('Shot detection test')

for i=1:length(videoNames)
    close all
    clear all
    clc
    shotDetectionMain(videoNames[i], true);
    disp('Press enter to continue to the next video.')
    pause
end