clear all
clc


imgfile = ['C:\Works\Matlab\My_Histogram\MHM-PVO\publicVer\'];
imgdir = dir([imgfile,'\*.bmp']);
performance = zeros(length(imgdir),4);
shift = zeros(16,1000);

for ii = 7
  tic  
img =ii
I = double(imread([imgfile,'\',imgdir(ii).name]));
[d1,d2] = size(I);
rule = ruleGeneration(-4,31);
len_rule = length(rule(1,:));

tmp = 1;

[bin_LM,bin_LM_len,I] = LocationMap(I);

bestCode = zeros(2,33);

%-------------Preprocess for capacity map
CapMap = zeros(15*len_rule,256);

for CN = 2:15

    [p,NL,his,pFor,xpos,ypos,xmax,xmin] = HisGeneration(I,CN);
    len_code = max(xmax-xmin)+1;

    for i = 1:len_rule
%             for i = 4:4

        opt1 = rule(1,i);
        opt2 = rule(2,i);
        code = codeGeneration(opt1,opt2,len_code);

        EC_est = CapacityMap(p,code,NL,pFor,xmax,xmin);
        index = len_rule*(CN-1)+i;
        CapMap(index,:) = EC_est;
    end
end

% load Cmap_Graykodim24.mat
% load Re_Elaine.mat
% ReOr = Re;
% load Code_Elaine.mat


Re = zeros(1000,4);
Re_SSIM = zeros(1000,2);
Re_shift = zeros(1000,2);
maxEC = 0;
for Capacity = 10000+bin_LM_len:10000:10000+bin_LM_len
%     Capacity
    n = 1;
    bestEC = 1;
    bestED = 99999;
    bestCN = 0;
    bestRule = 0;
    
    
    
    
    for CN = 2:15
        [p,NL,his,pFor,xpos,ypos,xmax,xmin] = HisGeneration(I,CN);
        len_code = max(xmax-xmin)+1;
        for ruleIndex = 1:len_rule
%             n
            n = n+ 1;
            
            
            opt1 = rule(1,ruleIndex);
            opt2 = rule(2,ruleIndex);
            code = codeGeneration(opt1,opt2,len_code);
            EC_est = CapacityMap(p,code,NL,pFor,xmax,xmin);
            
%             index = len_rule*(CN-1)+ruleIndex;
%             EC_est =  CapMap(index,:);
            T = findT(EC_est,Capacity);
            if T == 1024
                continue
            else
                [Iw,EC,ED,T] = dataEmbedAdjust(I,Capacity,code,NL,pFor,xpos,ypos,xmax,xmin,T,p);
            end
            
            if ED/EC < bestED/bestEC && EC >= Capacity
                bestEC = EC;
                bestED = ED;

                bestShift = ED - 0.5*EC;
                bestCN = CN;
                bestRule = ruleIndex;
            end
        end
    end
    
    if bestEC >= maxEC
        maxEC = bestEC;
    end
    
    if bestEC >= Capacity
        Re(tmp,1) = bestEC-bin_LM_len;
        Re(tmp,2) = 10*log10(255^2*d1*d2/bestED);
        Re(tmp,3) = bestCN;
        Re(tmp,4) = bestRule;
        bestCode(2*(tmp-1)+1:2*tmp,1) =  bestEC;
        
        Re_shift(tmp,1) =  bestEC-bin_LM_len;
        Re_shift(tmp,2) =  bestShift;
        
        opt1 = rule(1,bestRule);
        opt2 = rule(2,bestRule);
        code = codeGeneration(opt1,opt2,len_code);
        bestCode(2*(tmp-1)+1:2*tmp,2:33) =  code(:,1:32);
         
        tmp = tmp + 1;
    end
    
    if maxEC < Capacity
        break
    end
    
    
end
tmp = tmp - 1;
performance(img,1:4) = Re(1,1:4);
shift(2*(img-1)+1:2*img,:) = Re_shift';
toc
end






% save Re_Elaine.mat Re
% save Code_Elaine.mat bestCode