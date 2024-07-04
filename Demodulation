% Load the complex binary signal
signal = read_complex_binary('mp3_signal_IQ_1.dat');

% Original sampling rate and desired sampling rate
original_rate = 48000;
desired_rate = 17000;
SamplesPerSymbol = 5;

% Step 1: Downconvert the signal to baseband
fc = 3840; % Carrier frequency to downconvert to baseband
n = 0:length(signal)-1; % Create a time vector
downconverted_signal = signal .* exp(-1j*2*pi*fc/original_rate*n).';

% Step 2: Apply Low-Pass Filter (Chebyshev Type II)
cutoff_freq = 8500; % Adjusted cutoff frequency for half-sample rate
stopband_ripple = 80; % Stopband attenuation in dB
normalized_cutoff = cutoff_freq / (original_rate / 2);

% Design the Chebyshev Type II filter
[filter_order, Wn] = cheb2ord(normalized_cutoff, normalized_cutoff * 1.1, 1, stopband_ripple);
[b, a] = cheby2(filter_order, stopband_ripple, Wn);

% Apply the Chebyshev Type II filter to the downconverted signal
filtered_signal = filter(b, a, downconverted_signal);

% Step 3: Resample the filtered signal
resampled_signal = resample(filtered_signal, desired_rate, original_rate);

% Load the preamble
preamble_data = load('mp3_signal_IQ_1_encoded_preamble_signal_space.mat');
preamble = preamble_data.encoded_preamble_signal_space;

%Step 4: Decision making
threshold2 = 0.65 * max(real(resampled_signal));
decoded_signal = ask_demodulation(real(resampled_signal), threshold2);

% Step 5: Cross-correlation to detect the preamble
r_ds = correlate(real(decoded_signal), preamble);

% Set the threshold for peak detection
threshold = 0.65 * max(r_ds);

% Find the peaks above the threshold
peaks = r_ds(r_ds > threshold);

% Find the peak indices
peak_indices = find(r_ds > threshold);

% Find the first and second peak indices
first_peak_index = peak_indices(1);

demodulated_bits = decoded_signal(first_peak_index+1.5:first_peak_index+1.5+79);
manchester_bits = manchester(demodulated_bits);

figure(1);
plot(real(signal), imag(signal), '.');
title('Constellation Diagram of Signal');
xlabel('I (In-phase)');
ylabel('Q (Quadrature)');
axis equal;
grid on;

figure(2);
plot(real(downconverted_signal), imag(downconverted_signal), '.');
title('Constellation Diagram of Down Signal');
xlabel('I (In-phase)');
ylabel('Q (Quadrature)');
axis equal;
grid on;

figure(3);
plot(real(filtered_signal), imag(filtered_signal), '.');
title('Constellation Diagram of Filtered Signal');
xlabel('I (In-phase)');
ylabel('Q (Quadrature)');
axis equal;
grid on;

figure(5);
plot(real(resampled_signal), imag(resampled_signal), '.');
title('Constellation Diagram of Resampled Signal');
xlabel('I (In-phase)');
ylabel('Q (Quadrature)');
axis equal;
grid on;

figure(6);
plot(demodulated_bits, '-o'); 
title('Demodulated Bits');
xlabel('Bit Index');
ylabel('Value');
grid on;

figure(7);
plot(preamble, '-o');
title('Encoded Preamble Signal Space');
xlabel('Index');
ylabel('Amplitude');
grid on;

figure(8);
plot(r_ds);
title('Cross-correlation r_{ds}(m)');
xlabel('Shift (m)');
ylabel('Cross-correlation Value');

Y = fft(downconverted_signal);
Y_mag = abs(Y).^2 / length(downconverted_signal); % Magnitude squared
Y_dB = 20*log10(Y_mag);
Fs = 17000; % Actual sample rate of the signal
f = linspace(-Fs/2, Fs/2, length(downconverted_signal));

figure(9);
plot(f, fftshift(Y_dB)); % Center the zero frequency component
xlabel('Frequency');
ylabel('Power Spectrum (dB)');
title('Power Spectrum at Baseband');

figure(10);
plot(real(resampled_signal));
title('Impulse Response of Resampled Signal');
xlabel('Sample Index');
ylabel('Magnitude');
xlim([0,5]);
grid on;

figure(11);
plot(decoded_signal);
title('Impulse Response of Decoded Signal');
xlabel('Sample Index');
ylabel('Magnitude');
xlim([0,5]);
grid on;

figure(12);
plot(manchester_bits, '-o');
title('Manchester Decoded Bits');
xlabel('Bit Index');
ylabel('Magnitude');
grid on;

Y1 = fft(signal);
Y_mag1 = abs(Y1).^2 / length(signal); % Magnitude squared
Y_dB1 = 20*log10(Y_mag1);
Fs1 = 48000; % Actual sample rate of the signal
f1 = linspace(-Fs1/2, Fs1/2, length(signal));

figure(13);
plot(f1, fftshift(Y_dB1)); % Center the zero frequency component
xlabel('Frequency');
ylabel('Power Spectrum (dB)');
title('Power Spectrum of mp3');

function bits = ask_demodulation(signal_segment, threshold)
    bits = 2*(signal_segment < threshold) - 1;
end

function [Manchester_Decode_out] = manchester(Manchester_decode_input)
inp_len = length(Manchester_decode_input);
Manchester_Decode_out = zeros(1,inp_len/2);
for i=1:2:inp_len
    if(Manchester_decode_input(i) == -1 && Manchester_decode_input(i+1) == 1)
        Manchester_Decode_out((i+1)/2) = 1;
    elseif(Manchester_decode_input(i) == 1 && Manchester_decode_input(i+1) == -1)
        Manchester_Decode_out((i+1)/2) = 0;
    else
        Manchester_Decode_out((i+1)/2) = -1; %to show errors 
    end
end
end
