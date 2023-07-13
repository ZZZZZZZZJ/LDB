import os
import os.path
import numpy as np
import random
import h5py
import torch
import cv2
import glob
import torch.utils.data as udata
import scipy.io as scio
from utils import data_augmentation

def normalize(data):
    return data/255.

def Im2Patch(img, win, stride=1):
    k = 0
    endc = img.shape[0]
    endw = img.shape[1]
    endh = img.shape[2]
    patch = img[:, 0:endw-win+0+1:stride, 0:endh-win+0+1:stride]
    TotalPatNum = patch.shape[1] * patch.shape[2]
    Y = np.zeros([endc, win*win,TotalPatNum], np.float32)
    for i in range(win):
        for j in range(win):
            patch = img[:,i:endw-win+i+1:stride,j:endh-win+j+1:stride]
            Y[:,k,:] = np.array(patch[:]).reshape(endc, TotalPatNum)
            k = k + 1
    return Y.reshape([endc, win, win, TotalPatNum])

def Im2PatchT(img, img2,  win, stride=1):
    k = 0
    endc = img.shape[0]
    endw = img.shape[1]
    endh = img.shape[2]
    patch = img[:, 0:endw-win+0+1:stride, 0:endh-win+0+1:stride]
    TotalPatNum = patch.shape[1] * patch.shape[2]
    Y = np.zeros([endc, win*win,TotalPatNum], np.float32)
    Z = np.zeros([endc, win*win,TotalPatNum], np.float32)
#    T = np.zeros([endc, win*win,TotalPatNum], np.float32)
    for i in range(win):
        for j in range(win):
            patch = img[:,i:endw-win+i+1:stride,j:endh-win+j+1:stride]
            Y[:,k,:] = np.array(patch[:]).reshape(endc, TotalPatNum)
            k = k + 1
    k = 0
    for i in range(win):
        for j in range(win):
            patch = img2[:,i:endw-win+i+1:stride,j:endh-win+j+1:stride]
            Z[:,k,:] = np.array(patch[:]).reshape(endc, TotalPatNum)
            k = k + 1
    return np.concatenate((Y.reshape([endc, win, win, TotalPatNum]),Z.reshape([endc, win, win, TotalPatNum])))

def convertColorChannel(img):
    Img_R = np.expand_dims(img[:, :, 0].copy(), 0)
    Img_B = np.expand_dims(img[:, :, 1].copy(), 0)
    Img_G = np.expand_dims(img[:, :, 2].copy(), 0)
    Img = np.concatenate((Img_R, Img_B, Img_G))
    return Img

def prepare_data(data_path, patch_size, stride, aug_times=1):
    # train
    print('process training data')
    #scales = [1, 0.9, 0.8, 0.7]
    scales = [1]
    filesImg = glob.glob(os.path.join(data_path, 'img', '*.bmp'))
    #filesCl  = glob.glob(os.path.join(data_path, 'AVG', 'C', '*.jpg'))
    Cldata   = scio.loadmat(os.path.join(data_path, 'AVG', 'C', 'data.mat'))
    C        = Cldata['C']
    filesImg.sort()
    #filesCl.sort()
    h5fImg = h5py.File('trainImg.h5', 'w')
    h5fLabel = h5py.File('trainLabel.h5', 'w')
    train_num = 0
    for i in range(len(filesImg)-1):
        img = cv2.imread(filesImg[i])
        #clu = cv2.imread(filesCl[i])
        clu = C[:,:,i]
        img2 = cv2.imread(filesImg[i+1])
        #img3 = cv2.imread(filesImg[i+2])
        #label = img-bg
        h, w, c = img.shape
        for k in range(len(scales)):
           # Img = cv2.resize(img, (int(h*scales[k]), int(w*scales[k])), interpolation=cv2.INTER_CUBIC)
            Img = convertColorChannel(img)
            Img = np.float32(normalize(Img))
           # label  = cv2.resize(label, (int(h*scales[k]), int(w*scales[k])), interpolation=cv2.INTER_CUBIC)
            Clu = np.expand_dims(clu.copy(), 0)
            Clu = np.float32(Clu)
           # Img = cv2.resize(img, (int(h*scales[k]), int(w*scales[k])), interpolation=cv2.INTER_CUBIC)
            Img2 = convertColorChannel(img2)
            Img2 = np.float32(normalize(Img2))
            #Img3 = convertColorChannel(img3)
            #Img3 = np.float32(normalize(Img3))
           # label  = cv2.resize(label, (int(h*scales[k]), int(w*scales[k])), interpolation=cv2.INTER_CUBIC)

            label = Clu
            ImgPatches = Im2PatchT(Img,Img2, win=patch_size, stride=stride)
            print(np.min(ImgPatches))
            LabelPatches = Im2Patch(label, win=patch_size, stride=stride)
            print(np.min(LabelPatches))
            print("file: %s scale %.1f # samples: %d" % (filesImg[i], scales[k], ImgPatches.shape[3]*aug_times))
            for n in range(ImgPatches.shape[3]):
                dataImg = ImgPatches[:,:,:,n].copy()
                dataLabel = LabelPatches[:,:,:,n].copy()
                h5fImg.create_dataset(str(train_num), data=dataImg)
                h5fLabel.create_dataset(str(train_num), data=dataLabel)
                train_num += 1
                for m in range(aug_times-1):
                    data_aug = data_augmentation(data, np.random.randint(1,8))
                    h5f.create_dataset(str(train_num)+"_aug_%d" % (m+1), data=data_aug)
                    train_num += 1
    h5fImg.close()
    h5fLabel.close()
    # val
   # print('\nprocess validation data')
   # files.clear()
   # files = glob.glob(os.path.join(data_path, 'Set12', '*.png'))
   # files.sort()
   # h5f = h5py.File('val.h5', 'w')
   # val_num = 0
   # for i in range(len(files)):
   #     print("file: %s" % files[i])
   #     img = cv2.imread(files[i])
   #     img = np.expand_dims(img[:,:,0], 0)
   #     img = np.float32(normalize(img))
   #     h5f.create_dataset(str(val_num), data=img)
   #     val_num += 1
   # h5f.close()
   # print('training set, # samples %d\n' % train_num)
   # print('val set, # samples %d\n' % val_num)

class Dataset(udata.Dataset):
    def __init__(self, train=True):
        super(Dataset, self).__init__()
        self.train = train
        if self.train:
            h5f = h5py.File('trainImg.h5', 'r')
            h5fLabel = h5py.File('trainLabel.h5', 'r')
        else:
            h5f = h5py.File('val.h5', 'r')
        self.keys = list(h5f.keys())
        random.shuffle(self.keys)
        h5f.close()
    def __len__(self):
        return len(self.keys)
    def __getitem__(self, index):
        if self.train:
            h5fImg = h5py.File('trainImg.h5', 'r')
            h5fLabel = h5py.File('trainLabel.h5', 'r')
        else:
            h5f = h5py.File('val.h5', 'r')
        key = self.keys[index]
        data = np.array(h5fImg[key])
        img1 = data[:3,:,:]
  #      img2 = data[2,:,:]
        label = np.array(h5fLabel[key])
        h5fImg.close()
        h5fLabel.close()
        return torch.Tensor(img1),torch.Tensor(data),torch.Tensor(label)
