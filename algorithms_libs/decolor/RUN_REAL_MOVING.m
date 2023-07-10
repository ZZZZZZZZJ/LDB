clear all
close all

addpath('internal');
addpath(genpath('gco-v3.0'));

%% data
% static background
dataList = {'people1','people2','cars6','cars7'};

for dataID = 1:4
    
    dataName = dataList{dataID};
    load(['data\' dataName],'ImData');
    
    %% run DECOLOR
    opt.flagAlign = 1;
    opt.tol = 1e-3;
    [LowRank,Mask,tau,info] = ObjDetection_DECOLOR(ImData,opt);
    
    % warp masks to match the original images
    for i = 1:size(ImData,3)
        % use [Iwarp,Omega] = warpImg(I,tau,mode,extrapval)
        Mask(:,:,i) = warpImg(double(Mask(:,:,i)),tau(:,i),1,0)>0.5;
        cropRatio = 0.01;
        Mask([1:round(cropRatio*size(Mask,1)),round((1-cropRatio)*size(Mask,1)):end],:,i) = false;
        Mask(:,[1:round(cropRatio*size(Mask,2)),round((1-cropRatio)*size(Mask,2)):end],i) = false;
    end
    save(['result\' dataName '_DECOLOR.mat'],'dataName','Mask','LowRank','tau','info');
    
    
    %% displaying
    load(['result\' dataName '_DECOLOR.mat'],'dataName','Mask','LowRank','tau');
    moviename = ['result\' dataName,'_DECOLOR.avi']; fps = 12;
    mov = avifile(moviename,'fps',fps,'compression','none');
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
        mov = addframe(mov,getframe(1));
    end
    h = close(mov);
    
end
