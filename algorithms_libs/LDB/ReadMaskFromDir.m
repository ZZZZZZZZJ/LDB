function [D] = ReadMaskFromDir(Oridir,M,N,frame_st,frame_ed)
    ext         =  {'*.jpg','*.png','*.bmp'};
    filePaths   =  [];
    for i = 1 : length(ext)
        filePaths = cat(1,filePaths, dir(fullfile(Oridir,ext{i})));
    end
    im_dir        =   filePaths;
    im_num        =   frame_ed-frame_st+1;
    D             =   zeros(M,N,im_num);
    for i = 1:im_num
        Img     =   imread(fullfile(Oridir, im_dir(i+frame_st-1).name)) ;
        img     =   imresize(Img,[M,N]);
        tt      =   im2double( img );
        if size(tt,3) == 3
               tt = rgb2gray(tt);
        end
        D(:,:,i) = tt;
    end
end