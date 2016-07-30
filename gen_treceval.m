function gen_treceval(score)
% generate text file for TRECVID evaluation tool (to compute inferred AP)

load data\shotlist.mat;
evalid = [318 370 242 218 102 227 367 91 263 223 17 82 139 12 59 353 255 124 216 66]';
officialID = [1 3 5 6 10 12 17 22 23 24 26 27 28 29 30 32 35 36 38 39];
fid=fopen('06eval20.txt','w');
% start to iterate for 20 concepts
for conceptind = 1:20
    vector = score(:,evalid(conceptind));
    %
    [svec,I] = sort(vector');   
    %========================================================
    % write to text file for TRECVid evaluation tool
    %========================================================
    for i=1:2000
        idx = I(1,length(shotlist)-i+1);
        shot = char(shotlist{idx});
        %find 'R'
        t = strfind(shot,'R');
        shotname = shot(1,1:t-2);
        fprintf(fid,'%i 0 %s %i %i dasdtest\n',1000+officialID(conceptind),shotname,i,10000-i);
    end
end
fclose(fid);