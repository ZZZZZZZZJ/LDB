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

%% define testing dataname list
%%baseline
%datanamelist = str2mat('highway','office','PETS2006','pedestrians');
%datanamelist = str2mat('badminton','boulevard','sidewalk','traffic');
datanamelist = str2mat('abandonedBox','parking','sofa','streetLight','tramstop','winterDriveway',...
    'backdoor','bungalows','busStation','copyMachine','cubicle','peopleInShade',...
    'corridor','diningRoom','lakeSide','library','park',...
    'turbulence0','turbulence1','turbulence2','turbulence3',...
    'port_0_17fps','tramCrossroad_1fps','tunnelExit_0_35fps','turnpike_0_5fps',...
    'bridgeEntry','busyBoulvard','fluidHighway','streetCornerAtNight','tramStation','winterStreet');
%datanamelist = obtain_datanamelist_from_category(str2mat('baseline','cameraJitter','intermittentObjectMotion','shadow','thermal','turbulence','lowFramerate','nightVideos'));
%% 'baseline','cameraJitter','intermittentObjectMotion','shadow','thermal','turbulence','lowFramerate','nightVideos'
%datanamelist = str2mat('Campus','Fountain','WaterSurface',...
%    'NoCamouflage', ...
%    'fountain01','fall','boats', 'fountain02', 'overpass', 'canoe', ...
%    'snowFall', 'blizzard', 'skating', 'wetSnow');

algorithmlist = str2mat('RPCA','OMoGMF','LSD','GOSUS','DECOLOR','TVRPCA','LDB');
%'RPCA','OMoGMF','LSD','GOSUS','DECOLOR','TVRPCA','LDB');
%% evaluate complexity setting
%Complexity_Evaluation = true;
Complexity_Evaluation = false;
Complexity_Range = 50;

log_file = ['logs/',datestr(now),'.txt'];
filelog = fopen(log_file,'w');

%% test dataname with algorithms
for algorithmidx = 1:size(algorithmlist,1)
    algorithm = strtrim(algorithmlist(algorithmidx,:));
    alg_func = obtain_algorithm_function(algorithm);
    for datanameidx = 1:size(datanamelist,1)
        dataname = strtrim(datanamelist(datanameidx,:));
        cfg_dataname = config_by_dataname(dataname);
        img_dir = cfg_dataname.datadir;
        test_frame_range = cfg_dataname.frame_idx;
        %% if evaluate complexity, only test one time with pre-defined complexity range.
        if Complexity_Evaluation
            start_frame = test_frame_range(1);
            test_frame_range = [start_frame,start_frame + Complexity_Range - 1];
        end
        for taskidx = 1:size(test_frame_range,1)
            frame_range = test_frame_range(taskidx,:);
            running_time = feval(alg_func,dataname,img_dir,frame_range);
            stats = evaluate_video(dataname,algorithm);
            fprintf(filelog,['algorithm:',algorithm,', dataname:', dataname, ', frame_range:', num2str(frame_range), ', running time:', num2str(running_time), ', results:', num2str(stats), '\n']);
        end    
    end
end

fclose(filelog);






