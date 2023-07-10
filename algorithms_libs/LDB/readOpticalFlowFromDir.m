function [D] = readOpticalFlowFromDir(optical_dir,dataname,frame_st,frame_ed)
    fpath         =   fullfile(optical_dir,dataname, '*.flo');
    im_dir        =   dir(fpath);
    im_num        =   frame_ed-frame_st+1;
    Flow          =   readFlowFile(fullfile(optical_dir,dataname, im_dir(1).name));
    img_H         =   size(Flow,1);
    img_W         =   size(Flow,2);
    D             =   zeros(img_H ,img_W,2,im_num);
    for i = 1:im_num
        flow      =   readFlowFile(fullfile(optical_dir,dataname, im_dir(i+frame_st-1).name)) ;
%        tt        =   im2double( flow );
        img       =   flowToColor(flow);
        imshow(img);
        D(:,:,:,i) = flow;
    end
end

