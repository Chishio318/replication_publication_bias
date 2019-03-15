function [posteriors]=posterior_Piv(beta_list,sigmai,N,s0,s00,s,p,Beta_input)

%% sim param
R = 4*10^5;
initial_seed = 1;

%% initial
M_allN;
prep;

%random numbers for numerical integration
rng(initial_seed);
epsilon = normrnd(0,1,[R N-1]);
B00 = normrnd(0,1,[R 1]);
B0 = zeros(R, S);
for i=1:S
    w = sqrt(v(1,i)/(v0+v(1,i)));
    B0(:,i) = s0*w*B00;
end

Beta0 = zeros(S, 2, N);
for i=1:N
        Beta0(:,:,i) = Beta_input;
end

 b0 = Beta0(:, :,2:N);  
 
 bin = size(beta_list,2);%%%check
 posteriors = zeros(bin,2);
 
 for i=1:bin
     beta = beta_list(1,i);
     for j=1:2
         if j==1
             M_input = M0;
         elseif j==2
             M_input = M1;
         end
         
         [Ebeta, vQ] = Eb(beta,sigmai,b0,B0,epsilon,M_input,P,Q,v,r);
         posteriors(i,j) = beta/vQ+Ebeta;
     end    
 end
 
   
end