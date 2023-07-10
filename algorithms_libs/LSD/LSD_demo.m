% % **************************************************************************************************************
% % This is a code for Low-rank and Structured sparse matrix Decomposition (LSD)
% % If you happen to use this source code, please cite our papers:
% %
% % [1] "Background Subtraction Based on Low-rank and Structured Sparse Decomposition"
% % Xin Liu, Guoying Zhao, Jiawen Yao, Chun Qi.
% % IEEE Transactions on Image Processing, Vol. 24, No. 8, pp. 2502 - 2514, 2015.
% %
% % [2] "Foreground detection using Low rank and Structured sparsity"
% % Jiawen Yao, Xin Liu, Chun Qi.
% % IEEE ICME 2014. pp. 1 - 6, 2014 
% % 
% % Please note this code is only for LSD, the first-pass of background subtraction as described in our paper. 
% % The motion sailency check and Group-sparse RPCA (second-pass) are not included. 
% % 
% % For problems about our source code, please email Xin: linuxsino@gmail.com  or  Jiawen: yjiaweneecs@gmail.com 
% % **************************************************************************************************************

clc;
clear all

addpath(genpath('spams-matlab')); %add path for SPAMS tools

frame_idx=[
    %%-----I2R----------------------------
    % campus
    1,800;
    801,1439;
    % fountain
    1,523;
    % watersurface
    1,633;
    
    %%-------------NoisyNight---------------------------
    %NoiseNight
    1,200;
    201,400;
    401,600;
    
    %%-------------DynamicBackground------------------------------
     %fountain01
     600,800;  
     %fall
     1400,1600;
     %boats
     1900,2100;
     %fountain02
     500,700;
     %overpass
     2300,2500;
     %canoe
     800,1000;
     
     %snowFall
     800,1000;
     %blizzard
     900,1100;
     %skating
     800,1000;
     %wetSnwo
     500,700;
   ];%% can be tuned

 %% data category
 dataset_dir_night     = '/home/sdb/xxx/codes/CD/low-rank/dataset/SABS-NoisyNight/SABS/Test/NoCamouflage/';
dataset_dir      = '/home/sdb/xxx/codes/CD/low-rank/dataset/dataset2014/dataset';
dataset_dir_I2R      = '/home/sdb/xxx/codes/CD/low-rank/dataset/I2R/';
static_dir       = '/home/iprai/xxx/CD/lowrank/LRMB/deeplab-Res';
edge_dir         = '/home/iprai/xxx/edge detection/opencv/StructuredForests/edges';
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

num_task = size(frame_idx,1);
%task = [5,6,11,15,16];

sigmalist = [0,15,25,50,11,22];

dirlist = str2mat('/home/iprai/zzj/CD/lowrank/noisydata/highway/input/', ...
    '/home/iprai/zzj/CD/lowrank/noisydata/NoisyHighway/15/NoiseImg/', ...
'/home/iprai/zzj/CD/lowrank/noisydata/NoisyHighway/25/NoiseImg/', ...
'/home/iprai/zzj/CD/lowrank/noisydata/NoisyHighway/50/NoiseImg/', ...
'/home/iprai/zzj/CD/lowrank/noisydata/RainyHighway/img/',...
'/home/iprai/zzj/CD/lowrank/noisydata/RainyHighway/rainfall/img/');

taskidxs = [13, 14, 10];
output = [0,0,0];

%%%%For baseline 4 sequences
%frame_idx=[
   %highway
%      500,550;
      %office
%      600,650;
      %pedestrains
%      300,350;
      %PET2006
%      400,450;
%   ];%% can be tuned

frame_region = [
   %badminton
       800,850;
   %boulevard
       800,850;
   %sidewalk
       800,850;
   %traffic
       900,950];

datanamelist = str2mat('badminton', 'boulevard', 'sidewalk', 'traffic');
%datanamelist = str2mat('highway','office','pedestrians','PETS2006');

for taskidx = 1:4
    %taskidx      =   task(idx);
    %taskidx = taskidxs(idx)
    %% input the image sequences 
    frame_st     =   frame_idx(taskidx,1); 
    frame_ed     =   frame_idx(taskidx,2);
    %datacategory = 'baseline';
    datacategory = 'cameraJitter';
    %datacategory =   strtrim(datacategorylist(taskidx,:));
    dataname     =   strtrim(datanamelist(taskidx,:));
    ds_ratio     =   1;
    %frame_st = 500;
    %frame_ed = 700;
    %dataname = 'highway';
    %sigma = sigmalist(taskidx);
    
    disp('preparing the img data');
    %Original_image_dir = strtrim(dirlist(taskidx,:));
    Original_image_dir    =    fullfile(dataset_dir,datacategory,dataname,'input/');
     %if (taskidx <= 4)
     %    Original_image_dir = fullfile(dataset_dir_I2R,dataname);
     %elseif (taskidx <= 7)
     %    Original_image_dir = dataset_dir_night;
     %else
     %    Original_image_dir    =    fullfile(dataset_dir,datacategory,dataname,'input/');
     %end
    %Original_image_dir    =    '/home/iprai/zzj/CD/dataset/I2R/WaterSurface/';
    ImData                =    ReadImgFromDir(Original_image_dir,ds_ratio,frame_st,frame_ed);

    [M,N,T]=size(ImData);

    %% first-pass: LSD 
    sizeImg = [size(ImData,1),size(ImData,2)];
    numImg = size(ImData,3);
    D2 = mat2gray(ImData); % 0~1
    ImMean = mean(D2(:)); 
    D2 = D2 - ImMean; % subtract mean is recommended
    D3 = reshape(D2,prod(sizeImg),numImg);   
    disp('first-pass LSD');

    graph = getGraphSPAMS(sizeImg,[3,3]);% for  lsd
    [L_d S_d iter] = inexact_alm_lsd(D3,graph);   % lsd without L_21 TIP 2015
    
%[L_d S_d iter] = rpca_lsd(D3,graph);  %lsd with L_21 ICME 2014

%% using a very smple method to binarize foreground 

    S = ForegroundMask(S_d,D3,L_d,0); 
    S = reshape(S,[sizeImg,numImg]);
    background = zeros(size(ImData));
    S_f = zeros(size(ImData));
    L_d = uint8(mat2gray(reshape(L_d,size(ImData))+ImMean)*256); %Background

    for i = 1:T
        S_f(:,:,i) = imresize(S(:,:,i),[M,N],'box');  % back to origin size
        background(:,:,i) = imresize(L_d(:,:,i),[M,N],'box');  
    end

    foreground = uint8(256.*abs(S_f));

    resdir = strcat('./result/',dataname,'/');
    if (~exist(resdir,'dir'))
        mkdir(resdir);
    end
    for i = 1:size(ImData,3)
        figure(1); clf;
        subplot(1,3,1);
        imshow(ImData(:,:,i)), axis off, colormap gray; axis off;
        title('Frames','fontsize',12);
        outtext = ['./results/Img/', num2str(frame_st+i-1),'.png'];
        imwrite(ImData(:,:,i),outtext);  
     
        subplot(1,3,2);
        imshow(foreground(:,:,i)), axis off,colormap gray; axis off;   
        title('Foreground','fontsize',12);
        outtext = [resdir,'/bin', num2str(frame_st+i-1,'%06d'),'.png'];
        imwrite(foreground(:,:,i),outtext);      
 
        subplot(1,3,3);
        imshow(background(:,:,i)), axis off,colormap gray; axis off;   
        title('Background','fontsize',12);
        outtext = ['./results/BG/', num2str(frame_st+i-1),'.png'];
        imwrite(background(:,:,i),outtext);  
        drawnow; 
    end 
end
disp(output)





