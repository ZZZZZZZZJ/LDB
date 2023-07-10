% This is the testing demo for video background subtraction with OMoGMF on your video path

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Please cite the following papers:
% [1] Deyu Meng, Fernando De la Toree, Matrix Factorization with Unknown Noise. ICCV, 2013.
% [2] Hongwei Yong, Deyu Meng, Wangmeng Zuo, Lei Zhang, Robust Online Matrix Factorization for Dynamic Background Subtraction, IEEE Transactions on Pattern Analysis  and Machine Intelligence (TPAMI), 2017. In press.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Resources for research purpose only, shall not be used for commercial purposes! All copyrights belong to the original anthors. The technology has applied for patents.  If you want to purchase the patents for commercial purposes, please contact the corresponding author: Deyu Meng, dymeng@mail.xjtu.edu.cn. Thank you!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The code is written by Hongwei Yong. If having any question, feel free to contact: cshyong@comp.polyu.edu.hk or yonghw@stu.xjtu.edu.cn.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0, release date: 2017.8.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
currentFolder = pwd;
addpath(genpath(currentFolder))
para.k=3;
para.r=2;
para.display=1;
para.ro=0.98;
para.N=50;


para.startindex=[1,523];
para.startnumber=30;
para.iter=3;
dataname = 'pedestrians';
sigmalist = [15,25,50];
for idx = 1:1
    sigma = sigmalist(idx);
    %para.dataname = strcat(dataname,'/',num2str(sigma));
    para.dataname='PETS2006';
    video_path='/home/sdb/xxx/codes/CD/dataset/dataset2014/dataset/baseline/PETS2006/input/';
    tic;
    run_video(video_path,para);
    toc;
end

%para.startindex=[1,500];
%para.startnumber=30;
%para.iter=3;
%dataname = 'PETS2006';
%sigmalist = [15,25,50];
%for idx = 1:3
%    sigma = sigmalist(idx);
%    para.dataname = strcat(dataname,'/',num2str(sigma));
%    video_path = strcat('/home/iprai/zzj/CD/lowrank/noisydata/noisyimg/',dataname,'/Noisy/',num2str(sigma),'/NoiseImg/');
%video_path='/home/iprai/zzj/CD/lowrank/noisydata/highway/input/';%add your video image path 
%video_path='/home/iprai/zzj/CD/dataset/I2R/WaterSurface/'
%    run_video(video_path,para)
%end
