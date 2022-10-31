%%
% p = fileparts(pwd);
% addpath(genpath(p));
%% simulate signal
duration = 120;
frequency = [0.2, 0.4, 0.8, 1.6, 3.2];
amplitude = [1, 2, 3, 2, 1];
srate = 200;

nSamples = round(duration * srate);
period = 1 / srate;
seconds = (1:nSamples).*period;
data = zeros(1, nSamples);
for i=1:length(frequency)
    data = data + amplitude(i) * sin(2 * pi * frequency(i) * seconds);
end
%% confirm that signal was simulated as intended
figure
plot(data)
minFreq = 0.1;
window = round((2 / minFreq) * srate);
noverlap = round(window/2);
f = frequency;
figure
pwelch(data, window, noverlap, f, srate);
%% format input
EEG.data = data;
EEG.srate = srate;
detrendIn = struct('detrendChannels', 1, 'detrendType', 'linear', ...
                    'detrendCutoff', 0.5, 'detrendStepSize', 0.02, ...
                    'detrendCommand', []);
%%
[EEG, detrendOut] = removeTrend(EEG, detrendIn);

%% plot detrended data
figure
plot(EEG.data)
minFreq = 0.1;
window = round((2 / minFreq) * srate);
noverlap = round(window/2);
f = frequency;
figure
pwelch(EEG.data, window, noverlap, f, srate);
% Frequencies below 0.5 Hz not fully attenuated