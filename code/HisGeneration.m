function [p,NL,his,pFor,xpos,ypos,xmax,xmin] = HisGeneration(I,CN)

[d1,d2] = size(I);
NL = zeros(1,(d1-1)*(d2-1));
xpos = zeros(1,(d1-1)*(d2-1));
ypos = zeros(1,(d1-1)*(d2-1));
P1 = zeros(1,(d1-1)*(d2-1));
P2 = zeros(1,(d1-1)*(d2-1));
p = zeros(1,(d1-1)*(d2-1));
pFor = 1;


if CN >=1 && CN <=3
    wd = 1;
elseif CN >= 4 && CN <=8
    wd = 2;
else
    wd = 3;
end

for i  = 1:d1-1
    for j = 1:d2-1
        temp = I(i:min(i+wd,d1),j:min(j+wd,d2));
        temp2 = I(i:min(i+3,d1),j:min(j+3,d2));
        [m,n] = size(temp);
        [m2,n2] = size(temp2);
        
        if m2*n2 -1 < 15
            X = reshape(temp2,m2*n2,1);
            X(1) = [];
            NL(pFor) = max(X) - min(X);            
            X = reshape(temp,m*n,1);
            X(1) = [];
            X = sort(X(:));  
        else
            X = reshape(temp2,m2*n2,1);
            X(1) = [];
            NL(pFor) = max(X) - min(X); 
            ng = zeros(1,15);
                                ng(1) = I(i,j+1);     ng(4) = I(i,j+2);   ng(9) = I(i,j+3);
            ng(2) = I(i+1,j);   ng(3) = I(i+1,j+1);   ng(6) = I(i+1,j+2);   ng(11) = I(i+1,j+3);
            ng(5) = I(i+2,j);   ng(7) = I(i+2,j+1);   ng(8) = I(i+2,j+2);   ng(13) = I(i+2,j+3);
            ng(10) = I(i+3,j);  ng(12) = I(i+3,j+1);  ng(14) = I(i+3,j+2);  ng(15) = I(i+3,j+3);
            
            X = sort(ng(1:CN));
        end
        [max(X) min(X)];
        P1(pFor) = max(X);
        P2(pFor) = min(X);
        xpos(pFor) = i;
        ypos(pFor) = j;
        p(pFor) = I(i,j);
        pFor = pFor + 1;
        
    end
end

pFor = pFor - 1;
NL = NL(1:pFor);
xpos = xpos(1:pFor);
ypos = ypos(1:pFor);
P1 = P1(1:pFor);
P2 = P2(1:pFor);
p = p(1:pFor);

B = unique(NL);
his = zeros(511,256);
his_median = zeros(256,length(B));
bins = zeros(3,length(B));
bins2 = zeros(2,length(B));

xmax = P1;
xmin = P2;


for i = 1:pFor
    

%     [~,ind] = find(B == NL(i));
    
%     his(p(i)+1,ind) = his(p(i)+1,ind) + 1;
if NL(i) <= 14
    ind = xmax(i) - xmin(i);
    PE = p(i) -  xmin(i);
    
    his(PE+256,ind+1) = his(PE+256,ind+1) + 1;
end
    
%     if p(i) >= xmax(i)
%         PE = p(i) - xmax(i);
%         his(PE+256,ind) = his(PE+256,ind) + 1;
%         continue
%     elseif p(i) <= xmin(i)
%         PE = p(i) - xmin(i);
%         his(PE+256,ind) = his(PE+256,ind) + 1;
%         continue
%     else
%         PE = abs(p(i) - xmax(i));
%         his_median(PE,ind) = his_median(PE,ind) + 1;
%     end
    

    %-------将灰度值变为1-256
end


end