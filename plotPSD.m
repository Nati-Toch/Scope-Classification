function func = plotPSD(train1,train2,train3,train4,train5)
section_len = 5000;
fs = 50e3;
train_a = CreateSamples(train1,section_len)'; % dividing the original samples of scope 1 to a number of section, each with the length of the test sample
train_b = CreateSamples(train2,section_len)'; % dividing the original samples of scope 2 to a number of section, each with the length of the test sample
train_c = CreateSamples(train3,section_len)'; % dividing the original samples of scope 3 to a number of section, each with the length of the test sample
train_d = CreateSamples(train4,section_len)'; % dividing the original samples of scope 4 to a number of section, each with the length of the test sample
train_e = CreateSamples(train5,section_len)'; % dividing the original samples of scope 5 to a number of section, each with the length of the test sample
train = [train_a(1,:); train_b(1,:); train_c(1,:); train_d(1,:); train_e(1,:);];
for i = 1:5
    [p, f] = pwelch(train(i,:),[],[],[],fs);
    [pks,locs] = findpeaks(p,'npeaks',10);
    plot(f,p,'.-')
    grid on
    hold on
    plot(f(locs),pks,'o')
end
xlim([0 500])
hold off
title('Power Spectral Density with Peaks Estimates')
xlabel('Frequency (Hz)')
ylabel('Power')
legend('train1','','train2','','train3','','train4','','train5')
end