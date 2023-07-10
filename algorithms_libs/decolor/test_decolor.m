clear all
close all

addpath('internal');
addpath(genpath('gco-v3.0'));

frame_idx=[
    % campus
%    200,600;
%    1,800;
%    801,1439;
    % fountain
%    1,523;
    % watersurface
%    1,633;
     %NoiseNight
%    1,300;
%    301,600;
%      %fountain01
      600,800;  
%      %fall
      1400,1600;
%      %snowFall
      800,1000;
%      %blizzard
      900,1100;
%      %boats
      1900,2100;
%      %fountain02
      500,700;
%      %overpass
      2300,2500;
%      %canoe
      800,1000;
   ];%% can be tuned

 %% data category
dataset_dir      = '/home/sdb/xxx/codes/CD/low-rank/dataset/dataset2014/dataset';
%dataset_dir      = '/home/sdb/xxx/codes/CD/low-rank/dataset/I2R/'
%dataset_dir      = '/home/xxx/xxx/CD/dataset/SABS-NoisyNight/SABS/Test/NoCamouflage';
static_dir       = '/home/xxx/xxx/CD/lowrank/LRMB/deeplab-Res';
edge_dir         = '/home/xxx/xxx/edge detection/opencv/StructuredForests/edges';
datacategorylist = str2mat('dynamicBackground' ,'dynamicBackground' , ...
                    'badWeather' ,'badWeather', ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'dynamicBackground' ,'dynamicBackground' );
datanamelist     = str2mat(...%'Campus','Campus','Campus','Fountain','WaterSurface', 'NoisyNight','NoisyNight',
    'fountain01', 'fall','snowFall','blizzard', ...
    'boats', 'fountain02', 'overpass', 'canoe');

num_task = size(frame_idx,1);

sigmalist = [0,15,25,50,11];

dirlist = str2mat('/home/xxx/xxx/CD/lowrank/noisydata/highway/input/', ...
    '/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/15/NoiseImg/', ...
'/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/25/NoiseImg/', ...
'/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/50/NoiseImg/', ...
'/home/xxx/xxx/CD/lowrank/noisydata/RainyHighway/img/');

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

for taskidx = 2:4
    %% input the image sequences 
    frame_st    =   frame_idx(taskidx,1); 
    frame_ed    =   frame_idx(taskidx,2);
    %datacategory =   strtrim(datacategorylist(taskidx,:));
    datacategory =   'baseline';
    dataname     =   strtrim(datanamelist(taskidx,:));
    ds_ratio    =    1;
    %frame_st = 500;
    %frame_ed = 700;
   % dataname = 'highway';
    %sigma = sigmalist(taskidx);
    
    disp('preparing the img data');
    Original_image_dir    =    fullfile(dataset_dir,datacategory,dataname,'input/');
    %Original_image_dir    =    fullfile(dataset_dir,dataname);
   % Original_image_dir     =    dataset_dir;
   % Original_image_dir = strtrim(dirlist(taskidx,:));
    %Original_image_dir    =    '/home/iprai/zzj/CD/dataset/I2R/WaterSurface/';
    ImData                =    ReadImgFromDir(Original_image_dir,ds_ratio,frame_st,frame_ed);
    tic;
    [LowRank,Mask,tau,info] = ObjDetection_DECOLOR(ImData);
    toc;
    
    resdir = fullfile('./result/',dataname,'/');  
    if (~exist(resdir,'dir'))
        mkdir(resdir);
    end
    
    for i = 1:size(ImData,3)
        figure(1); clf;
        subplot(2,2,1);
        imshow(ImData(:,:,i)), axis off, colormap gray; axis off;
        title('Original image','fontsize',12);
        subplot(2,2,2);
        imshow(LowRank(:,:,i)), axis off,colormap gray; axis off;
        title('Low Rank','fontsize',12);
        subplot(2,2,3);
        imshow(mat2gray(Mask(:,:,i))), axis off,colormap gray; axis off;
        filename = [resdir,'/bin' ,num2str(i+frame_st-1,'%06d'),'.png'];
        imwrite(mat2gray(Mask(:,:,i)),filename);  
        %hold on; contour(Mask(:,:,i),[0 0],'y','linewidth',5);
        title('Segmentation','fontsize',12);
        subplot(2,2,4);
        imshow(ImData(:,:,i).*double(Mask(:,:,i))), axis off, colormap gray; axis off;
        title('Foreground','fontsize',12);
%        writeVideo(myObj,getframe(1));
        drawnow;
    end
end
