function func = obtain_algorithm_function(algorithm)

    switch(algorithm)
        %% RPCA
        case 'RPCA'
            addpath(genpath('algorithms_libs/RPCA/'));
            func = 'RPCA_algorithm';
        case 'LSD'
            addpath(genpath('algorithms_libs/LSD'));
            func = 'LSD_algorithm';
        case 'DECOLOR'
            addpath(genpath('algorithms_libs/decolor'));
            func = 'DECOLOR_algorithm';
        case 'TVRPCA'
            addpath(genpath('algorithms_libs/TVRPCA/yangliang.github.com/code/TVRPCA'));
            func = 'TVRPCA_algorithm';
        case 'GOSUS'
            addpath(genpath('algorithms_libs/gosus-release/gosus-release'));
            vl_setup;
            func = 'GOSUS_algorithm';
        case 'OMoGMF'
            addpath(genpath('algorithms_libs/OMoGMF_code'));
            func = 'OMoGMF_algorithm';
        case 'LDB'
            addpath(genpath('algorithms_libs/LDB'));
            func = 'LDB_algorithm';
    end

end
