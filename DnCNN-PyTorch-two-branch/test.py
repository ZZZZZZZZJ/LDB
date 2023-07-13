import cv2
import os
import argparse
import glob
import numpy as np
import torch
import torch.nn as nn
import scipy.io as scio
import matplotlib.pyplot as plt
from torch.autograd import Variable
from models import DnCNN
from utils import *

os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

parser = argparse.ArgumentParser(description="DnCNN_Test")
parser.add_argument("--num_of_layers", type=int, default=17, help="Number of total layers")
parser.add_argument("--logdir", type=str, default="logs", help='path of log files')
parser.add_argument("--test_data", type=str, default='Set12', help='test on Set12 or Set68')
parser.add_argument("--test_noiseL", type=float, default=25, help='noise level used on test set')
parser.add_argument("--dataname", type=str, default="canoe", help="dataname")
parser.add_argument("--mode", type=str, default='test', help='train or test images on dataname')
opt = parser.parse_args()

def normalize(data):
    return data/255.

def convertColorChannel(img):
    Img_R = np.expand_dims(img[:, :, 0].copy(), 0)
    Img_B = np.expand_dims(img[:, :, 1].copy(), 0)
    Img_G = np.expand_dims(img[:, :, 2].copy(), 0)
    Img = np.concatenate((Img_R, Img_B, Img_G))
    return Img

def config_by_dataname(dataname,mode):
    categoryDic = {'canoe':'dynamicBackground',
                  'fall':'dynamicBackground',
                  'boats':'dynamicBackground',
                  'fountain01':'dynamicBackground',
                  'fountain02':'dynamicBackground',
                  'overpass':'dynamicBackground',
                  'blizzard':'badWeather',
                  'skating':'badWeather',
                  'snowFall':'badWeather',
                  'wetSnow':'badWeather',
}
    framestDic_train  = {'canoe':600,
                        'fall':1600,
                        'boats':1700,
                        'fountain01':400,
                        'fountain02':400,
                        'overpass':2100,
                        'blizzard':2200,
                        'skating':1100,
                        'snowFall':500,
                        'wetSnow':1100,
}  
    framestDic_test  = {'canoe':800,
                       'fall':1400,
                       'boats':1900,
                       'fountain01':600,
                       'fountain02':600,
                       'overpass':2300,
                       'blizzard':1100,
                       'skating':800,
                       'snowFall':800,
                       'wetSnow':500,
} 
    input_dir = os.path.join('/home/iprai/zzj/CD/dataset/dataset2014/dataset/',categoryDic.get(dataname),dataname,'input')
    if mode == 'train':
        frame_st  = framestDic_train.get(dataname)
    else:
        frame_st  = framestDic_test.get(dataname)
    frame_ed  = frame_st + 200
    return input_dir,frame_st,frame_ed

def main():
    opt.logdir = os.path.join('test',opt.dataname)
    #[input_dir,frame_st,frame_ed] = config_by_dataname(opt.dataname,opt.mode)
    input_dir = '/home/sdb/zhangzhijun/codes/CD/low-rank/dataset/I2R/Fountain'
    frame_st = -1
    frame_ed = 522
    # Build model
    print('Loading model ...\n')
    net = DnCNN(channels=3, num_of_layers=opt.num_of_layers)
    device_ids = [0]
    model = nn.DataParallel(net, device_ids=device_ids).cuda()
    #model.load_state_dict(torch.load(os.path.join(opt.logdir, 'net.pth')))
    state_dict = torch.load(os.path.join(opt.logdir, 'net.pth'))
    from collections import OrderedDict
    new_state_dict = OrderedDict()
    for k, v in state_dict.items():
        name = k[7:]  # remove `module.`
        new_state_dict[name] = v
    # load params
    model.module.load_state_dict(new_state_dict)

    model.eval()
    # load data info
    print('Loading data info ...\n')
    files_source = glob.glob(os.path.join(input_dir, '*.bmp'))
    files_source.sort()
    # process data
    psnr_test = 0
    Img = cv2.imread(files_source[0])
    [m,n,t] = Img.shape
    out_clu = np.empty(shape=[m, n,3,  frame_ed-frame_st])
    
for i in range(frame_st,frame_ed):
    #for f in files_source:
        # image
        img1 = cv2.imread(files_source[i])
        print(files_source[i])
        img2 = cv2.imread(files_source[i+1])
        Img1 = convertColorChannel(img1)
        Img1 = np.float32(normalize(Img1))
        Img2 = convertColorChannel(img2)
        Img2 = np.float32(normalize(Img2))
        ImgT = np.concatenate((Img1,Img2),0)
        Img1 = np.expand_dims(Img1, 0)
        ImgT = np.expand_dims(ImgT, 0)
        Idata1 = torch.Tensor(Img1)
        Idata2 = torch.Tensor(ImgT)

        Idata1, Idata2 = Variable(Idata1.cuda()), Variable(Idata2.cuda())
        with torch.no_grad(): # this can save much memory
            Out = torch.clamp(model(Idata1,Idata2), -1., 1.)

        result_R = np.expand_dims(Out[0,0,:,:].data.cpu().numpy(), 2)
        result_G = np.expand_dims(Out[0,1,:,:].data.cpu().numpy(), 2)
        result_B = np.expand_dims(Out[0,2, :, :].data.cpu().numpy(), 2)
        result = np.concatenate((result_R, result_G, result_B),2)
        bg = img1/255. - result
        print(bg.shape)
        cv2.imshow('bg',bg)
        cv2.waitKey(1)
        out_name = os.path.join('test_img',opt.dataname,'res_' + str(i).zfill(6) + '.jpg')
        cv2.imwrite(out_name,bg)
        out_clu[:,:,:,i-frame_st] = result

    save_fn = os.path.join('test',opt.dataname,'res_' + opt.mode + '.mat')
    scio.savemat(save_fn, {'C_out': out_clu})

if __name__ == "__main__":
    main()
