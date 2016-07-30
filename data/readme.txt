this data folder contains the following files:

+++++++++++++++++++

score06.mat -- detection scores of 374 concepts over TRECVID 2006 test set (from VIREO-374 http://vireo.cs.cityu.edu.hk/research/vireo374)

tv06_gt.mat -- ground-truth labels over TRECVID 2006 test set (partial labeled; officially TRECVID use inferred AP for performance evaluation as it does not require a fully labeled test set)

shotlist.mat -- shot(keyframe) list of TRECVID 2006 test set (corresponds to each row of score06.mat)

PM_06NN.mat -- semantic graph of 374 concepts (sparse graph using kNN -- 6 nearest neighbors for each node/concept)