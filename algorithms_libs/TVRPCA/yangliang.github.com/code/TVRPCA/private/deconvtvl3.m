function out = deconvtvl3(F,H,mu,opts)
% out = ADM2TVL2(H,F,mu,opts)
%
% Alternating Directions Method (ADM) applied to TV/L2.
%
% Suppose the data accuquisition model is given by: F = K*Xbar + Noise,
% where Xbar is an original image, K is a convolution matrix, Noise is
% additive noise, and F is a blurry and noisy observation. To recover
% Xbar from F and K, we solve TV/L2 (ROF) model
%
% ***     min_X \sum_i ||Di*X|| + mu/2*||K*X - F||^2      ***
%
% Inputs:
%         H  ---  convolution kernel representing K
%         F  ---  blurry and noisy observation
%         mu ---  model prameter (must be provided by user)
%         opts --- a structure containing algorithm parameters {default}
%                 * opst.beta    : a positive constant {10}
%                 * opst.gamma   : a constant in (0,1.618] {1.618}
%                 * opst.maxitr  : maximum iteration number {500}
%                 * opst.relchg  : a small positive parameter which controls
%                                  stopping rule of the code. When the
%                                  relative change of X is less than
%                                  opts.relchg, then the code stops. {1.e-3}
%                 * opts.print   : print inter results or not {1}
%
% Outputs:
%         out --- a structure contains the following fields
%                * out.snr   : SNR values at each iteration
%                * out.f     : function valuse at each itertion
%                * out.relchg: the history of relative change in X
%                * out.sol   : numerical solution obtained by this code
%                * out.itr   : number of iterations used
%

% Copyright (c), May, 2009
%       Junfeng Yang, Dept. Math., Nanjing Univiversity
%       Wotao Yin,    Dept. CAAM, Rice University
%       Yin Zhang,    Dept. CAAM, Rice University


[m n f] = size(F);

if nargin < 4; opts = []; end
opts = getopts(opts);

C = getC;
[D,Dt] = defDDt;

% initialization
X = F;
Lam1 = zeros(m,n,f);
Lam2 = Lam1;
beta = opts.beta;
gamma = opts.gamma;
print = opts.print;

% finite diff
[D1X,D2X,D3X] = D(X);
f = fval;

out.snr = [];
out.relchg = [];
out.f = f;

%% Main loop
for ii = 1:opts.maxitr
    
    % ==================
    %   Shrinkage Step
    % ==================
    Z1 = D1X + Lam1/beta;
    Z2 = D2X + Lam2/beta;
    Z3 = D3X + Lam3/beta;
    V = Z1.^2 + Z2.^2 + Z3.^2;
    V = sqrt(V);
    V(V==0) = 1;
    V = max(V - 1/beta, 0)./V;
    Y1 = Z1.*V;
    Y2 = Z2.*V;
    Y3 = Z3.*V;
    
    % ==================
    %     X-subprolem
    % ==================
    Xp = X;
    X = (mu*C.KtF - Dt(Lam1,Lam2,Lam3))/beta + Dt(Y1,Y2,Y3);
    X = fft2(X)./(C.eigsDtD + (mu/beta)*C.eigsKtK);
    X = real(ifft2(X));
    
    snrX = snr(X);
    out.snr = [out.snr; snrX];
    relchg = norm(X - Xp,'fro')/norm(X,'fro');
    out.relchg = [out.relchg; relchg];
    
    if print
        fprintf('Iter: %d, snrX: %4.2f, relchg: %4.2e\n',ii,snrX,relchg);
    end
    
    % ====================
    % Check stopping rule
    % ====================
    if relchg < opts.relchg
        out.sol = X;
        out.itr = ii;
        [D1X,D2X,D3X] = D(X);
        f = fval;
        out.f = [out.f; f];
        return
    end
    
    % finite diff.
    [D1X,D2X,D3X] = D(X);
    
    f = fval;
    out.f = [out.f; f];
    
    % ==================
    %    Update Lam
    % ==================
    Lam1 = Lam1 - gamma*beta*(Y1 - D1X);
    Lam2 = Lam2 - gamma*beta*(Y2 - D2X);
    Lam3 = Lam3 - gamma*beta*(Y3 - D3X);
end
out.sol = X;
out.itr = ii;
out.exit = 'Exist Normally';
if ii == opts.mxitr
    out.exit = 'Maximum iteration reached!';
end

    function opts = getopts(opts)
        
        if ~isfield(opts,'maxitr')
            opts.maxitr = 500;
        end
        if ~isfield(opts,'beta')
            opts.beta = 10;
        end
        if ~isfield(opts,'gamma')
            opts.gamma = 1.618;
        end
        if ~isfield(opts,'relchg')
            opts.relchg = 1.e-3;
        end
        if ~isfield(opts,'print')
            opts.print = 0;
        end
    end


%% nested functions

    function C = getC
        sizeF = size(F);
        C.eigsK = psf2otf(H,sizeF);
        C.KtF = real(ifft2(conj(C.eigsK) .* fft2(F))); 
        C.eigsDtD = abs(psf2otf([1,-1],sizeF)).^2 + abs(psf2otf([1;-1],sizeF)).^2 + abs(psf2otf(reshape([1,-1],[1,1,2]),sizeF)).^2;
        C.eigsKtK = abs(C.eigsK).^2;
    end

    function f = fval
        f = sum(sum(sqrt(D1X.^2 + D2X.^2 + D3X.^2)));
        KXF = real(ifft2(C.eigsK .* fft2(X))) - F;
        f = f + mu/2 * norm(KXF,'fro')^2;
    end

    function [D,Dt] = defDDt
        % defines finite difference operator D
        % and its transpose operator
        
        D = @(U) ForwardD(U);
        Dt = @(X,Y,Z) Dive(X,Y,Z);
        
        function [Dux,Duy, Duz] = ForwardD(U)
            % Forward finite difference operator
            Dux = cat(2,diff(U,1,2), U(:,1,:) - U(:,end,:));
            Duy = cat(1,diff(U,1,1), U(1,:,:) - U(end,:,:));
            Duz = cat(3,diff(U,1,3), U(:,:,1) - U(:,:,end));
        end
        
        function DtXY = Dive(X,Y,Z)
            % Transpose of the forward finite difference operator
            DtXY = cat(2,X(:,end,:) - X(:, 1,:), -diff(X,1,2));
            DtXY = DtXY + cat(1,Y(end,:,:) - Y(1, :,:), -diff(Y,1,1));
            DtXY = DtXY + cat(3,Z(:,:,end) - Y(:,:,1), -diff(Z,1,3));
        end
    end

end