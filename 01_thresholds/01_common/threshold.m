function [beta, itr]=threshold(N,c,s0,s00,s,p,sim_param,Beta_prev)
%% sim param
% recover from
TolDiff = sim_param(1,1);
Change = sim_param(1,2);
R = sim_param(1,3);
initial_seed = sim_param(1,4);
coeff_bar = sim_param(1,5);
coeff_under = sim_param(1,6);

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

Beta0_seed = zeros(S,2);
for i=1:S
    Beta0_seed(i,1)=coeff_bar*(s(1,i)+sqrt(s00))+c;
    Beta0_seed(i,2)=coeff_under*(s(1,i)+sqrt(s00))+c;
end

Beta0 = zeros(S, 2, N);
for i=1:N
    if N==2
        Beta0(:,:,i) = Beta0_seed;
    else %use N=N-1 to approximate
        Beta0(:,:,i) = Beta_prev;
    end
end
       


%% loop

% initialize
Converge = 0;
Iterate = 0;

tic;
while Converge==0
    
    b0_pre = Beta0(:, :,1);
    
    for i=1:S
        for j=1:2
            b0 = Beta0(:, :,2:N); %take all others' thresholds
            
            
            beta=b0(i,j,1);
                
            if j==1
                M_input = M0;
            elseif j==2
                M_input = M1;
            end
            
            [Ebeta, vQ] = Eb(beta,i,b0,B0,epsilon,M_input,P,Q,v,r);
            beta_new  = vQ*(c-Ebeta);
            beta_update=Change*beta_new + (1-Change)*b0(i,j);
            
            %Nan finder is not breaking the code!
            nanfind = isnan(beta_update);
            if nanfind==1
                break
            end
            
            for k= 1:N
                Beta0(i,j,k) = beta_update;
            end
        end
    end
    
    Diff = abs(Beta0(:,:,1)-b0_pre);
    TotalDiff = sum(reshape(Diff,1,2*S),2);
    Iterate = Iterate + 1;
    
    if TotalDiff<TolDiff
        eltime = toc;
        Converge=1;
        beta=Beta0(:,:,1);
        itr = [Iterate, eltime];
    end;
    
end

end