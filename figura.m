function A=figura(BOUND,RIS)

L=1; dX=RIS(1); dY=RIS(2); dT=RIS(3); dV=RIS(4); dP=RIS(5);

X=BOUND(1,1):dX:BOUND(1,2);
Y=BOUND(2,1):dY:BOUND(2,2);
T=BOUND(3,1):dT:BOUND(3,2);
V=BOUND(4,1):dV:BOUND(4,2);
P=BOUND(5,1):dP:BOUND(5,2);

A=zeros(length(X)*length(Y)*length(T)*length(V)*length(G),2);
for i=1:length(X)
    for j=1:length(Y)
        for k=1:length(T)
            for l=1:length(V)
                for m=1:length(P)
                    A(L,1)=X(i);
                    A(L,2)=Y(j);
                    A(L,3)=T(k);
                    A(L,4)=V(l);
                    A(L,5)=P(m);                    
                    L=L+1;
                end
            end
        end
    end
end
end