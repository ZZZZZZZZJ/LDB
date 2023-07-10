function [C] = DNCNN(D,dataname)
addpath(genpath('/home/iprai/zzj/CD/lowrank/LRMB/DnCNN_TrainingCodes_v1.0/'));

format compact;

[img_H,img_W,channel,numImg] = size(D);
C = zeros(img_H,img_W,numImg);

showResult  = 1;
saveResult  = 0;
useGPU      = 1;
pauseTime   = 0;

modelName   = 'model_64_25_Res_Bnorm_Adam';
epoch       = 50;

modelbootdir = '/home/iprai/zzj/CD/lowrank/LRMB/DnCNN_TrainingCodes_v1.0/data';
%%% load model
load(fullfile(modelbootdir,dataname,[modelName,'-epoch-',num2str(epoch),'.mat']));
net = vl_simplenn_tidy(net);
net.layers = net.layers(1:end-1);

%%%
net = vl_simplenn_tidy(net);

for i = 1:size(net.layers,2)
     net.layers{i}.precious = 1;
end

%%% move to gpu
if useGPU
    net = vl_simplenn_move(net, 'gpu') ;
end

for i = 1:numImg
    input = im2single(D(:,:,:,i));  
    
    %%% convert to GPU
    if useGPU
        input = gpuArray(input);
    end
    
    res    = vl_simplenn(net,input,[],[],'conserveMemory',true,'mode','test');
    output = res(end).x;
        %%% convert to CPU
    if useGPU
        output = gather(output);
    end
    
    C(:,:,i) = 0.299*output(:,:,1)+0.587*output(:,:,2)+0.114*output(:,:,3);
    %C(:,:,i) = output;

    if showResult 
        imshow(cat(2,im2uint8(rgb2gray(input)),im2uint8(rgb2gray(input-output)),im2uint8(rgb2gray(output))));
        drawnow;
        pause(pauseTime)
    end
    
    if saveResult
        filename = strcat('./results/CNNResults/',num2str(i),'.jpg');
        imwrite(abs(output),filename);
    end
end
end