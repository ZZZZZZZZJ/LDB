function [O B_hat F_hat E_hat M_hat iter ] = tv_alm_rpca3( D_source, lambda, tol, maxIter )


addpath PROPACK;

[height width frame] = size(D_source);

%��ʼ������
if nargin < 2
    lambda = 1 / sqrt(height*width);
%     lambda1 = 0.2*lambda
%     lambda2 = 2*lambda;
%     lambda3 = 1*lambda;    
% good result
    lambda1 = 0.4*lambda
    lambda2 = 2*lambda;
    lambda3 = 1*lambda;
else
    lambda_ = 1 / sqrt(height*width);
    lambda1 = lambda_*lambda(1);
    lambda2 = lambda_*lambda(2);
    lambda3 = lambda_*lambda(3);
end

if nargin < 3
    tol = 1e-7;
elseif tol == -1
    tol = 1e-7;
end

if nargin < 4
    maxIter = 20;
elseif maxIter == -1
    maxIter = 20;
end

m = height * width;
n = frame;
O = [];

for i = 1 : frame
    im = reshape(D_source(:,:,i), m, 1);
    O = [O im];
end

%��ʼ��language����
X = O;
norm_two = lansvd(X, 1, 'L');
norm_inf = norm( X(:), inf) / lambda1;
dual_norm = max(norm_two, norm_inf);
X = X / dual_norm;

Y = zeros(m,frame);


%��ʼ��Ҫ���ı���
B_hat = zeros( m, frame);
F_hat = zeros( m, frame);
E_hat = zeros( m, frame);
M_hat = zeros( m, frame);

%��ʼ��rpca��Ҫ�õ��Ĳ���
mu = 1.25/norm_two; % this one can be tuned    �൱��rho1
mu_bar = mu * 1e7;
rho = 1.5;          % this one can be tuned
d_norm = norm(O, 'fro');

iter = 0;
total_svd = 0;
converged = false;
stopCriterion = 1;
sv = 10;
while ~converged       
    iter = iter + 1
        
    % ==================
    %     M-subprolem
    % ==================
    temp_TS = ((mu*O+X-mu*B_hat) + (mu*E_hat+mu*F_hat-Y))/(2*mu);
    M_hat = max(temp_TS - lambda1/(2*mu), 0);
    M_hat = M_hat+min(temp_TS + lambda1/(2*mu), 0);
    
   
    % ==================
    %     B-subprolem
    % ==================
    if choosvd(n, sv) == 1
        [U S V] = lansvd(O - M_hat + (1/mu)*X, sv, 'L');
    else
        [U S V] = svd(O - M_hat + (1/mu)*X, 'econ');
    end
    diagS = diag(S);
    svp = length(find(diagS > 1/mu));
    if svp < sv
        sv = min(svp + 1, n);
    else
        sv = min(svp + round(0.05*n), n);
    end
    
    B_hat = U(:, 1:svp) * diag(diagS(1:svp) - 1/mu) * V(:, 1:svp)'; 

    % ==================
    %     E-subprolem
    % ==================
    temp_T = M_hat - F_hat + (1/mu)*Y;
    E_hat = max(temp_T - lambda2/mu, 0);
    E_hat = E_hat+min(temp_T + lambda2/mu, 0);
    

    % ==================
    %     F-subprolem
    % ==================
    g_source = M_hat + Y/mu -E_hat;
    
    if max(g_source) ~=0      
        g = [];
        for i = 1 : frame
            im = reshape(g_source(:,i), height, width);
            g = cat(3, g, im);
        end
        
        opts.beta    = [1 1 1];
        opts.print   = false;
        opts.method  = 'l2';
        %opts.rho_o = 2;
        %opts.max_itr = 10;
        
        % Setup mu
        mu_tv           = mu / lambda3;
        
        % Main routine
        out = deconvtv(g, 1, mu_tv, opts);
        
        F_hat = [];
        
       for i = 1 : frame
            im = reshape(out.f(:,:,i), m, 1);
            F_hat = [F_hat im];
        end
        
    end
   
   
    % ==================
    %     XY-subprolem
    % ==================
    
    X = X + mu*(O - B_hat - M_hat);
    Y = Y + mu*(M_hat - E_hat - F_hat);
    mu = min(mu*rho, mu_bar);
   
    
     total_svd = total_svd + 1;
        
    %% stop Criterion    
%     stopCriterion = norm(Z, 'fro') / d_norm;
%     if stopCriterion < tol
%         converged = true;
%     end    
    
    if mod( total_svd, 10) == 0
        disp(['#svd ' num2str(total_svd) ' r(A) ' num2str(rank(B_hat))...
            ' |E|_0 ' num2str(length(find(abs(M_hat)>0)))...
            ' stopCriterion ' num2str(stopCriterion)]);
    end    
    
    if ~converged && iter >= maxIter
        disp('Maximum iterations reached') ;
        converged = 1 ;       
    end
end
