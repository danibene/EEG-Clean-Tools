%%
p = fileparts(pwd);
addpath(genpath(p));
%% simulate signal
duration = 120;
srate = 200;

nSamples = round(duration * srate);
period = 1 / srate;
seconds = (1:nSamples).*period;

dataIn = randn(1,nSamples);
%% format input
EEG.data = dataIn;
EEG.srate = srate;
detrendType = 'linear';
% detrendType = 'high pass';
% doesn't work
% Unrecognized function or variable 'pop_eegfiltnew'.
% 
% Error in removeTrend (line 66)
%         pop_eegfiltnew(EEG1, detrendOut.detrendCutoff, []);
% 
% Error in testRemoveTrend (line 24)
% [EEG, detrendOut] = removeTrend(EEG, detrendIn);
 
detrendCutoff = 1;

detrendIn = struct('detrendChannels', 1, 'detrendType', detrendType, ...
                    'detrendCutoff', detrendCutoff, 'detrendStepSize', 0.02, ...
                    'detrendCommand', []);
%%
[EEG, detrendOut] = removeTrend(EEG, detrendIn);
dataOut = EEG.data;
%%
figure
tfestimate(dataIn,dataOut,window,[],[],srate)
xlim([0.25,1.25])
ylim([-15,0])
title("Linear detrending; detrendCutoff = 1")
%%
figure
[b,a] = butter(5,detrendCutoff/(srate/2),'high');
dataOut = filter(b,a,dataIn);
tfestimate(dataIn,dataOut,window,[],[],srate);
xlim([0.25,1.25])
ylim([-15,0])
title("High pass butterworth filter; cutoff = 1 Hz")

%%
figure
freqz(b,a,[],srate)
title("High pass butterworth filter; cutoff = 1 Hz")



