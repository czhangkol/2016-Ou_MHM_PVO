function T = findT(EC_est,Capacity)
T = 1024;
for t = 1:256
    if EC_est(t) >= Capacity
        T = t - 1;
        break
    end
end

end