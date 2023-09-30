X = dlmread('adc_data_1_long.txt')
Fs = 3e6;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = length(X);             % Length of signal
t = (0:L-1)*T;        % Time vector

X = X./1024*4;
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
hf = figure();
plot(f,P1)
title("Single-sided amplitude spectrum")
xlabel("f (Hz)")
ylabel("|V(f)|")
print (hf, "plot15_7.pdf", "-dpdflatexstandalone");
