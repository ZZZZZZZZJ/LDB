function runningtime = TVRPCA_algorithm(dataname, img_dir,frame_range)
    disp(['perform algorithm TVRPCA on image dirname:' img_dir, ', frame range is:', num2str(frame_range)]);
    ds_ratio = 1;
    frame_st = frame_range(1);
    frame_ed = frame_range(2);
    ImData   = ReadImgFromDir(img_dir,ds_ratio,frame_st,frame_ed);

    idx = 1:size(ImData,3);
    [img_H,img_W,numImg] = size(ImData);
    lambda = [0.4 2 1];
    tic;
    [D_hat B_hat F_hat E_hat M_hat] = rpca_tv(ImData, idx, lambda);
    runningtime = toc;

    F_hat = abs(F_hat) / max(max(abs(F_hat)))>0.1;
    filelen = size(F_hat,2);
    resdir = fullfile('./results/TVRPCA/',dataname,'/');  
    if (~exist(resdir,'dir'))
        mkdir(resdir);
    end
    for i = 1:filelen
        filename = [resdir, '/bin', num2str(i+frame_st - 1,'%06d'), '.png'];
        F_imgcol = F_hat(:,i);
        F_img = reshape(F_imgcol,[img_H,img_W]);
        imwrite(F_img,filename);
    end

end