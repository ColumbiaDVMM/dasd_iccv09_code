% DEMO program for DASD, working on TRECVID 2006 test data set.
% Example semantic graph and intial annotation scores for TRECVID 2006 test
% data are also released in this package.
% 
% Techniques implemented were presented in the following paper:
%------------------------------------------------------------------------
% Yu-Gang Jiang, Jun Wang, Shih-Fu Chang, Chong-Wah Ngo, Domain Adaptive 
% Semantic Diffusion for Large Scale Context-Based Video Annotation, Proc.
% of ICCV, 2009.
%------------------------------------------------------------------------

% set parameters...
options = [];
options.F_posscale = 0.04; % step size 'alpha'
options.W_scale = 0.04;    % step size 'beta'
options.iter = 20;         % number of iteration (diffusion time)
options.adaptation = 1;    % need adaptation? diffusion without graph adpatation if 0 
options.norm_flag = 0;     % need normalization of initial score?

load data\score06.mat; % load initial score data
load data\tv06_gt.mat; % load ground-truth labels of TRECVID06 for evaluation
load data\PM_06NN.mat; % load semantic graph (PM_pos)
sGraph = PM_pos;

map = apcal(score, tv06_gt); % compute baseline MAP. note that this is based 
% on the partial labels provided by NIST. to compute the inferred AP, please
% uncomment the last line of this script to generate a file for NIST tool.
fprintf('Baseline MAP:%f \n', map);

tic
rScore = dasd(sGraph,score,options); % dasd...
toc

Rmap = apcal(rScore, tv06_gt); % compute MAP of refined score
fprintf('refined result - MAP:%f \n', Rmap);
fprintf('relative improvement -- %.1f%%\n', (Rmap/map-1)*100);

% uncomment the line below to generate a file for offical TRECVID
% evaluation tool (available from TRECVID website) that evaluates 
% *inferred* average precision (InfAP)
%%% gen_treceval(rScore);