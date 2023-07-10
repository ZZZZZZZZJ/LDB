clc;
clear all

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
%dataset_dir      = '/home/xxx/xxx/CD/dataset/dataset2014/dataset';
dataset_dir_night     = '/home/sdb/xxx/codes/CD/low-rank/dataset/SABS-NoisyNight/SABS/Test/NoisyNight/';
dataset_dir      = '/home/sdb/xxx/codes/CD/low-rank/dataset/dataset2014/dataset';
%dataset_dir      = '/home/sdb/xxx/codes/CD/low-rank/dataset/I2R/'
static_dir       = '/home/xxx/xxx/CD/lowrank/LRMB/deeplab-Res';
edge_dir         = '/home/xxx/xxx/edge detection/opencv/StructuredForests/edges';
datacategorylist = str2mat('','','','','', '', '', ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'badWeather' ,'badWeather', ...
                    'badWeather' ,'badWeather');
datanamelist     = str2mat('Campus','Campus','Fountain','WaterSurface' ,...
    'NoisyNight','NoisyNight', 'NoisyNight', ...
    'fountain01','fall','boats', 'fountain02', 'overpass', 'canoe', ...
    'snowFall', 'blizzard', 'skating', 'wetSnow');

%task = [5,6,11,15,16];

sigmalist = [0,15,25,50,11,22];

dirlist = str2mat('/home/xxx/xxx/CD/lowrank/noisydata/highway/input/', ...
    '/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/15/NoiseImg/', ...
'/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/25/NoiseImg/', ...
'/home/xxx/xxx/CD/lowrank/noisydata/NoisyHighway/50/NoiseImg/', ...
'/home/xxx/xxx/CD/lowrank/noisydata/RainyHighway/img/',...
'/home/xxx/xxx/CD/lowrank/noisydata/RainyHighway/rainfall/img/');

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


for taskidx = 1:4
  %  taskidx      =   task(idx);
    %% input the image sequences 
    frame_st     =   frame_idx(taskidx,1); 
    frame_ed     =   frame_idx(taskidx,2);
    %datacategory =   strtrim(datacategorylist(taskidx,:));
    datacategory =   'baseline';
    dataname     =   strtrim(datanamelist(taskidx,:));
    ds_ratio     =   1;
    %frame_st = 500;
    %frame_ed = 700;
    %dataname = 'highway';
    %sigma = sigmalist(taskidx);

    disp('preparing the img data');
    %Original_image_dir = strtrim(dirlist(taskidx,:));
    Original_image_dir    =    fullfile(dataset_dir,datacategory,dataname,'input/');
    %if (taskidx <= 7)
    %    Original_image_dir = dataset_dir_night;
    %else
    %    Original_image_dir    =    fullfile(dataset_dir,datacategory,dataname,'input/');
    %end
    %Original_image_dir    =    fullfile(dataset_dir,dataname);
    ImData                =    ReadImgFromDir(Original_image_dir,ds_ratio,frame_st,frame_ed);

    idx = 1:size(ImData,3);
    [img_H,img_W,numImg] = size(ImData);
    lambda = [0.4 2 1];
    tic;
    [D_hat B_hat F_hat E_hat M_hat] = rpca_tv(ImData, idx, lambda);
    toc;

    F_hat = abs(F_hat) / max(max(abs(F_hat)))>0.1;
    filelen = size(F_hat,2);
    resdir = fullfile('./result/',dataname,'/');  
    if (~exist(resdir,'dir'))
        mkdir(resdir);
    end
    for i = 1:filelen
        filename = [resdir, '/bin', num2str(i+frame_st - 1,'%06d'), '.png'];
        F_imgcol = F_hat(:,i);
        F_img = reshape(F_imgcol,[img_H,img_W]);
        imwrite(F_img,filename);
    end
end
