x1resampled = dlmread('adc_data_1_long.txt')
x1resampled = x1resampled / 1024 * 4;
Fs = 3e6;
F1 = 121e3;
tmin = 0;
tmax = 3/F1;
t = tmin:100e-9:tmax;
Ts = 1/Fs;
ts = tmin:Ts:tmax;
x1 = cos(4*pi*F1*t);
x1reconstructed = zeros(1,length(t)); %preallocating for speed
samples = length(ts);
for i = 1:1:length(t)
    for n = 1:1:samples
        x1reconstructed(i) = x1reconstructed(i) + x1resampled(n)*sinc((t(i)-n*Ts)/Ts);
    end
end
figure(1)
plot(t,x1reconstructed)
title("Reconstructed signal in time-domain")
xlabel("t (s)")
ylabel("V (V)")
