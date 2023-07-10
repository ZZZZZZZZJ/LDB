function cfg = config_by_dataname(dataname)      

    %%%%%%%%%dir_for_three_datasets%%%%%%%%%%%%%%%%%%%%%
    dataset_dir_I2R    = '/home/sdb/xxx/codes/CD/low-rank/dataset/I2R/';
    dataset_dir_SABS   = '/home/sdb/xxx/codes/CD/low-rank/dataset/SABS-NoisyNight/SABS/Test/NoCamouflage/';
    dataset_dir_CDNet  = '/home/sdb/xxx/codes/CD/low-rank/dataset/dataset2014/dataset';

    switch(dataname)
        %%I2R dataset
        case 'Campus'
            cfg.dataset = 'I2R';
            cfg.datadir = fullfile(dataset_dir_I2R,dataname);
            cfg.frame_idx = [1,800; 801,1439];
        case 'Fountain'
            cfg.dataset = 'I2R';
            cfg.datadir = fullfile(dataset_dir_I2R,dataname);
            cfg.frame_idx = [1,523];
        case 'WaterSurface'
            cfg.dataset = 'I2R';
            cfg.datadir = fullfile(dataset_dir_I2R,dataname);
            cfg.frame_idx = [1,633];
        %%SABS dataset
        case 'NoCamouflage'
            cfg.dataset = 'SABS';
            cfg.datadir = dataset_dir_SABS;
            cfg.frame_idx = [1,200; 201,400; 401,600];
        %%CDNet dataset
        %% dynamicBackground
        case 'fountain01'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'dynamicBackground';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [600,800];
         case 'fall'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'dynamicBackground';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1400,1600];
         case 'boats'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'dynamicBackground';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1900,2100];
         case 'fountain02'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'dynamicBackground';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [600,800];
         case 'overpass'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'dynamicBackground';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [2300,2500];
          case 'canoe'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'dynamicBackground';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,1000];
        %%badWeather
         case 'snowFall'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'badWeather';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,1000];
         case 'blizzard'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'badWeather';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [900,1100];
         case 'skating'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'badWeather';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,1000];
         case 'wetSnow'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'badWeather';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [500,700];
         %% baseline
        case 'highway'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'baseline';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [500,550];
        case 'office'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'baseline';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [600,650];
        case 'PETS2006'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'baseline';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [300,350];
        case 'pedestrians'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'baseline';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [300,350];
        %% camerajitter
        case 'badminton'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'cameraJitter';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,850];
        case 'boulevard'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'cameraJitter';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,850];
        case 'sidewalk'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'cameraJitter';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,850];
        case 'traffic'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'cameraJitter';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [950,1000];
        %% intermittentObjectMotion
        case 'abandonedBox'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'intermittentObjectMotion';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [2450,2500];
        case 'parking'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'intermittentObjectMotion';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1100,1150];    
        case 'sofa'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'intermittentObjectMotion';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [500,550];  
        case 'streetLight'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'intermittentObjectMotion';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [200,250];
        case 'tramstop'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'intermittentObjectMotion';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1350,1400];    
        case 'winterDriveway'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'intermittentObjectMotion';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1000,1050];  
        %% shadow
        case 'backdoor'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'shadow';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [400,450];         
        case 'bungalows'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'shadow';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [300,350];         
        case 'busStation'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'shadow';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [300,350];         
        case 'copyMachine'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'shadow';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [500,550];       
        case 'cubicle'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'shadow';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1100,1150];         
        case 'peopleInShade'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'shadow';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [250,300];    
        %% thermal  
        case 'corridor'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'thermal';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [500,550];      
        case 'diningRoom'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'thermal';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [700,750];      
        case 'lakeSide'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'thermal';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1000,1050];      
        case 'library'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'thermal';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [600,650];            
        case 'park'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'thermal';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [250,300];  
        %% turbulence
        case 'turbulence0'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'turbulence';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1000,1050];   
        case 'turbulence1'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'turbulence';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1200,1250];  
        case 'turbulence2'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'turbulence';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [500,550];   
        case 'turbulence3'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'turbulence';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,850]; 
        %% lowFramerate
        case 'port_0_17fps'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'lowFramerate';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1000,1050];      
        case 'tramCrossroad_1fps'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'lowFramerate';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [400,450];   
        case 'tunnelExit_0_35fps'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'lowFramerate';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [2000,2050];      
        case 'turnpike_0_5fps'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'lowFramerate';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,850];   
        %% nightVideos
        case 'bridgeEntry'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'nightVideos';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [1000,1050]; 
        case 'busyBoulvard'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'nightVideos';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [750,800]; 
        case 'fluidHighway'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'nightVideos';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [400,450]; 
        case 'streetCornerAtNight'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'nightVideos';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [800,850]; 
        case 'tramStation'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'nightVideos';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [500,550]; 
        case 'winterStreet'
            cfg.dataset = 'CDNet';
            cfg.datacategory = 'nightVideos';
            cfg.datadir = fullfile(dataset_dir_CDNet, cfg.datacategory, dataname, 'input/');
            cfg.frame_idx = [900,950]; 
    end
    
    switch(cfg.dataset)
        case 'I2R'
            cfg.ext = '*.bmp';
        case 'SABS'
            cfg.ext = '*.png';
        case 'CDNet'
            cfg.ext = '*.jpg';
    end

end
