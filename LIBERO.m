function [OUT,EXIT]=LIBERO(Xf,A,B,RIS,sett,sicurezza,USCITA)
    m=sett(1); Lf=sett(2); Lr=sett(3); J=sett(4); Cf=sett(5); Cr=sett(6); v=sett(7);
    dx=RIS(1); dy=RIS(2); dPsi=RIS(3); dB=RIS(4); dR=RIS(5); dt=RIS(6);
    szA=size(A);
    szXf=size(Xf);
    EXIT=cell(1,4);
    
    %compensazione di sicurezza
    if sicurezza~=0   
        dirX=sign(Xf(:,4).*cos(Xf(:,3))*dt);
        dirY=sign(Xf(:,4).*sin(Xf(:,3))*dt);
        X=round((Xf(:,1)-v*cos(Xf(:,3)+Xf(:,4))*dt+dirX*sicurezza*dx)/dx)*dx;
        Y=round((Xf(:,2)-v*sin(Xf(:,3)+Xf(:,4))*dt+dirY*sicurezza*dy)/dy)*dy;
    else
        X=round((Xf(:,1)-v*cos(Xf(:,3)+Xf(:,4))*dt)/dx)*dx;
        Y=round((Xf(:,2)-v*sin(Xf(:,3)+Xf(:,4))*dt)/dy)*dy;    
    end
    Psi=round(mod(Xf(:,3)-Xf(:,5)*dt,B(6))/dPsi)*dPsi;    
    b=round(Xf(:,4)-((-(Cr+Cf)/(m*v))*Xf(:,4)+(-1+((Cr*Lr-Cf*Lf)/(m*v^2)))*Xf(:,5))*dt/dB)*dB;
    R=round((Xf(:,5)-((Cr*Lr-Cf*Lf)/J*Xf(:,4)+(-(Cr*Lr^2+Cf*Lf^2)/(J*v))*Xf(:,5))*dt)/dR)*dR;
    
    %set di punti evoluti da libero devono essere tagliati in SS
    tmp=[X,Y,Psi,b,R];
    
    %seleziono solo punti ammissibili per x*A<B
    %----taglio per non replicare 0 e 2pi su Psi e B (solo locali)-------
    B(6)=B(6)-RIS(3);
    B(8)=B(8);
    %--------------------------------------------------------------------
    OUT=tmp(sum(tmp*A<=repmat(B,szXf(1),1),2)==szA(2),:);
    
    %cerco i boundary
    if USCITA(1)
        EXIT{1}=polyarea(OUT(:,1),OUT(:,2));
    end
    if USCITA(2)
        EXIT{2}=OUT(boundary(OUT(:,1),OUT(:,2)),:);
    end
    if USCITA(3)
        EXIT{3}=boundary(OUT(:,1),OUT(:,4));
    end
    if USCITA(4)
        EXIT{4}=length(OUT(:,1));
    end
    
end
            
            
            
            