function [D_hat B_hat F_hat E_hat M_hat] = rpca_tv(D, idx, lambda)
warning off all;

%[data height width frame] = read_movie_data_noreshape_selected(dataset, idx);
%D = im2double(data);
%D = im2double(data(1:2:height,1:2:width,:));
%data = [];

[height width frame] = size(D);

addpath inexact_alm_rpca;
addpath inexact_alm_rpca/PROPACK;

%lambda = [k/sqrt(height*width), 1, 1];
[D_hat B_hat F_hat E_hat M_hat iter] = tv_alm_rpca3(D, lambda);
%save([dataset,'_',num2str(start_frame),'_', num2str(end_frame),'_', num2str(in) ,'_result.mat']);
%save fountain_result.mats
% inteval = 6;
% 
% result_plot_detail(D_hat, B_hat, F_hat, E_hat, M_hat , height, width, inteval);

%calc_roc;