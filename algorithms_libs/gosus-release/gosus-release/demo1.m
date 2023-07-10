function demo1
    clc
    clear
    close all

    addpath('./util/build-group/');
    addpath('./util');


    regularizer = 0.1;
    param.superpixel.slicParam = [10, regularizer; 20, regularizer;  40,regularizer ; 80,regularizer; ];

    %  param.superpixel.slicParam = [5,regularizer;  10, regularizer; 20, regularizer;  40,regularizer ; ];

    param.maxIter =200;
    param.tol = 1e-4;

    % data path
%     param.input.dataPath = '../../../dataset/dataset2014/dataset/dynamicBackground/fountain01/input';
%     param.output.resultPath = './result-fountain01';
%     param.input.dirString = '*.jpg';

    param.input.dataset = ''; 

    param.saveResult = 1;
    param.showResult = 0;

    param.output.threshold  = 8e-6;
    param.lambda =0.33;    %   bestAccu = 0.9762, lambda = 0.33; threshold = 8e-6;
    
    param.rank = 5; % subspace dimension
    param.eta = 1e-3 ;   % stepsize for subspace updating
    param.sampleSize = 200; % number of sample frames to learn the background
    param.trainSize = 240; % sample from the fist 240 frames to learn the background
    param.startIndex = 1;   %  which frame to start
    param.randomStart = false;  

 
    param


dirlist = str2mat('/home/xxx/xxx/CD/lowrank/noisydata/highway/input/', ...
    '/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/15/NoiseImg/', ...
'/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/25/NoiseImg/', ...
'/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/50/NoiseImg/');
     

     param.input.dataPath = strtrim(dirlist(3,:));
     param.output.resultPath = './result-highway25';
     param.input.dirString = '*.jpg';
 
     gosus(param);      

     param.input.dataPath = strtrim(dirlist(4,:));
     param.output.resultPath = './result-highway50';
     param.input.dirString = '*.jpg';
 
     gosus(param);      
     
%     gosus(param);
% 
%      param.input.dataPath = '/home/iprai/zzj/CD/dataset/I2R/Campus';
%      param.output.resultPath = './result-Campus';
%      param.input.dirString = '*.bmp';
%  
%      gosus(param);  
%      
%      param.input.dataPath = '/home/iprai/zzj/CD/dataset/I2R/Fountain';
%      param.output.resultPath = './result-Fountain';
%      param.input.dirString = '*.bmp';
%  
%      gosus(param);  
%      
%      param.input.dataPath = '/home/iprai/zzj/CD/dataset/I2R/WaterSurface';
%      param.output.resultPath = './result-WaterSurface';
%      param.input.dirString = '*.bmp';
%  
%      gosus(param); 

    
%     param.input.dataPath = '../../../dataset/dataset2014/dataset/dynamicBackground/canoe/input';
%     param.output.resultPath = './result-canoe';
%     param.input.dirString = '*.jpg';
% 
%     gosus(param);  
%     
%     param.input.dataPath = '../../../dataset/dataset2014/dataset/dynamicBackground/boats/input';
%     param.output.resultPath = './result-boats';
%     param.input.dirString = '*.jpg';
% 
%     gosus(param);  
% 
%     
%     param.input.dataPath = '../../../dataset/dataset2014/dataset/dynamicBackground/fountain02/input';
%     param.output.resultPath = './result-fountain02';
%     param.input.dirString = '*.jpg';
% 
%     gosus(param);  
%     
%     param.input.dataPath = '../../../dataset/dataset2014/dataset/badWeather/snowFall/input';
%     param.output.resultPath = './result-snowFall';
%     param.input.dirString = '*.jpg';
%     
%     gosus(param);  
%     
%     param.input.dataPath = '../../../dataset/dataset2014/dataset/badWeather/blizzard/input';
%     param.output.resultPath = './result-blizzard';
%     param.input.dirString = '*.jpg';
%     
%     gosus(param);  
end



