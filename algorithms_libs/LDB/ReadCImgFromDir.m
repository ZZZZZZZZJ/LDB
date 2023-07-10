function [D] = ReadCImgFromDir(Oridir,ds_ratio,frame_st,frame_ed)
    fpath         =   fullfile(Oridir, '*.bmp');
    im_dir        =   dir(fpath);
    im_num        =   frame_ed-frame_st+1;
    Img           =   imread(fullfile(Oridir, im_dir(1).name)) ;
    img_H         =   size(Img,1);
    img_W         =   size(Img,2);
    D             =   zeros(img_H / ds_ratio,img_W / ds_ratio,3,im_num);
    for i = 1:im_num
        Img     =   imread(fullfile(Oridir, im_dir(i+frame_st-1).name)) ;
        img     =   downsample(Img,ds_ratio);
        tt      =   im2double( img );
        D(:,:,:,i) = tt;
end
end

