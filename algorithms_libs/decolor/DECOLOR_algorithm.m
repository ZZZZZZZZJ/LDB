function runningtime = DECOLOR_algorithm(dataname, img_dir,frame_range)
    disp(['perform algorithm DECOLOR on image dirname:' img_dir, ', frame range is:', num2str(frame_range)]);
    ds_ratio = 1;
    frame_st = frame_range(1);
    frame_ed = frame_range(2);
    ImData   = ReadImgFromDir(img_dir,ds_ratio,frame_st,frame_ed);
    
    tic;
    [LowRank,Mask,tau,info] = ObjDetection_DECOLOR(ImData);
    runningtime = toc;
    
    resdir = fullfile('./results/DECOLOR/',dataname,'/');  
    if (~exist(resdir,'dir'))
        mkdir(resdir);
    end
    
    for i = 1:size(ImData,3)
       % figure(1); clf;
       % subplot(2,2,1);
       % imshow(ImData(:,:,i)), axis off, colormap gray; axis off;
       % title('Original image','fontsize',12);
        %subplot(2,2,2);
       % imshow(LowRank(:,:,i)), axis off,colormap gray; axis off;
       % title('Low Rank','fontsize',12);
        %subplot(2,2,3);
      %  imshow(mat2gray(Mask(:,:,i))), axis off,colormap gray; axis off;
        filename = [resdir,'/bin' ,num2str(i+frame_st-1,'%06d'),'.png'];
        imwrite(mat2gray(Mask(:,:,i)),filename);  
        %hold on; contour(Mask(:,:,i),[0 0],'y','linewidth',5);
      %  title('Segmentation','fontsize',12);
        %subplot(2,2,4);
       % imshow(ImData(:,:,i).*double(Mask(:,:,i))), axis off, colormap gray; axis off;
        %title('Foreground','fontsize',12);
%        writeVideo(myObj,getframe(1));
        %drawnow;
    end

end
