clear 
close all

addpath('internal');
addpath(genpath('gco-v3.0'));

% problem parameters
m = 100; 
n = 50;
r = 3; % rank of B0
d = 0; % stopping time

W = 40; % object width
V = 1; % moving speed
SNR = 10; 

%% generate problem
%% contigous outliers
B0 = randn(m,r)*randn(r,n);
S0 = zeros(size(B0));
D = B0;
% add occlusion
% uniform distributed within the same range of B
Obj = rand(W,1)-0.5;
scale = max(B0(:))-min(B0(:));
Obj = Obj*scale;

D(1:W,1:d) = Obj*ones(1,d);
S0(1:W,1:d) = true;
for id = d+1:n
    if V*(id-d) <= m
        ObjArea = round(min(V*(id-d),m):min(V*(id-d)+W-1,m));
        D(ObjArea,id) = Obj(1:length(ObjArea));
        S0(ObjArea,id) = true;
    end
end
Etrue = D - B0;
% add noise
sigma = std(B0(:))/SNR;
D = D + sigma*randn(size(D));

%% PCP
lam = 1/sqrt(max(m,n));
tol = 1e-5;
[B,E] = PCP(D,lam,tol);
errB1 = norm(B0(:)-B(:),2)/norm(B0(:),2);

fmax = 0;
Vth = linspace(min(abs(E(:))),max(abs(E(:))),100);
for idx = 1:length(Vth)
    th = Vth(idx);
    Stmp = abs(E) > th;
    rec = sum(Stmp(:)&S0(:))/(sum(S0(:))); 
    pre = (sum(Stmp(:)&S0(:))+1)/(sum(Stmp(:))+1);
    ftmp = 2*rec*pre/(pre+rec);
    if ftmp > fmax
        fmax = ftmp;
        S = Stmp;
    end
end

figure;
subplot(2,2,1),imagesc(D),colormap gray; axis off; title('D');
subplot(2,2,2),imagesc(B0),colormap gray; axis off; title('B_0');
subplot(2,2,3),imagesc(S),colormap gray; axis off; title('D (PCP)');
subplot(2,2,4),imagesc(B),colormap gray; axis off; title('B (PCP)');



%% DECOLOR

[B,S] = DECOLOR(D);
errB2 = norm(B0(:)-B(:),2)/norm(B0(:),2);

figure;
subplot(2,2,1),imagesc(D),colormap gray; axis off; title('D');
subplot(2,2,2),imagesc(B0),colormap gray; axis off; title('B_0');
subplot(2,2,3),imagesc(S),colormap gray; axis off; title('S (DECOLOR)');
subplot(2,2,4),imagesc(B),colormap gray; axis off; title('B (DECOLOR)');




