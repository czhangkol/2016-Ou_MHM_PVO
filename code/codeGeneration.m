function code = codeGeneration(opt1,opt2,len_code)

code = zeros(2,len_code);
k = opt1; %决定层级为>=k+1的直方图挪法

if k >= 0
    if opt2 == 1
        offset = -floor(k/2);
        offset_minus = floor(k/2)+1;
    elseif opt2 == -1
        offset = -floor(k/2)-1;
        offset_minus = floor(k/2);
    elseif opt2 == 0
        offset = -floor(k/2);
        offset_minus = floor(k/2);
    end
else
    if opt2 == 1
        offset = -floor(k/2);
        offset_minus = floor(k/2)+1;
    elseif opt2 == -1
        offset = floor(k/2)+1;
        offset_minus = -floor(k/2);
    elseif opt2 == 0
        offset = -floor(k/2);
        offset_minus = floor(k/2);
    end
end

if k < 0
    for i = 0:31
        code(1,i+1) = code(1,i+1) + offset;
        code(2,i+1) = code(2,i+1) + offset_minus;
    end
end


if k == 0
    code(1,1) = code(1,1);
    code(2,1) = code(2,1) -1;
    for i = 1:31
        code(1,i+1) = code(1,i+1) + offset;
        code(2,i+1) = code(2,i+1) + offset_minus;
    end
end

if k > 0
    code(1,1) = code(1,1);
    code(2,1) = code(2,1) -1;
    
    
    
    for i = 1:k
       offsetK = -(i-1) + floor((i-1)/2);
       offsetK_minus =floor((i-1)/2);
       code(1,i+1) = code(1,i+1) + offsetK;
       code(2,i+1) = code(2,i+1) + offsetK_minus; 
    end
    
   
    
    for i = k+1:31
        code(1,i+1) = code(1,i+1) + offset;
        code(2,i+1) = code(2,i+1) + offset_minus;
    end
    
    
end





end