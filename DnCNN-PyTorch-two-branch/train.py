import os
import argparse
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
import torchvision.utils as utils
import matplotlib.pyplot as plt
from torch.autograd import Variable
from torch.utils.data import DataLoader
#from tensorboardX import SummaryWriter
from models import DnCNN
from dataset import prepare_data, Dataset
from utils import *

os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

parser = argparse.ArgumentParser(description="DnCNN")
parser.add_argument("--preprocess", type=bool, default=True, help='run prepare_data or not')
parser.add_argument("--batchSize", type=int, default=64, help="Training batch size")
parser.add_argument("--num_of_layers", type=int, default=17, help="Number of total layers")
parser.add_argument("--epochs", type=int, default=50, help="Number of training epochs")
parser.add_argument("--milestone", type=int, default=30, help="When to decay learning rate; should be less than epochs")
parser.add_argument("--lr", type=float, default=1e-3, help="Initial learning rate")
parser.add_argument("--outf", type=str, default="logs", help='path of log files')
parser.add_argument("--mode", type=str, default="B", help='with known noise level (S) or blind training (B)')
parser.add_argument("--noiseL", type=float, default=25, help='noise level; ignored when mode=B')
parser.add_argument("--val_noiseL", type=float, default=25, help='noise level used on validation set')
parser.add_argument("--dataname",type=str, default='canoe',help='dataname')
opt = parser.parse_args()

def main():
    # Load dataset
    print('Loading dataset ...\n')
    dataset_train = Dataset(train=True)
#    dataset_val = Dataset(train=False)
    loader_train = DataLoader(dataset=dataset_train, num_workers=4, batch_size=opt.batchSize, shuffle=True)
    print("# of training samples: %d\n" % int(len(dataset_train)))
    # Build model
    net = DnCNN(channels=3, num_of_layers=opt.num_of_layers)
    net.apply(weights_init_kaiming)
    criterion = nn.MSELoss(size_average=False)
    # Move to GPU
    device_ids = [0]
    model = nn.DataParallel(net, device_ids=device_ids).cuda()
    criterion.cuda()
    # Optimizer
    optimizer = optim.Adam(model.parameters(), lr=opt.lr)
    # training
 #   writer = SummaryWriter(opt.outf)
    step = 0
    noiseL_B=[0,55] # ingnored when opt.mode=='S'
    for epoch in range(opt.epochs):
        if epoch < opt.milestone:
            current_lr = opt.lr
        else:
            current_lr = opt.lr / 10.
        # set learning rate
        for param_group in optimizer.param_groups:
            param_group["lr"] = current_lr
        print('learning rate %f' % current_lr)
        # train
        for i, (data1,data2, label) in enumerate(loader_train, 0):
            # training step
            model.train()	
            model.zero_grad()
            optimizer.zero_grad()
            img_train1 = data1
            img_train2 = data2

            img_train1 = Variable(img_train1.cuda())
            img_train2 = Variable(img_train2.cuda())
            label_train = Variable(label.cuda())
            # noise = Variable(noise.cuda())
            out_train = model(img_train1,img_train2)
            loss = criterion(out_train, label_train) / (img_train1.size()[0]*2)
            loss.backward()
            optimizer.step()
            # results
            model.eval()
            out_train = torch.clamp(img_train1-model(img_train1,img_train2), 0., 1.)
            #psnr_train = batch_PSNR(out_train, img_train1, 1.)
            print("[epoch %d][%d/%d] loss: %.4f" %
                (epoch+1, i+1, len(loader_train), loss.item()))
            step += 1
        ## the end of each epoch
        model.eval()

        out_train = torch.clamp(img_train1-model(img_train1,img_train2), 0., 1.)
        Img = utils.make_grid(img_train1.data, nrow=8, normalize=True, scale_each=True)
        Imgn = utils.make_grid(img_train1.data, nrow=8, normalize=True, scale_each=True)
        Irecon = utils.make_grid(out_train.data, nrow=8, normalize=True, scale_each=True)

        # save model
        torch.save(model.state_dict(), os.path.join('test',opt.dataname, 'net.pth'))

if __name__ == "__main__":
    if opt.preprocess:
        #if opt.mode == 'S':
        #    prepare_data(data_path='data', patch_size=40, stride=10, aug_times=1)
        #if opt.mode == 'B':
        prepare_data(data_path=os.path.join('/home/sdb/zhangzhijun/codes/CD/low-rank/Clutter',opt.dataname,'train'), patch_size=40, stride=20, aug_times=1)
    main()
