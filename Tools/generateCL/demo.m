clc;  
clear;  

%Input Parameter
InputDir        =   './data/pedestrians/img/';
OutputDir       =   './data/pedestrians/fpcp/'
%InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/dynamicBackground/fall/input/';
%MaskDir  = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/dynamicBackground/fall/groundtruth/'
%numFrame = 201;
%start_frame = 1400;
%OutputDir = './test_data/fall/'
Mode            =   'FPCP'%AVG,RPCA

if (~exist(InputDir,'file'))
    disp('Input Dir not exist');
    return
end
mkdir(strcat(OutputDir,'C'));
mkdir(strcat(OutputDir,'L'));

addpath(genpath('./RPCA'));
addpath(genpath('./RPCA_base'));
addpath(genpath('./FPCP'));

img_path_list   =   dir(strcat(InputDir,'*.jpg'));%获取该文件夹中所有jpg格式的图像
img_num         =   length(img_path_list);%获取图像总数量
Cal_FrameN      =   img_num;

%mask_path_list  =   dir(strcat(MaskDir,'*.png'));
    
%read one frame every time  
for i = 1:Cal_FrameN  
    image_name  =   img_path_list(i).name;% 图像名
    image       =   imread(strcat(InputDir,image_name));
    double_P    =   im2double(image);  
    
   % mask_name   =   mask_path_list(i+start_frame-1).name;
   % mask        =   imread(strcat(MaskDir,mask_name));
   % double_P    =   im2double(image).*(1-im2double(mask));
    %double_P    =   rgb2gray( double_P); 
    M(:, i)     =   double_P(:);   
end  
   
tic;

%%FPCP
if (strcmpi(Mode , 'FPCP'))
 lambda  =   1/sqrt(max(size(M))); % default lambda
 [L, S]  =   fastpcp(M,lambda);
end

%%AVG
if (strcmpi(Mode , 'AVG'))
    Sum = double(zeros(size(M(:,1))));
    for i = 1:Cal_FrameN
        Sum = Sum + M(:,i);
    end
    Avg = Sum / Cal_FrameN;
    for i = 1:Cal_FrameN
        L(:,i) = Avg;
        S(:,i) = M(:,i) - L(:,i);
    end
end

%%RPCA
if (strcmpi(Mode , 'RPCA'))
    [L,S] = RPCA(M,size(double_P));
end

disp(['toc rpca',num2str(toc),'s']);

figure();
for i = 1:Cal_FrameN
    A           =   reshape(L(:,i), size(double_P));  
    E           =   reshape(S(:,i), size(double_P)); 
    imname      =   strcat(OutputDir,'L/in',num2str(i,'%06d'),'.jpg');
    imwrite((A),imname);
    imname      =   strcat(OutputDir,'C/in',num2str(i,'%06d'),'.jpg');
    imwrite((E),imname);
end 
