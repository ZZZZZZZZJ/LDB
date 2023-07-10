function runningtime = GOSUS_algorithm(dataname, img_dir,frame_range)
    disp(['perform algorithm OMoGMF on image dirname:' img_dir, ', frame range is:', num2str(frame_range)]);
    cfg = config_by_dataname(dataname);
    
    regularizer = 0.1;
    param.superpixel.slicParam = [10, regularizer; 20, regularizer;  40,regularizer ; 80,regularizer; ];

    %  param.superpixel.slicParam = [5,regularizer;  10, regularizer; 20, regularizer;  40,regularizer ; ];

    param.maxIter =100;
    param.tol = 1e-4;

    param.input.dataPath = img_dir;
    param.output.resultPath = strcat('./results/GOSUS/',dataname,'/');
    
    param.input.dirString = cfg.ext;

    param.input.dataset = dataname;

    param.saveResult = 1;
    param.showResult = 0;
    
    param.output.threshold  = 0.1;
    param.lambda =10;   

    param.rank = 5; % subspace dimension
    param.eta = 0.01;  % stepsize for subspace updating
%     param.sampleSize = 200; % number of sample frames to learn the background
%     param.trainSize = 5000; % train with all available images
    param.startIndex = frame_range(1);
    param.endIndex = frame_range(2);
    param.randomStart = true;
  
    param;
    tic;
    gosus(param); 
    runningtime = toc;
end