function stats = evaluate_video(dataname, algorithm)
    addpath(genpath('/home/sdb/xxx/codes/CD/low-rank/dataset/MatlabCodeStats2014'));
    videoRootPath = '/home/sdb/xxx/codes/CD/low-rank/dataset/dataset2014/dataset/';
    ResDir = '/home/sdb/xxx/codes/CD/low-rank/mod-library/results';
    
    cfg = config_by_dataname(dataname);
    videoPath = fullfile(videoRootPath, cfg.datacategory, dataname);
    binaryPath = fullfile(ResDir,algorithm,dataname);
    frame_st  = cfg.frame_idx(1);
    frame_end  = cfg.frame_idx(2);

    confusionMatrix = processVideoFolder(videoPath, binaryPath, [frame_st,frame_end]);
    stats = dispconfM(confusionMatrix)
end

function stats = dispconfM(confusionMatrix)
    TP = confusionMatrix(1);
    FP = confusionMatrix(2);
    FN = confusionMatrix(3);
    TN = confusionMatrix(4);
    SE = confusionMatrix(5);

    recall = TP / (TP + FN);
    specficity = TN / (TN + FP);
    FPR = FP / (FP + TN);
    FNR = FN / (TP + FN);
    PBC = 100.0 * (FN + FP) / (TP + FP + FN + TN);
    precision = TP / (TP + FP);
    FMeasure = 2.0 * (recall * precision) / (recall + precision);

    stats = [recall specficity FPR FNR PBC precision FMeasure];
    disp(stats);
end
