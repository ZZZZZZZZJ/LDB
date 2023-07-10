function runningtime = LSD_algorithm(dataname, img_dir,frame_range)
    disp(['perform algorithm LSD on image dirname:' img_dir, ', frame range is:', num2str(frame_range)]);
    ds_ratio = 1;
    frame_st = frame_range(1);
    frame_ed = frame_range(2);
    ImData   = ReadImgFromDir(img_dir,ds_ratio,frame_st,frame_ed);

    [M,N,T]  = size(ImData);

    sizeImg  = [size(ImData,1),size(ImData,2)];
    numImg   = size(ImData,3);
    D2       = mat2gray(ImData); % 0~1
    ImMean   = mean(D2(:)); 
    D2       = D2 - ImMean; % subtract mean is recommended
    D3       = reshape(D2,prod(sizeImg),numImg);   
    
    tic;
    graph = getGraphSPAMS(sizeImg,[3,3]);% for  lsd
    [L_d S_d iter] = inexact_alm_lsd(D3,graph);   % lsd without L_21 TIP 2015
    runningtime = toc;
    
    S = ForegroundMask(S_d,D3,L_d,0); 
    S = reshape(S,[sizeImg,numImg]);
    background = zeros(size(ImData));
    S_f = zeros(size(ImData));
    L_d = uint8(mat2gray(reshape(L_d,size(ImData))+ImMean)*256); %Background

    for i = 1:T
        S_f(:,:,i) = imresize(S(:,:,i),[M,N],'box');  % back to origin size
        background(:,:,i) = imresize(L_d(:,:,i),[M,N],'box');  
    end

    foreground = uint8(256.*abs(S_f));

    resdir = strcat('./results/LSD/',dataname,'/');
    if (~exist(resdir,'dir'))
        mkdir(resdir);
    end
    for i = 1:size(ImData,3) 
        outtext = [resdir,'/bin', num2str(frame_st+i-1,'%06d'),'.png'];
        imwrite(foreground(:,:,i),outtext);      
    end 

end