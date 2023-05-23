function rule = ruleGeneration(a,b)

rule = zeros(2,b-a+1);
n = 1;
for i = a:b
    if mod(abs(i),2) == 1
        rule(1,n) = i;
        rule(2,n) = 1;
        n = n + 1;
        rule(1,n) = i;
        rule(2,n) = -1;
        n = n + 1;
    else
        rule(1,n) = i;
        n = n + 1;
    end
    
    
end

end