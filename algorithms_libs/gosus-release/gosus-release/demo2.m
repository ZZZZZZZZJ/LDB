function demo2
    clc
    clear
    close all

    addpath('./util/build-group/');
    addpath('./util');

   % gosus_video('/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/dataset2014/dataset', ...
   %     './result/badminton', ...
   %     'in*.jpg', ...
   %     'cameraJitter/badminton/input', ...
   %     900)
    
   % gosus_video('/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/dataset2014/dataset', ...
   %     './result/boulevard', ...
   %     'in*.jpg', ...
   %     'cameraJitter/boulevard/input',...
   %     900)

    gosus_video('/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/dataset2014/dataset', ...
        './result/sidewalk', ...
        'in*.jpg', ...
        'cameraJitter/sidewalk/input',...
        900)
    
    gosus_video('/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/dataset2014/dataset', ...
        './result/traffic', ...
        'in*.jpg', ...
        'cameraJitter/traffic/input',...
        1000)
 

end

function gosus_video(inputPath,outputPath,dirString, dataname, endIndex)
    regularizer = 0.1;
    param.superpixel.slicParam = [10, regularizer; 20, regularizer;  40,regularizer ; 80,regularizer; ];

    %  param.superpixel.slicParam = [5,regularizer;  10, regularizer; 20, regularizer;  40,regularizer ; ];

    param.maxIter =100;
    param.tol = 1e-4;

    %param.input.dataPath = '/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/dataset2014/dataset';
    param.input.dataPath = inputPath;%'/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/I2R/';
    param.output.resultPath = outputPath;%'./result-snowFall/';
    %param.input.dirString = 'in*.jpg';
    param.input.dirString = dirString%'*.bmp';

    param.input.dataset = dataname%'Fountain'; 

    param.saveResult = 1;
    param.showResult = 0;
    
    param.output.threshold  = 0.1;
    param.lambda =10;   

    param.rank = 5; % subspace dimension
    param.eta = 0.01;  % stepsize for subspace updating
%     param.sampleSize = 200; % number of sample frames to learn the background
%     param.trainSize = 5000; % train with all available images
    param.startIndex = 1;
    param.endIndex = endIndex;
    param.randomStart = true;
  
        
    param     
     
    gosus(param); 
end



 