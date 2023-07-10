clear all
close all

addpath('internal');
addpath(genpath('gco-v3.0'));
%addpath(genpath('/home/iprai/software/matconvnet-1.0-beta25/matlab'));
%vl_setupnn;

frame_idx=[
    %%-----I2R----------------------------
    % campus
    1,200;
    201,400;
    401,600;
    601,800;
    801,1000;
    1001,1200;
    1201,1439;
    % fountain
    1,523;
    % watersurface
    1,633;
    
    %%-------------NoisyNight---------------------------
    %NoiseNight
    1,300;
    301,600;
    
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
 dataset_dir_night     = '/home/sdb/xxx/codes/CD/dataset/SABS-NoisyNight/SABS/Test/NoisyNight/';
dataset_dir      = '/home/sdb/xxx/codes/CD/dataset/dataset2014/dataset';
dataset_dir_I2R      = '/home/sdb/xxx/codes/CD/dataset/I2R/';
static_dir       = '/home/sdb/xxx/codes/CD/low-rank/deeplab-Res';
edge_dir         = '/home/sdb/xxx/codes/edge detection/opencv/StructuredForests/edges';
optical_dir      = '/home/sdb/xxx/codes/CD/opticalflow/flownet2-pytorch/res';
datacategorylist = str2mat('','','','','', '','','','','','', ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'dynamicBackground' ,'dynamicBackground' , ...
                    'badWeather' ,'badWeather', ...
                    'badWeather' ,'badWeather');
datanamelist     = str2mat('Campus','Campus','Campus','Campus','Campus','Campus','Campus',...
    'Fountain','WaterSurface' ,...
    'NoisyNight','NoisyNight', ...
    'fountain01','fall','boats', 'fountain02', 'overpass', 'canoe', ...
    'snowFall', 'blizzard', 'skating', 'wetSnow');

num_task = size(frame_idx,1);

CNNDir = '/home/sdb/xxx/codes/CD/low-rank/DnCNN-PyTorch/test';

tasks = [8,14,17,18];
output_time = [0,0,0,0];

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

for idx = 1:4
    taskidx = idx;%tasks(idx);
    %% input the image sequences 
    frame_st     =   frame_idx(taskidx,1); 
    frame_ed     =   frame_idx(taskidx,2);
    %datacategory =   strtrim(datacategorylist(taskidx,:));
    datacategory =   'baseline';
    dataname     =   strtrim(datanamelist(taskidx,:));
    ds_ratio     =   1;
    
    disp('preparing the img data');
    %if taskidx <= 9
    %    Original_image_dir    =    fullfile(dataset_dir_I2R, dataname);
    %elseif taskidx <= 11
    %    Original_image_dir    =    dataset_dir;
    %else
        Original_image_dir    =    fullfile(dataset_dir,datacategory,dataname,'input/'); 
    %end
    %Original_image_dir    =    fullfile(dataset_dir,datacategory,dataname,'input/');
    %Original_image_dir    =    fullfile(dataset_dir,dataname);
    %Original_image_dir     =    dataset_dir;
    %Original_image_dir    =    '/home/iprai/zzj/CD/dataset/I2R/WaterSurface/';
    ImData                =    ReadImgFromDir(Original_image_dir,ds_ratio,frame_st,frame_ed);
    [M,N,T]    = size(ImData);
    
%    ImgC            =   ReadCImgFromDir(Original_image_dir,ds_ratio,frame_st,frame_ed);
    %CNNData         =   DNCNN(ImgC,dataname);
    %CNNData         =   Tri_DCNN(ImData,dataname);
    %CNNData         =   Tri_DCNN_Color(ImgC,dataname);
    CNNData         =   zeros(size(ImData));
    %CNNData         =   ReadImgFromDir('./CNN/canoe',ds_ratio,1,201);
    %CNNData         =   ReadCNNMatFromDir(CNNDir,dataname);
    
%    EdgeData        =   ReadImgFromDir(fullfile(edge_dir,dataname),ds_ratio,frame_st,frame_ed);
    EdgeData        =   zeros(size(ImData));
    
    Original_static_dir   =    fullfile(static_dir,dataname);
    %MaskData        =    ReadMaskFromDir(Original_static_dir,size(ImData,1),size(ImData,2),frame_st,frame_ed);
    MaskData = zeros(size(ImData));
%    disp('preparing the optical flow');
%    OpticalFlow     =    readOpticalFlowFromDir(optical_dir,dataname,frame_st,frame_ed);
    
    for delta0 = 30:30
    opt.delta0 = delta0;
    tic;
    [LowRank,Mask,tau,info,E,C] = ObjDetection_DECOLOR_3D(ImData,CNNData,MaskData,opt);
    
 %   [LowRank,Mask,tau,info,E,C] = ObjDetection_DECOLOR_3D(ImData,CNNData,MaskData,opt);
    output_time(idx) = toc;   
    
    resdir = fullfile('./result/',dataname); 
%     resdir = fullfile('./test/');
    if (~exist(resdir,'dir'))
        mkdir(resdir);
    end
    for i = 1:size(ImData,3)
        figure(1); clf;
        subplot(2,2,1);
        imshow(ImData(:,:,i)), axis off, colormap gray; axis off;
%         filename = [resdir,'/img/bin' ,num2str(i+frame_st-1,'%06d'),'.png'];
%         imwrite(mat2gray(ImData(:,:,i)),filename);  
        title('Original image','fontsize',12);
        subplot(2,2,2);
        imshow(LowRank(:,:,i)), axis off,colormap gray; axis off;
%         filename = [resdir,'/background/bin' ,num2str(i+frame_st-1,'%06d'),'.png'];
%         imwrite(mat2gray(LowRank(:,:,i)),filename);  
        title('Low Rank','fontsize',12);
        subplot(2,2,3);
        imshow(mat2gray(Mask(:,:,i))), axis off,colormap gray; axis off;
        filename = [resdir,'/bin' ,num2str(i+frame_st-1,'%06d'),'.png'];
%         filename = [resdir,'/mask/bin' ,num2str(i+frame_st-1,'%06d'),'.png'];
        imwrite(mat2gray(Mask(:,:,i)),filename);  
        %hold on; contour(Mask(:,:,i),[0 0],'y','linewidth',5);
        title('Segmentation','fontsize',12);
        subplot(2,2,4);
        imshow(ImData(:,:,i).*double(Mask(:,:,i))), axis off, colormap gray; axis off;
%         filename = [resdir,'/foreground/bin' ,num2str(i+frame_st-1,'%06d'),'.png'];
%         imwrite(mat2gray(ImData(:,:,i).*double(Mask(:,:,i))),filename);
        title('Foreground','fontsize',12);
%        writeVideo(myObj,getframe(1));
        drawnow;
        
%         filename = [resdir,'/clutter/bin' ,num2str(i+frame_st-1,'%06d'),'.png'];
%         imwrite(mat2gray(10*reshape(C(:,i),[M,N])),filename);
    end
    end
    disp(output_time);
end
