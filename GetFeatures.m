function feat = GetFeatures(train,fs)
feat(1) = mean(train); % 1st feature - the mean of the signal
feat(2) = var(train); % 2nd feature - the variance of the signal
feat(3) = rms(train); % 3rd feature - the root mean square of the signal
feat(4:6) = covFeatures(train,fs); % features 4 to 6 are the first 3 peaks of the auto-correlation
feat(7:9) = spectralPeaksFeatures(train,fs); % feature 7 to 12 are the 6 biggest peaks of the PSD
feat(10) = GetFFT(train); % the peak of the fourier transform of the signal

%%-----Auto-Corellation Peak Features-----%%

    function feats = covFeatures(x, fs)

        feats = zeros(1,3); % wew will have 3 features

        [c, lags] = xcorr(x); % getting the auto-correlation

        minprom = 100; % because our correlation is in the scale of hundreds, we want our prominance atleast 100
        mindist = 0.01; % we want our distance between the peaks be atleast 0.01 away (normalized)
        minpkdist = floor(mindist/(1/fs)); % matching the distance to the real scale
        [pks,locs] = findpeaks(c,'minpeakprominence',minprom,'minpeakdistance',minpkdist); % finding the peaks and their locations
        lcl = lags(locs); % the locations of the peaks

        % Feature 4 - peak height at 0
        if(~isempty(lcl))   % else f1 already 0
            feats(1) = pks((end+1)/2); % the peak at zero
        end
        % Features 5 and 6 - first and second peak amplitudes
        if(length(lcl) >= 3)   % else f2,f3 already 0
            feats(2) = pks((end+1)/2+1); % the amplitude of the first peak
            feats(3) = pks((end+1)/2+2); % amplitude of second peak
        end
    end

%%-----Power Spectral Density Peaks Features-----%%

    function feats = spectralPeaksFeatures(x, fs)

        feats = zeros(1,3);

        [p, ~] = pwelch(x,[],[],[],fs);        
        [pks,locs] = findpeaks(p,'npeaks',10);

        if(~isempty(pks))
            mx = min(3,length(pks)); % if there are more than 6 peaks, minimize it to 6
            [spks, idx] = sort(pks,'descend'); % sorting the peaks by value of amplitude
            slocs = locs(idx); % peak locations (the 6 highest)

            pks = spks(1:mx); % vector of peaks
            locs = slocs(1:mx); % vector of locations

            [~, idx] = sort(locs,'ascend'); % sorting the locations to be in order
            spks = pks(idx); % 3 largest peaks
            pks = spks; % renamig for simplicity
        end

        % Features 7-9 power levels of highest 3 peaks
        feats(1:length(pks)) = pks; % the value of the 3 peaks amplitude
    end

%%-----Fourier Transform Features-----%%

    function feats = GetFFT(x)
        N = length(x); % number of samples
        N2 = 0:N/2; % we need only half (fourier transform is simetric)
        Y = fft(x,N); % fourier transform
        [peak,~] = max(abs(Y(N2+2))/N); % finding the peak
        feats = peak; % the feature if the peak
    end

end