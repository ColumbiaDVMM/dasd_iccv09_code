function map = apcal(score, gt)
% compute average precision for the 20 concepts evaluated in TRECVID 2006

ap = zeros(1,20);
evalid = [318 370 242 218 102 227 367 91 263 223 17 82 139 12 59 353 255 124 216 66]';
for i = 1:20
    vector = score(:,evalid(i))';
    [svec,I] = sort(vector);
    setsize = length(vector);
    noright = 0;
    apsum = 0;
    for t=1: 2000%setsize
        idx = I(1,setsize-t+1);
        if gt(idx,i) == 1
            noright = noright + 1;
            apsum = apsum + noright/t;
        end
    end
    if noright~=0
        ap(i) = apsum/min(2000,sum(gt(:,i)));
    end
end
map = mean(ap);
