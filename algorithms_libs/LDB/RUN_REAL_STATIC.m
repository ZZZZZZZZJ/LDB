clear all
close all

addpath('internal');
addpath(genpath('gco-v3.0'));

%% data
% static background
dataList = {'office','pedestrian','airport','waterSurface','hall','smoke'};

for dataID = 1:1
    
    dataName = dataList{dataID}; 
    load(['./CDNet2014/' dataName '.mat'],'ImData');
    
    %% run DECOLOR
    [LowRank,Mask,tau,info] = ObjDetection_DECOLOR(ImData);
    save(['./result\' dataName '_DECOLOR.mat'],'dataName','Mask','LowRank','tau','info');    
    
    %% displaying
    load(['./result\' dataName '_DECOLOR.mat'],'dataName','Mask','LowRank','tau');
    moviename = ['result\' dataName,'_DECOLOR.avi']; fps = 12;
    myObj = VideoWriter(moviename);%Ŀ����Ƶ·�������
    writerObj.FrameRate = fps;
    open(myObj);
    for i = 1:size(ImData,3)
        figure(1); clf;
        subplot(2,2,1);
        imshow(ImData(:,:,i)), axis off, colormap gray; axis off;
        title('Original image','fontsize',12);
        subplot(2,2,2);
        imshow(LowRank(:,:,i)), axis off,colormap gray; axis off;
        title('Low Rank','fontsize',12);
        subplot(2,2,3);
        imshow(ImData(:,:,i)), axis off,colormap gray; axis off;
        hold on; contour(Mask(:,:,i),[0 0],'y','linewidth',5);
        title('Segmentation','fontsize',12);
        subplot(2,2,4);
        imshow(ImData(:,:,i).*uint8(Mask(:,:,i))), axis off, colormap gray; axis off;
        title('Foreground','fontsize',12);
        writeVideo(myObj,getframe(1));
    end
    close(myObj);
    
end
