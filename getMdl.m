function [mdl, norm_center, norm_scale] = getMdl(train1,train2,train3,train4,train5,fs,section_len)
%%-----The Main Settings-----%%

num_samples = length(train1); % the number of samples from each scope
rows = floor(num_samples/section_len); % the number of rows
feat_size = 10; % we will have 13 features

%%-----Dividing The Model To Sections-----%%

labels = [1+zeros(rows,1); 2+zeros(rows,1) ; 3+zeros(rows,1); 4+zeros(rows,1) ; 5+zeros(rows,1)]; % the labels of the scope - 1 to 5
train_a = CreateSamples(train1,section_len)'; % dividing the original samples of scope 1 to a number of section, each with the length of the test sample
train_b = CreateSamples(train2,section_len)'; % dividing the original samples of scope 2 to a number of section, each with the length of the test sample
train_c = CreateSamples(train3,section_len)'; % dividing the original samples of scope 3 to a number of section, each with the length of the test sample
train_d = CreateSamples(train4,section_len)'; % dividing the original samples of scope 4 to a number of section, each with the length of the test sample
train_e = CreateSamples(train5,section_len)'; % dividing the original samples of scope 5 to a number of section, each with the length of the test sample

%%-----Creating The Features-----%%

feat_a = zeros(rows,feat_size); % an empty matrix of the 1st scope features
feat_b = zeros(rows,feat_size); % an empty matrix of the 2nd scope features
feat_c = zeros(rows,feat_size); % an empty matrix of the 3rd scope features
feat_d = zeros(rows,feat_size); % an empty matrix of the 4th scope features
feat_e = zeros(rows,feat_size); % an empty matrix of the 5th scope features
for i = 1:rows % getting the features of every scope, based on the length of the section so we would have a number of observations
    feat_a(i,:) = GetFeatures(train_a(i,:)',fs);
    feat_b(i,:) = GetFeatures(train_b(i,:)',fs);
    feat_c(i,:) = GetFeatures(train_c(i,:)',fs);
    feat_d(i,:) = GetFeatures(train_d(i,:)',fs);
    feat_e(i,:) = GetFeatures(train_e(i,:)',fs);
end
features = [feat_a;feat_b;feat_c;feat_d;feat_e]; % combining the features
features = [features labels]; % combining the features with the labels

%%-----Splitting Into Train-Test Sets And Normalizing-----%%

n = length(features(:,1));
cvp = cvpartition(n,'Holdout',0.7); % 70%- test, 30%- train
idxTrain = training(cvp); % getting the indices of the train set
dataTrain = features(idxTrain,:); % seperating train and test
idxTest = test(cvp); % getting the indices of the test set
dataTest = features(idxTest,:); % seperating train and test

xTrain = dataTrain(:,1:end-1); % getting the train features
[xTrain, c,s]= normalize(xTrain); % normalizing the train features
yTrain = dataTrain(:,end); % train labels
xTest = dataTest(:,1:end-1); % getting the test features
xTest = normalize(xTest, 'center', c, 'scale', s); % normalizing the test features based on the train normalization 
yTest = dataTest(:,end); % test labels
norm_center = c; % the center of the normaliztion
norm_scale = s; % the scale of the normaliztion

%%-----Training The Model-----%%

template = templateEnsemble('Bag',100,'Tree'); % the classifier
% ferror = @(xTrain,yTrain,xTest,yTest) nnz(yTest ~= predict(fitcecoc(xTrain,yTrain,"Learners",template),xTest));
% tokeep = sequentialfs(ferror,xTrain,yTrain,"cv",2);
mdl = fitcecoc(xTrain,yTrain,"Learners",template); % training the model

%%-----Testing And Evaluating The Model-----%% 

p = predict(mdl,xTest); % predictiong the test set
mdlLoss = loss(mdl,xTest,yTest) % calculationg the accuracy
confusionchart(p,yTest) % printing confusion matrix
end