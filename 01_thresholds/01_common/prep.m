%% prep
v0 = s0^2;
v = s.^2 + s00^2;
S = size(s,2);

%% correlation coefficients and weights+probabilities
r = zeros(S,S); 
for i1=1:S
    for i2=1:S
        r(i1,i2) = v0/sqrt((v(1,i1)+v0)*(v(1,i2)+v0));
        % correlation structure rho
    end
end

Q = zeros(S*ones(1,N));
P = zeros(S*ones(1,N));
J = index_loop(S,N-1);
for i1=1:S
    for i2=1:size(J,1)
        % initial values
        prob = 1;
        inv_var=1/v0+1/v(1,i1);
        % add element one by one
        for j=1:N-1
            prob = prob*p(1,J(i2,j));
            inv_var = inv_var + 1/v(1,J(i2,j));
        end
        P(i1,i2) = prob;
        Q(i1,i2) = prob/inv_var;
        %i2 is linear index for J(i2,:)
    end
end