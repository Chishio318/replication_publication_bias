function [y, z] = Ebs(beta,b,sigma,B0,epsilon,M,v,r)

Nm = size(M,1); %number of possible m realizations

EbPs = zeros(Nm,2);

for k=1:Nm
    [Ebeta, Pbeta] = EbPm(beta,b,sigma,B0,epsilon,M(k,:),v,r);
    EbPs(k,1)=Ebeta;
    EbPs(k,2)=Pbeta;
end

z = sum(EbPs(:,2));
y = EbPs(:,1)'*EbPs(:,2)/z;

end