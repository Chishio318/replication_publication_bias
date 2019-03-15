allM = 2-index_loop(3, N-1);
sum_allM = sum(allM,2);
M1 = [];
M0 = [];

for i=1:size(allM,1)
    if sum_allM(i,1)==1
        M1 = [M1; allM(i,:)];
        
    elseif sum_allM(i,1)==0
        M0= [M0; allM(i,:)];
        
    end
end