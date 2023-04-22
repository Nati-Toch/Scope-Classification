function func = plotAutoCorrelation(train1,train2,train3,train4,train5)
section_len = 5000;
fs = 50e3;
train_a = CreateSamples(train1,section_len)'; % dividing the original samples of scope 1 to a number of section, each with the length of the test sample
train_b = CreateSamples(train2,section_len)'; % dividing the original samples of scope 2 to a number of section, each with the length of the test sample
train_c = CreateSamples(train3,section_len)'; % dividing the original samples of scope 3 to a number of section, each with the length of the test sample
train_d = CreateSamples(train4,section_len)'; % dividing the original samples of scope 4 to a number of section, each with the length of the test sample
train_e = CreateSamples(train5,section_len)'; % dividing the original samples of scope 5 to a number of section, each with the length of the test sample
train = [train_a(1,:); train_b(1,:); train_c(1,:); train_d(1,:); train_e(1,:);];
for i =1:5
    [c, lags] = xcorr(train(i,:)); % getting the cross-correlation
    minprom = 100; % because our correlation is in the scale of hundreds, we want our prominance atleast 100
    mindist = 0.01; % we want our distance between the peaks be atleast 0.01 away (normalized)
    minpkdist = floor(mindist/(1/fs)); % matching the distance to the real scale
    [pks,locs] = findpeaks(c,'minpeakprominence',minprom,'minpeakdistance',minpkdist); % finding the peaks and their locations
    tc = (1/fs)*lags;
    plot(tc,c)
    hold on
    plot(tc(locs((end+1)/2:(end+1)/2+2)),c(locs((end+1)/2:(end+1)/2+2)),'o')
end
grid on
hold off
title('Auto-Corellation of 5 scopes')
ylabel('Auto Correlation')
xlabel('Normalized Samples')
legend('train1','','train2','','train3','','train4','','train5')
end