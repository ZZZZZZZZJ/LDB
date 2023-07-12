addpath(genpath('/home/sdb/zhangzhijun/codes/CD/low-rank/generatePatchForVideo/generateCL'));
%Config
datanamelist  = str2mat('canoe','boats','fall','fountain01','fountain02','overpass','blizzard','skating','snowFall','wetSnow');

for taskidx = 1:10
    dataname     =   strtrim(datanamelist(taskidx,:));
    dataname = 'NoCamouflage';
    makeannotations_bydataname(dataname,'AVG');
    makeannotations_bydataname(dataname,'FPCP');
    makeannotations_bydataname(dataname,'GoDec');
end

function makeannotations_bydataname(dataname,mode)
cfg = Config(dataname);
DatasetRootDir = cfg.InputDir;

train_range = cfg.train_range;
test_range  = cfg.test_range;

GenerateClutter(DatasetRootDir,fullfile(dataname,'train',mode),train_range,mode,true);
GenerateClutter(DatasetRootDir,fullfile(dataname, 'test',mode), test_range,mode,false);
end

function GenerateClutter(InputDir,OutputDir,range,mode,is_train)
    Img    = ReadImgFromDir(fullfile(InputDir,'input'),range(1),range(2));
    Mask   = ReadImgFromDir(fullfile(InputDir,'groundtruth'),range(1),range(2));
    if (is_train == false)
        ImData = Img .* (1-Mask) ;
    else
    ImData = Img;
    end
    
     sizeImg = [size(ImData,1),size(ImData,2)];
     numImg  = size(ImData,3);
     D3      = reshape(ImData,prod(sizeImg),numImg);
     M       = reshape(Mask,  prod(sizeImg),numImg);
    
    tic;
    if (strcmpi(mode , 'RPCA'))
        [L,S] = RPCA(D3,sizeImg);
    end
    if (strcmpi(mode , 'PCP'))
        lambda = 1/sqrt(max(size(D3))); % default lambda
        tol = 1e-5;
        [L,S] = PCP(D3,lambda,tol);
    end
    if (strcmpi(mode , 'GoDec'))
        rank = 1;
        card = numel(D3); %card = 3.1e+5;
        power = 0;
        [L,S] = GoDec(D3,rank,card,power);
    end
    if (strcmpi(mode , 'FPCP'))
        lambda  =   1/sqrt(max(size(D3))); % default lambda
        [L, S]  =   fastpcp(D3,lambda);
    end
    
    if (strcmpi(mode , 'AVG'))
        Sum = double(zeros(size(D3(:,1))));
        for i = 1:numImg
            Sum = Sum + D3(:,i);
        end
        Avg = Sum / numImg;
        for i = 1:numImg
            L(:,i) = Avg;
            S(:,i) = D3(:,i) - L(:,i);
        end
        S(:,i) = S(:,i) .* (1-M(:,i));
    end
    toc;
    
    if ~exist(OutputDir)
        mkdir(fullfile(OutputDir,'C'));
        mkdir(fullfile(OutputDir,'B'));
    end
    
    C = zeros(size(ImData));
    for i = 1:numImg
        A           =   reshape(L(:,i), sizeImg);  
        E           =   reshape(S(:,i), sizeImg); 
        C(:,:,i)    =   5*E;
        imname      =   strcat(OutputDir,'/B/in',num2str(i+range(1)-1,'%06d'),'.jpg');
        imwrite((A),imname);
        imname      =   strcat(OutputDir,'/C/in',num2str(i+range(1)-1,'%06d'),'.jpg');
        imwrite((E),imname);
    end 
    
    imname      =   strcat(OutputDir,'/C/data.mat');
    save(imname, 'C');
end

function [D] = ReadImgFromDir(Oridir,frame_st,frame_ed)
    ext         =  {'*.jpg','*.png','*.bmp'};
    filePaths   =  [];
    for i = 1 : length(ext)
        filePaths = cat(1,filePaths, dir(fullfile(Oridir,ext{i})));
    end
    im_dir        =   filePaths;
    im_num        =   frame_ed-frame_st+1;
    Img           =   imread(fullfile(Oridir, im_dir(1).name)) ;
    img_H         =   size(Img,1);
    img_W         =   size(Img,2);
    D             =   zeros(img_H ,img_W ,im_num);
    for i = 1:im_num
        Img     =   imread(fullfile(Oridir, im_dir(i+frame_st-1).name)) ;
        tt      =   im2double( Img );
        if size(tt,3) == 3
               tt = rgb2gray(tt);
        end
        D(:,:,i) = tt;
    end
end
