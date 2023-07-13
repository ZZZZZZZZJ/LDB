import torch
import torch.nn as nn

class DnCNN(nn.Module):
    def __init__(self, channels, num_of_layers=17):
        super(DnCNN, self).__init__()
        kernel_size = 3
        padding = 1
        features = 64
        layers = []
        layers.append(nn.Conv2d(in_channels=channels, out_channels=features, kernel_size=kernel_size, padding=padding, bias=False))
        layers.append(nn.ReLU(inplace=True))
        for _ in range(num_of_layers-2):
            layers.append(nn.Conv2d(in_channels=features, out_channels=features, kernel_size=kernel_size, padding=padding, bias=False))
            layers.append(nn.BatchNorm2d(features))
            layers.append(nn.ReLU(inplace=True))
        #layers.append(nn.Conv2d(in_channels=features, out_channels=channels, kernel_size=kernel_size, padding=padding, bias=False))
        self.dncnn = nn.Sequential(*layers)

        layers_2 = []
        layers_2.append(nn.Conv2d(in_channels=2*channels, out_channels=features, kernel_size=kernel_size, padding=padding,
                                bias=False))
        layers_2.append(nn.ReLU(inplace=True))
        for _ in range(num_of_layers - 2):
            layers_2.append(nn.Conv2d(in_channels=features, out_channels=features, kernel_size=kernel_size, padding=padding,bias=False))
            layers_2.append(nn.BatchNorm2d(features))
            layers_2.append(nn.ReLU(inplace=True))
        #layers_2.append(nn.Conv2d(in_channels=features, out_channels=channels, kernel_size=kernel_size, padding=padding,
         #                       bias=False))
        self.dncnn_2 = nn.Sequential(*layers_2)

        self.conv_l = nn.Conv2d(in_channels=2*features, out_channels=channels, kernel_size=kernel_size, padding=padding,bias=False)


    def forward(self, input1, input2):
        out1 = self.dncnn(input1)
        out2 = self.dncnn_2(input2)
        out  = torch.cat((out1, out2), 1)
        out  = self.conv_l(out)
        return out
