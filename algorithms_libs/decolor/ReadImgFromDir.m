function [D] = ReadImgFromDir(Oridir,ds_ratio,frame_st,frame_ed)
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
    D             =   zeros(img_H / ds_ratio,img_W / ds_ratio,im_num);
    for i = 1:im_num
        Img     =   imread(fullfile(Oridir, im_dir(i+frame_st-1).name)) ;
        img     =   downsample(Img,ds_ratio);
        tt      =   im2double( img );
        if size(tt,3) == 3
               tt = rgb2gray(tt);
        end
        D(:,:,i) = tt;
end
end

