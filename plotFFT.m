function func = plotFFT(train1,train2,train3,train4,train5)
section_len = 5000;
fs = 50e3;
train_a = CreateSamples(train1,section_len)'; % dividing the original samples of scope 1 to a number of section, each with the length of the test sample
train_b = CreateSamples(train2,section_len)'; % dividing the original samples of scope 2 to a number of section, each with the length of the test sample
train_c = CreateSamples(train3,section_len)'; % dividing the original samples of scope 3 to a number of section, each with the length of the test sample
train_d = CreateSamples(train4,section_len)'; % dividing the original samples of scope 4 to a number of section, each with the length of the test sample
train_e = CreateSamples(train5,section_len)'; % dividing the original samples of scope 5 to a number of section, each with the length of the test sample
train = [train_a(1,:); train_b(1,:); train_c(1,:); train_d(1,:); train_e(1,:);];
for i = 1:5
    N = length(train(i,:)); % number of samples
    N2 = 0:N/2; % we need only half (fourier transform is simetric)
    Y = fft(train(i,:),N); % fourier transform
    [peak,idx] = max(abs(Y(N2+2))/N); % finding the peak
    plot(N2/N*fs,abs(Y(N2+1))/N)
    hold on
    xaxis = N2/N*fs;
    xaxis(1) = [];
    plot(xaxis(idx),peak,'o')
end
grid on
hold off
title('fft of the 5 scopes [m/sec^2]')
ylabel('absolute Fourier Transform [m/sec^2]')
xlabel('frequency [HZ]')
xlim([0 500])
legend('train1','','train2','','train3','','train4','','train5')
end