function cfg = Config(dataname)
    switch(dataname)
        case 'fall'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/dynamicBackground/fall/';
            cfg.train_range = [1601,1800];
            cfg.test_range  = [1401,1600];
        case 'canoe'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/dynamicBackground/canoe/';
            cfg.train_range = [601,800];
            cfg.test_range  = [801,1000];
        case 'fountain01'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/dynamicBackground/fountain01/';
            cfg.train_range = [401,600];
            cfg.test_range  = [601,800];
        case 'fountain02'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/dynamicBackground/fountain02/';
            cfg.train_range = [401,600];
            cfg.test_range  = [601,800];
        case 'boats'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/dynamicBackground/boats/';
            cfg.train_range = [1701,1900];
            cfg.test_range  = [1901,2100];
        case 'overpass'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/dynamicBackground/overpass/';
            cfg.train_range = [2101,2300];
            cfg.test_range  = [2301,2500];
        case 'blizzard'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/badWeather/blizzard/';
            cfg.train_range = [2201,2400];
            cfg.test_range  = [1101,1300];
        case 'skating'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/badWeather/skating/';
            cfg.train_range = [1101,1300];
            cfg.test_range  = [801,1000];
        case 'snowFall'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/badWeather/snowFall/';
            cfg.train_range = [501,700];
            cfg.test_range  = [801,1000];
        case 'wetSnow'
            cfg.InputDir = '/home/iprai/zzj/CD/dataset/dataset2014/dataset/badWeather/wetSnow/';
            cfg.train_range = [1101,1300];
            cfg.test_range  = [501,700];
        case 'Campus'
            cfg.InputDir = '/home/iprai/zzj/CD/lowrank/Clutter/Campus/train/img/';
            cfg.train_range = [1,199];
            cfg.test_range  = [1,199];
        case 'Fountain'
            cfg.InputDir = '/home/sdb/zhangzhijun/codes/CD/low-rank/Clutter/Fountain/train/img/';
            cfg.train_range = [1,150];
            cfg.test_range  = [1,150];
        case 'WaterSurface'
            cfg.InputDir = '/home/sdb/zhangzhijun/codes/CD/low-rank/mod-library/algorithms_libs/LDB_pre/Clutter/WaterSurface/train/img/';
            cfg.train_range = [1,199];
            cfg.test_range = [1,199];
        case 'NoCamouflage'
            cfg.InputDir = '/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/SABS-NoisyNight/SABS/Train/NoForegroundNightNoisy/';
            cfg.train_range = [1,199];
            cfg.test_range = [1,199];
    end
end
