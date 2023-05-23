function [bin_LM bin_LM_len I] = LocationMap(I)
[d1 d2] = size(I);
flow_map = [];
pe= 0;
for i=1:d1-1
    for j=1:d2-1
       if I(i,j) == 0
           I(i,j) = 1;
           flow_map = [flow_map 1];
           continue
       end
       if I(i,j) ==255
           I(i,j) = 254;
           flow_map = [flow_map 1];
           continue
       end
       if I(i,j) ==254
              flow_map = [flow_map 0];
              continue
       end
       if I(i,j) ==1
              flow_map = [flow_map 0];
              continue
       end
    end
end



%without compression
bin_LM_len = length(flow_map);
bin_LM = flow_map;

%after compression
cPos_x = cell(1,1);%��������ѹ��
cPos_x{1} = flow_map;
loc_Com =  arith07(cPos_x);
bin_index = 8;
[bin_LM, bin_LM_len] = dec_transform_bin(loc_Com, bin_index);

end