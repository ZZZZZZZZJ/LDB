function [ CNNData ] = Tri_DCNN_Color(ImData,dataname)
    addpath(genpath('/home/iprai/zzj/CD/lowrank/LRMB/3DCNN'));
    
opts.idx_gpus = 1; % 0: cpu
opts.num_images = 32; % images to be generated
opts.matconvnet_path = '/home/iprai/zzj/CD/lowrank/LRMB/3DCNN/matconvnet-master/matlab/vl_setupnn.m';
opts.net_path = strcat('/home/iprai/zzj/CD/lowrank/LRMB/3DCNN/data/',dataname,'/net-epoch-50.mat'); 
opts.save_img_path = 'test_img_DCGAN';

%opts = vl_argparse(opts, varargin);

if ~exist(opts.save_img_path, 'dir'), mkdir(opts.save_img_path) ; end
run(opts.matconvnet_path);

%% load network
net = load(opts.net_path);
net = net.net(1); % idx 1: Generator, 2: Discriminator
net = dagnn.DagNN.loadobj(net);
net.mode = 'test';

if opts.idx_gpus >0
    gpuDevice();
    net.move('gpu');
end


rng('default')
    
    [m,n,c,t] = size(ImData);
    batchSize = 5;
    batchNum = floor(t/batchSize);
    residulSize = mod(t,batchSize);
    for i = 1:batchNum
        x(:,:,:,:) = ImData(:,:,:,(i-1)*batchSize+1:i*batchSize); 
        data = im2single(x);
        if opts.idx_gpus >0,   data = gpuArray(data);    end
        %net.eval({'input',data});
        %im_out = gather(net.vars(net.getVarIndex('conv10')).value);
        im_out = NetForward(net,data);
        CNNData(:,:,(i-1)*batchSize+1:i*batchSize) = im_out;
    end
    if residulSize == 0 
        return; 
    end
    x = ImData(:,:,:,t-batchSize+1:t);
    data = im2single(x);
    if opts.idx_gpus >0,   data = gpuArray(data);    end
    %net.eval({'input',data});
    %im_out = gather(net.vars(net.getVarIndex('conv10')).value);
    im_out = NetForward(net,data);
    CNNData(:,:,t-batchSize+1:t) = im_out;
end

function output_img = NetForward(net,data)
   [img_H,img_W,ChannelImg,numImg] = size(data);
   divide_H = 9;
   divide_W = 9;
   patch_size_H = img_H / divide_H;
   patch_size_W = img_W / divide_W;
   batchCnt = 0;
   for H_k = 1:divide_H
       for W_k = 1:divide_W
            batchCnt = batchCnt + 1;
            for c = 1:3
                x(:,:,:,c,batchCnt) = data((H_k-1)*patch_size_H+1:H_k*patch_size_H,(W_k-1)*patch_size_W+1:W_k*patch_size_W,c,:);                
            end
       end
   end
   for Cnt = 1:batchCnt
        data = im2single(x(:,:,:,:,Cnt));
        randn('seed',0);

       % if opts.idx_gpus >0,   data = gpuArray(data);    end

        net.eval({'input',data});
        im_out = gather(net.vars(net.getVarIndex('conv10')).value);
        output(:,:,:,:,Cnt) = im_out;
               
    end
    batchCnt = 0;
    for H_k = 1:divide_H
        for W_k = 1:divide_W
            batchCnt = batchCnt + 1;
            for c = 1:3
                data_out = output(:,:,:,c,batchCnt);
                [P_H,P_W,P_T] = size(data_out);
                for t = 1:P_T
                    output_whole((H_k-1)*patch_size_H+1:H_k*patch_size_H,(W_k-1)*patch_size_W+1:W_k*patch_size_W,c,t) = data_out(:,:,t);   
                end
            end
        end
    end
    for i = 1:numImg
        output_img(:,:,i) = rgb2gray(output_whole(:,:,:,i));
    end
   
end
