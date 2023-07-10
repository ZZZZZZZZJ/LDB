function [D] = ReadCNNMatFromDir(Oridir,dataname)
    fpath         =   fullfile(Oridir, dataname, 'res_test.mat');
    load(fpath);
    D = C_out;
end

