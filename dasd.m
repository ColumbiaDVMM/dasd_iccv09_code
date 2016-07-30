% Domain adaptive semantic diffusion (for context based annotation
% refinement)
%
% rScore = dasd(sGraph,score,options)
% Input:
%   . W: semantic graph (concept affinity matrix - m by m)
%   . score: n by m matrix of initial annotation scores from individual classifiers 
%   . options: optimization parameters (see demo.m)
% Output:
%   . score_new: refined score matrix
% 
% Techniques implemented were presented in the following paper:
%------------------------------------------------------------------------
% Yu-Gang Jiang, Jun Wang, Shih-Fu Chang, Chong-Wah Ngo, Domain Adaptive 
% Semantic Diffusion for Large Scale Context-Based Video Annotation, Proc.
% of ICCV, 2009.
%------------------------------------------------------------------------
function score_new = dasd(W,score,options)

% parameters
F_posscale = options.F_posscale;
W_scale = options.W_scale;
N_iter = options.iter;
B_adapt = options.adaptation;
norm_flag = options.norm_flag;

if norm_flag
    score=(score-repmat(min(score),size(score,1),1))./...
        (repmat(max(score),size(score,1),1)-repmat(min(score),size(score,1),1));
end

% node number in graph
gSize = size(W,1);

score_new = score;
clear score;

% degree matrix of W
d = sum(W);
D = diag(d);
% normalized graph laplacian
Wnorm = D^(-0.5)*W*D^(-0.5);
L= D^(-1)*D - Wnorm;

for i=1:N_iter
    %%%
    fprintf('iteration %i ...\n',i);
    % update score with gradient descending
    deltF = score_new*L'*F_posscale; % (gradient w.r.t score g) * (step size)
    score_new = score_new-deltF;
    clear deltF;
    %
    if B_adapt
        %%%%% NOW update W
        score_w = score_new;
        for j = 1:gSize
            score_w(:,j) = score_new(:,j)/sqrt(sum(score_new(:,j).^2));
        end
        deltW = score_w'*score_w; % g^t*g -- gradient w.r.t Wnorm
        clear score_w;
        % W_temp = (Wnorm~=0);
        %%%%% truncate deltW to keep the sparsity property of W/Wnorm
        deltW(deltW < 0) = 0;
        for j = 1:gSize
            deltW(j,j) = 0;
            gMax = max(deltW(j,:));
            for k = 1:gSize
                if deltW(j,k) < gMax
                    deltW(j,k) = 0;
                end
            end
        end
        deltW = (deltW + deltW')/2; % ensure W is symmetric 
        %%%%%%
        Wnorm = Wnorm + (deltW)*W_scale; % not exactly a normalized graph 
        % after updates, but further normalization doesn't help on performance
        %
        %if i==20; fprintf('%f\n',W(102,369));end;
        L = D^(-1)*D - Wnorm; % update graph laplacian
    end
end



