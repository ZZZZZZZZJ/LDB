clc;  
clear;  

addpath(genpath('./RPCA'));
addpath(genpath('./RPCA_base'));
addpath(genpath('./FPCP'));
addpath(genpath('./PCP'));
addpath(genpath('./GoDec'));

%Input Parameter
frame_idx=[
    %%-----I2R----------------------------
    % campus
%     1,800;
%     801,1439;
%     % fountain
%     1,523;
%     % watersurface
%     1,633;
%     
%     %%-------------NoisyNight---------------------------
%     %NoiseNight
%     1,200;
%     201,400;
%     401,600;
%     
%     %%-------------DynamicBackground------------------------------
%      %fountain01
%      600,800;  
%      %fall
%      1400,1600;
%      %boats
%      1900,2100;
%      %fountain02
%      500,700;
%      %overpass
%      2300,2500;
%      %canoe
%      800,1000;
%      
%      %snowFall
%      800,1000;
%      %blizzard
%      900,1100;
%      %skating
%      800,1000;
%      %wetSnwo
%      500,700;
     %office
     570,770;
     %pedestrains
     300,500;
     %PET2006
     300,500;
   ];%% can be tuned

 %% data category
dataset_dir_I2R   = '/home/iprai/zzj/CD/dataset/I2R';
dataset_dir_night = '/home/iprai/zzj/CD/dataset/SABS-NoisyNight/SABS/Test/NoCamouflage/';
dataset_dir_CD    = '/home/iprai/zzj/CD/dataset/dataset2014/dataset';

datacategorylist = str2mat('','','','','', '', '', ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'badWeather' ,'badWeather', ...
                    'badWeather' ,'badWeather');
                
datanamelist     = str2mat('Campus','Campus','Fountain','WaterSurface' ,...
    'NoCamouflage','NoCamouflage','NoCamouflage', ...
    'fountain01','fall','boats', 'fountain02', 'overpass', 'canoe', ...
    'snowFall', 'blizzard', 'skating', 'wetSnow');

sigmalist = [15,25,50,11];
datanamelist     = str2mat('office','pedestrians','PETS2006');

%%%%For baseline 4 sequences
frame_idx=[
   %highway
      500,550;
      %office
      600,650;
      %pedestrains
      300,350;
      %PET2006
      400,450;
   ];%% can be tuned

datanamelist = str2mat('highway','office','pedestrians','PETS2006');
dataset_dir      = '/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/dataset2014/dataset';

for taskidx = 1:1
    %% input the image sequences 
    frame_st    =   frame_idx(taskidx,1); 
    frame_ed    =   frame_idx(taskidx,2);
    %datacategory =   strtrim(datacategorylist(taskidx,:));
    datacategory =   'baseline';
    dataname     =   strtrim(datanamelist(taskidx,:));
    ds_ratio    =    1;
    
    
    disp('preparing the img data');
    Original_image_dir    =    fullfile(dataset_dir,datacategory,dataname,'input/');
%     if (taskidx <= 4)
%         Original_image_dir = fullfile(dataset_dir_I2R,dataname);
%     elseif(taskidx <= 7)
%         Original_image_dir = dataset_dir_night;
%     else
%         Original_image_dir = fullfile(dataset_dir_CD,datacategory,dataname,'input/');
%     end
    disp(Original_image_dir);
    ImData                =    ReadImgFromDir(Original_image_dir,ds_ratio,frame_st,frame_ed);
    [M,N,T]    = size(ImData);
    
    sizeImg = [size(ImData,1),size(ImData,2)];
    numImg = size(ImData,3);
    D2 = mat2gray(ImData); % 0~1
    ImMean = mean(D2(:)); 
    D2 = D2 - ImMean; % subtract mean is recommended
    D3 = reshape(D2,prod(sizeImg),numImg);
    
    tic;
    [L,S] = RPCA(D3,sizeImg);
   %  lambda = 1/sqrt(max(size(D3))); % default lambda
   %  tol = 1e-5;
   %  [L,S] = PCP(D3,lambda,tol);
   
   %[L,S] = RPCA(D3,sizeImg);

%     rank = 1;
%     card = numel(D3); %card = 3.1e+5;
%     power = 0;
%     [L,S] = GoDec(D3,rank,card,power);

    O     = hard_threshold(S);
    disp(['toc rpca',num2str(toc),'s']);
    
    OutputDir = strcat('./res/',dataname,'/');
    if(~exist(OutputDir))
    mkdir(strcat(OutputDir,'C'));
    mkdir(strcat(OutputDir,'L'));
    mkdir(strcat(OutputDir,'M'));
    end
    
    for i = 1:numImg
    A           =   reshape(L(:,i), sizeImg);  
    E           =   reshape(S(:,i), sizeImg); 
    M           =   reshape(O(:,i), sizeImg);
    imname      =   strcat(OutputDir,'L/in',num2str(i+frame_st-1,'%06d'),'.jpg');
    imwrite((A),imname);
    imname      =   strcat(OutputDir,'C/in',num2str(i+frame_st-1,'%06d'),'.jpg');
    imwrite((E),imname);
    imname      =   strcat(OutputDir,'bin',num2str(i+frame_st-1,'%06d'),'.png');
    imwrite((M),imname);
    end 
end

