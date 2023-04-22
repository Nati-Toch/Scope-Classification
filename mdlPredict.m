function prediction = mdlPredict(test,mdl,norm_center,norm_scale,fs)
    test_features = GetFeatures(test,fs); % getting the features of the observation
    test_features = normalize(test_features, 'center', norm_center, 'scale', norm_scale); % normalizing the features
    prediction = predict(mdl,test_features); % predicting the scope
end