function [Beta_all, Computation_all]=threshold_compute(N_range, s_range, p_range, c_range, s0_range, s00_range)

NN = size(N_range,2);
Nc = size(c_range,2);
Ns = size(s_range,1);
S = size(s_range,2);
Ns0 = size(s0_range,2);
Ns00 = size(s00_range,2);

%% sim param
TolDiff = 0.001;
Change = 0.2; %not raise too high because start to oscillate
R = 5*10^5;
initial_seed = 1;
coeff_bar = 0.1;
coeff_under = -0.15;
sim_param = [TolDiff, Change, R, initial_seed, coeff_bar, coeff_under];

%% run
Beta_all = zeros(S,2,NN+1,Nc,Ns,Ns0,Ns00);
Computation_all = zeros(1,2,NN,Nc,Ns,Ns0,Ns00);

for is=1:Ns
    s=s_range(is,:);
    p=p_range(is,:);
    for iN=1:NN
        N = N_range(1,iN);
        for ic=1:Nc
            c = c_range(1,ic);
            for is0=1:Ns0
                s0 = s0_range(1,is0);
                for is00=1:Ns00
                    s00 = s00_range(1,is00);
                    Beta_prev=Beta_all(:,:,iN,ic,is0,is00);
                    [beta, itr]=threshold(N,c,s0,s00,s,p,sim_param,Beta_prev);
                    Beta_all(:,:,iN+1,ic,is,is0,is00)=beta;
                    Computation_all(:,:,iN,ic,is,is0,is00)=itr;
                end
            end
        end
    end
end

%N=1
for is=1:Ns
    s=s_range(is,:);
    for ic=1:Nc
        c = c_range(1,ic);
        for is0=1:Ns0
            s0 = s0_range(1,is0);
            for is00=1:Ns00
                s00 = s00_range(1,is00);
                for i=1:S
                    se = s(1,i);
                    Beta_all(i,1,1,ic,is,is0,is00)=c*(1+(se^2+s00^2)/s0^2);
                end
            end
        end
    end
end

end