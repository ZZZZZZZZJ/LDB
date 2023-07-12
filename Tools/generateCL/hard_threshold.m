function O = hard_threshold(S)
  disp('Applying hard threshold...');
  
  % beta = 0.5*(3*std(S(:))/20)^2; % min beta, lower bound: suppose SNR <= 20
  beta = 0.5*(std(S(:)))^2; % begin beta, start from a big value
  
  % direct hard thresholding if no smoothness
  O = double(0.5*S.^2 > beta);
end