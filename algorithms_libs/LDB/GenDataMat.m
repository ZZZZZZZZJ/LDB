clc;
clear;

video = VideoReader('office.avi');  
nFrames = video.NumberOfFrames;   %�õ�֡��  
H = video.Height;     %�õ��߶�  
W = video.Width;      %�õ����  
Rate = video.FrameRate; 

Cal_FrameN= 300;

mov(1:Cal_FrameN) = struct('cdata',zeros(H,W,3,'uint8'),'colormap',[]); 

for i = 1:Cal_FrameN  
    mov(i).cdata = read(video,i+600);  
    P = mov(i).cdata;   
    Frame=rgb2gray( P);%��ǰ�Ҷ�֡  
    for x = 1:H
        for y = 1:W
            ImData(x,y,i) = Frame(x,y);
        end
    end
end  

save('./CDNet2014/office.mat');