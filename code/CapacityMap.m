function EC_est = CapacityMap(p,code,NL,pFor,xmax,xmin)

EC_est = zeros(1,256);

for i=1:pFor
    
        k = xmax(i) - xmin(i)+1;
        bk = xmax(i) + code(1,k);
        ak = xmin(i) + code(2,k);
        
        
        if p(i) == bk
            EC_est(NL(i)+1:256) = EC_est(NL(i)+1:256)+1;
            continue
        end
        
        if p(i) == ak
            EC_est(NL(i)+1:256) = EC_est(NL(i)+1:256)+1;
            continue
        end

end




end