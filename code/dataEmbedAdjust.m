function [Iw,EC,ED,T] = dataEmbedAdjust(I,payload,code,NL,pFor,xpos,ypos,xmax,xmin,T,p)

%-----------------Ö±·½Í¼Ñ¡bin
hisBk = zeros(511,6000);
hisAk = zeros(511,6000);
EC = 0;
[d1,d2] = size(I);

for i = 1:pFor
    if EC >= payload
        break
    end
    
    if NL(i) <= T
        ind = xmax(i) - xmin(i);
        k = xmax(i) - xmin(i)+1;
        bk = xmax(i) + code(1,k);
        ak = xmin(i) + code(2,k);
        
        if p(i) == bk || p(i) == ak
            EC=EC+1;
        end
        
        if p(i)>= bk
        PE = p(i)-  bk;        
        hisBk(PE+256,ind+1) = hisBk(PE+256,ind+1) + 1;
        continue
        end
        
        if p(i)<= ak
        PE = p(i)-  ak;        
        hisAk(PE+256,ind+1) = hisAk(PE+256,ind+1) + 1;
        continue
        end
    end
    
end


%--------------first adjustment
EC = 0;
ED = 0;

sequence = zeros(5,32);
sequence2 = zeros(5,32);
d = 3;
for i = 0:min(T,31)
   
    peakA = 256;
    peakB = 256;
    maxMin = hisAk(peakA,i+1);
    maxMax = hisBk(peakB,i+1);
    
    dminus = 0;
    dplus = 0;
    for j = 0:d
        if hisAk(peakA-j,i+1) >= maxMin
            maxMin = hisAk(peakA-j,i+1);
            dminus = -j;
        end
    end
    sequence2(1,i+1) = maxMin;
    sequence2(2,i+1) = dminus;
    sequence2(3,i+1) = 2;
    sequence2(4,i+1) = hisAk(peakA+dminus-1,i+1);
    sequence2(5,i+1) = i;
    
    EC = EC + maxMin;
    B = cumsum(hisAk(:,i+1));
    ED = ED + maxMin*0.5 + B(peakA+dminus-1);
    
    for j = 0:d
        if hisBk(peakB+j,i+1) >= maxMax
            maxMax = hisBk(peakB+j,i+1);
            dplus = j;
        end
    end
    
    sequence(1,i+1) = maxMax;
    sequence(2,i+1) = dplus;
    sequence(3,i+1) = 1;
    sequence(4,i+1) = hisBk(peakB+dplus+1,i+1);
    sequence(5,i+1) = i;
    
    
    EC = EC + maxMax;
    B = cumsum(hisBk(:,i+1));
    ED = ED + maxMax*0.5 + B(511)-B(peakB+dplus);
    
    code(1,i+1) = code(1,i+1) + dplus;
    code(2,i+1) = code(2,i+1) + dminus;
end

if T > 31
    
    for i = 32:T
        peakA = 256;
        peakB = 256;
        EC = EC + hisAk(peakA,i+1) + hisBk(peakB,i+1);
        B = cumsum(hisAk(:,i+1));
        ED = ED +hisAk(peakA,i+1)*0.5 + B(511)-B(peakA);
        B = cumsum(hisBk(:,i+1));
        ED = ED + hisBk(peakB,i+1)*0.5 + B(511)-B(peakB);
    end
    
end


SeCombine = zeros(5,64);
SeCombine(:,1:32) = sequence;
SeCombine(:,33:64) = sequence2;

[~,ind] = sort(SeCombine(1,:),'descend');
SeCombine = SeCombine(:,ind);

bestEC = EC;
bestED = ED;

%--------------second adjustment

for i = 1:64

   
   if SeCombine(3,i) == 1
       EC = bestEC + SeCombine(4,i) - SeCombine(1,i);
       dplus = SeCombine(2,i);
       ED = bestED - 0.5*SeCombine(1,i) - 0.5*SeCombine(4,i);
       if EC >= payload && ED/EC < bestED/bestEC
           bestEC = EC;
           bestED = ED;
           k = SeCombine(5,i);
           code(1,k+1) = code(1,k+1) + 1;
       end
       continue
   end
   
   if SeCombine(3) == 2
       EC = bestEC + SeCombine(4,i) - SeCombine(1,i);
       dminus = SeCombine(2,i);
       ED =  bestED - 0.5*SeCombine(1,i) - 0.5*SeCombine(4,i);
       if EC >= payload && ED/EC < bestED/bestEC
           bestEC = EC;
           bestED = ED;
           k = SeCombine(5,i);
           code(2,k+1) = code(2,k+1) - 1;
       end
       continue
   end
    
   if SeCombine(3) == 0
       break
   end
    
    
end








Iw = I;
EC = 0;
ED = 0;

data = randperm(d1*d2);

for i=1:pFor
    
    if EC >= payload
        return
    end
    if NL(i) <= T
        k = xmax(i) - xmin(i)+1;
        bk = xmax(i) + code(1,k);
        ak = xmin(i) + code(2,k);
        
        
        if p(i)== bk
            bit = mod(data(fix(i/512)*500+mod(i,512)),2);
            Iw(xpos(i),ypos(i)) = p(i)+ bit;
            EC = EC + 1;
            ED = ED + 0.5;
            continue
        end
        
        if p(i)== ak
            bit = mod(data(fix(i/512)*500+mod(i,512)),2);
            Iw(xpos(i),ypos(i)) = p(i)- bit;
            EC = EC + 1;
            ED = ED + 0.5;
            continue
        end
        
        if p(i)> bk
            ED = ED + 1;
            Iw(xpos(i),ypos(i)) = p(i)+ 1;
            continue
        end
        
        if p(i)< ak
            ED = ED + 1;
            Iw(xpos(i),ypos(i)) = p(i)- 1;
            continue
        end
        
        
    end
end




end


