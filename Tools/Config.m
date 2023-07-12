function cfg = Config(dataname)
    switch(dataname)
        case 'fall'
            cfg.InputDir = 'xxx/dataset2014/dataset/dynamicBackground/fall/';
            cfg.train_range = [1601,1800];
            cfg.test_range  = [1401,1600];
        case 'canoe'
            cfg.InputDir = 'xxx/dataset2014/dataset/dynamicBackground/canoe/';
            cfg.train_range = [601,800];
            cfg.test_range  = [801,1000];
        case 'fountain01'
            cfg.InputDir = 'xxx/dataset2014/dataset/dynamicBackground/fountain01/';
            cfg.train_range = [401,600];
            cfg.test_range  = [601,800];
        case 'fountain02'
            cfg.InputDir = 'xxx/dataset2014/dataset/dynamicBackground/fountain02/';
            cfg.train_range = [401,600];
            cfg.test_range  = [601,800];
        case 'boats'
            cfg.InputDir = 'xxx/dataset2014/dataset/dynamicBackground/boats/';
            cfg.train_range = [1701,1900];
            cfg.test_range  = [1901,2100];
        case 'overpass'
            cfg.InputDir = 'xxx/dataset2014/dataset/dynamicBackground/overpass/';
            cfg.train_range = [2101,2300];
            cfg.test_range  = [2301,2500];
        case 'blizzard'
            cfg.InputDir = 'xxx/dataset2014/dataset/badWeather/blizzard/';
            cfg.train_range = [2201,2400];
            cfg.test_range  = [1101,1300];
        case 'skating'
            cfg.InputDir = 'xxx/dataset2014/dataset/badWeather/skating/';
            cfg.train_range = [1101,1300];
            cfg.test_range  = [801,1000];
        case 'snowFall'
            cfg.InputDir = 'xxx/dataset2014/dataset/badWeather/snowFall/';
            cfg.train_range = [501,700];
            cfg.test_range  = [801,1000];
        case 'wetSnow'
            cfg.InputDir = 'xxx/dataset2014/dataset/badWeather/wetSnow/';
            cfg.train_range = [1101,1300];
            cfg.test_range  = [501,700];
        case 'Campus'
            cfg.InputDir = 'xxx/Campus/train/img/';
            cfg.train_range = [1,199];
            cfg.test_range  = [1,199];
        case 'Fountain'
            cfg.InputDir = 'xxx/Fountain/train/img/';
            cfg.train_range = [1,150];
            cfg.test_range  = [1,150];
        case 'WaterSurface'
            cfg.InputDir = 'xxx/WaterSurface/train/img/';
            cfg.train_range = [1,199];
            cfg.test_range = [1,199];
        case 'NoCamouflage'
            cfg.InputDir = 'xxx/SABS-NoisyNight/SABS/Train/NoForegroundNightNoisy/';
            cfg.train_range = [1,199];
            cfg.test_range = [1,199];
    end
end
