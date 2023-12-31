# LDB
The official codes for learning dynamic background for weakly supervised moving object detection

LDB -- Version released on Sep.12 2021.

1. This package of codes has been tested on Ubuntu 16.04 LT, with Matlab version R2017a
2. gco-v3.0 is needed and has been included in the package.
3. LDB detects moving objects, typically in dynamic scenes.
   RPCA, LSD, DECOLOR, TVRPCA, GOSUS, OMoGMF is for comparison
   test_videos uses various algorithms and dataset to detect moving objects.
   config_by_dataname demonstrates the directory of sequence, and testing frame regions.
   obtain_algorithm_function indicates the function of different algorithms.

Thanks.

# Dataset
We provide three datasets:
[CDnet 2014 dataset](https://drive.google.com/file/d/1-taN_aeVevicLxpv24sBRDDp_F5xkbBN/view?usp=drive_link),
[I2R dataset](https://drive.google.com/file/d/1idyPSLvePhCatJUOG-Bhvob7h2jjqU_4/view?usp=drive_link),
[SABS dataset](https://drive.google.com/file/d/1NOvu4p5-7rWOTvWRzjHwWhFlAvHRyxhq/view?usp=drive_link)

# Get Started

1. Generate Clutter Images using Scene Background Images;
```
Tools/make_annotations.m
```
2. Train DnCNN Network to Obtain Scene-Specific Clutter Prediction Networks;
   
    (1) Modify the path in line 103 of the DnCNN-PyTorch-two-branch/train.py

    (2) Modify the path in lines 66-68 of the DnCNN-PyTorch-two-branch/dataset.py
```
DnCNN-PyTorch-two-branch/train.py
```
3. Generate Clutter Images of Testing Images based on the Training Network;
```
DnCNN-PyTorch-two-branch/test.py
```
4. Use LDB Method Towards Optimization with Trained Clutter Images;
```
Algorithms_libs/LDB/test_LDB.m
```
    Or
```
test_videos.m
```



# Citation
```
@article{zhang2022learning,
  title={Learning dynamic background for weakly supervised moving object detection},
  author={Zhang, Zhijun and Chang, Yi and Zhong, Sheng and Yan, Luxin and Zou, Xu},
  journal={Image and Vision Computing},
  volume={121},
  pages={104425},
  year={2022},
  publisher={Elsevier}
}
```
