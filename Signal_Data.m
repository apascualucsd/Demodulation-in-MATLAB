% Load the complex binary signal
signal = read_complex_binary('mp3_signal_IQ_1.dat');

% Original sampling rate and desired sampling rate
original_rate = 48000;
desired_rate = 17000;
SamplesPerSymbol = 5;

% Step 1: Downconvert the signal to baseband
fc = 3840; % Carrier frequency to downconvert to baseband
n = (0:length(signal)-1)'; % Create a time vector (transpose to column vector)
downconverted_signal = signal .* exp(-1j*2*pi*fc/original_rate*n);

figure(1);
plot(real(downconverted_signal));

Y = fft(downconverted_signal);
Y_mag = abs(Y).^2 / length(downconverted_signal); % Magnitude squared
Y_dB = 20*log10(Y_mag);
Fs = 17000; % Actual sample rate of the signal
f = linspace(-Fs/2, Fs/2, length(downconverted_signal));

figure(2);
plot(f, fftshift(Y_dB)); % Center the zero frequency component
xlabel('Frequency');
ylabel('Power Spectrum (dB)');
title('Power Spectrum of mp3');
