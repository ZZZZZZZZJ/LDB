datanamelist = str2mat('highway','office','PETS2006','pedestrians');
algorithmlist = str2mat('RPCA','OMoGMF','DECOLOR');

log_file = ['results_log/',datestr(now),'.txt'];
filelog = fopen(log_file,'w');

for algorithmidx = 1:size(algorithmlist,1)
    algorithm = strtrim(algorithmlist(algorithmidx,:));
    for datanameidx = 1:size(datanamelist,1)
        dataname = strtrim(datanamelist(datanameidx,:));
        stats = evaluate_video(dataname,algorithm);
        fprintf(filelog,['algorithm:',algorithm,', dataname:', dataname, ', frame_range:', num2str(frame_range), ', results:', num2str(stats), '\n']);
    end
end