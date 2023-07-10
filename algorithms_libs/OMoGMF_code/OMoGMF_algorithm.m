function runningtime = OMoGMF_algorithm(dataname, img_dir,frame_range)
    disp(['perform algorithm OMoGMF on image dirname:' img_dir, ', frame range is:', num2str(frame_range)]);
    para.k=3;
    para.r=2;
    para.display=1;
    para.ro=0.98;
    para.N=50;
    
    para.startindex=frame_range;
    para.framerange=frame_range;
    para.startnumber=30;
    para.iter=3;
    para.dataname=dataname;
    para.outdir='./results/OMoGMF/';
    tic;
    run_video(strcat([img_dir,filesep]),para);
    runningtime = toc;

end
