function Xf=MINKOWSKI(Xf,U,A,B,RIS)
    
    %Variabili
    dbeta=RIS(4);
    dr=RIS(5);
    signBeta=0;
    signR=0;
    step_Beta=abs(U(1)/dbeta)
    step_R=abs(U(2)/dr)
    szXf=size(Xf);
    szA=size(A);
    TMP=Xf;
    szTMP=szXf;
    %--------errore------------------
    ERR=[0.01,0.01,0.01,0.01,0.01];
    %--------------------------------
    if U(1)~=0
        %------memorizzo limiti vecchio ostacolo---------
        mB=min(TMP(:,4));
        MB=max(TMP(:,4));
        %------------------------------------------------
        if U(1)<0
            A_b=A(:,7);
            B_b=B(7);
            signB=-1;
            %--------muovo quarta dimensione---------------
            TMP=[TMP(:,1:3),TMP(:,4)-repmat(U(1),szTMP(1),1),TMP(:,5)];
            %---per fare intersezione lineare---------------
            ind=setpoint(Xf,Xf(1,1:4),step_Beta,ERR(1:4));
            first=Xf(ind:end,:);
            second=TMP(1:end-ind+1,:);
            %-------intersezione (fisso X,Y,Psi)------------
            TMP=TMP(sum(abs(first(:,1:3)-second(:,1:3))<ERR(1:3),2)==3,:);
            %------identifico complementare-----------------
            szOLD=size(Xf(Xf(:,4)<mB-U(1),:));     
        elseif U(1)>0
            A_b=A(:,8);
            B_b=B(8);
            signB=1;
            %--------muovo quarta dimensione----------------
            TMP=[TMP(:,1:3),TMP(:,4)-repmat(U(1),szTMP(1),1),TMP(:,5)];
            %---per fare intersezione lineare---------------
            ind=setpoint(TMP,TMP(1,1:4),step_Beta,ERR(1:4));
            first=Xf(1:end-ind+1,:);
            second=TMP(ind:end,:);
            %-------intersezione (fisso X,Y,Psi)------------
            TMP=Xf(sum(abs(first(:,1:3)-second(:,1:3))<ERR(1:3),2)==3,:);
            %------identifico complementare-----------------
            szOLD=size(Xf(Xf(:,4)>MB-U(1),:));   
        end
        szTMP=size(TMP);
        %-----------trovo attacco al vincolo------------------
        lineB=Xf(abs(Xf*A_b-repmat(B_b,szXf(1),1))<repmat(ERR(4),szXf(1),1),:);
        szCONTACT=size(lineB);
        %---------creo complementare--------------------------
        Lb=length(lineB(:,1));
        tmp=zeros(Lb*step_Beta+1,5);
        %tmp(1:Lb,:)=lineB;
        for j=1:step_Beta+1
            tmp((j-1)*Lb+1:j*Lb,:)=lineB-signB*[zeros(Lb,3),repmat((j-1)*dbeta,Lb,1),zeros(Lb,1)];
        end
        szNEW=size(tmp);
        %---decido dove e se aggiungere il complementare------
        if szNEW(1)<=szOLD(1)+szCONTACT(1)
            %--seleziono parte superiore e aggiungo complementare
            if U(1)<0
                Xf=sortrows([TMP(TMP(:,4)>mB-U(1),:);tmp],'ascend');
                szXf=size(Xf);
            %--seleziono parte inferiore e aggiungo complementare
            elseif U(1)>0
                Xf=sortrows([TMP(TMP(:,4)<MB-U(1),:);tmp],'ascend');
                szXf=size(Xf);
            end
        else
            %----non serve aggiungere il complementare----
            Xf=sortrows(TMP,'ascend');
            szXf=size(Xf);
        end
    end
    
    %scelgo dove costruire il complementare su R
    if U(2)~=0
        %------memorizzo limiti vecchio ostacolo---------
        mR=min(Xf(:,5));
        MR=max(Xf(:,5));
        %------------------------------------------------
        if U(2)<0
            A_r=A(:,9);
            B_r=B(9);
            signR=-1;
            %--------muovo quinta dimensione----------------
            TMP=[Xf(:,1:4),Xf(:,5)-repmat(U(2),szXf(1),1)];
            %---per fare intersezione lineare---------------
            first=Xf(step_R+1:end,:);
            second=TMP(1:end-step_R,:);
            %-------intersezione (fisso X,Y,Psi,b)----------
            TMP=TMP(sum(abs(first(:,1:4)-second(:,1:4))<ERR(1:4),2)==4,:);
            %------identifico complementare-----------------
            szOLD=size(Xf(Xf(:,5)<mR-U(2),:));
        elseif U(2)>0
            A_r=A(:,10);
            B_r=B(10);
            signR=1;
            %--------muovo quinta dimensione----------------
            TMP=[Xf(:,1:4),Xf(:,5)-repmat(U(2),szXf(1),1)];
            %---per fare intersezione lineare---------------
            first=Xf(1:end-step_R,:);
            second=TMP(step_R+1:end,:);
            %-------intersezione (fisso X,Y,Psi,b)----------
            TMP=Xf(sum(abs(first(:,1:3)-second(:,1:4))<ERR(1:4),2)==4,:);
            %------identifico complementare-----------------
            szOLD=size(Xf(Xf(:,5)>MR-U(2),:));
        end
        szTMP=size(TMP);
        %-----------trovo attacco al vincolo------------------
        lineR=Xf(abs(Xf*A_r-repmat(B_r,szXf(1),1))<repmat(ERR(5),szXf(1),1),:);
        %---------creo complementare--------------------------
        szCONTACT=size(lineR);
        Lr=length(lineR(:,1));
        tmp=zeros(Lr*step_R+1,5);
        %tmp(1:Lr,:)=lineR;
        for j=1:step_R+1
            tmp((j-1)*Lr+1:j*Lr,:)=lineR-signR*[zeros(Lr,4),repmat((j-1)*dr,Lr,1)];
        end
        szNEW=size(tmp);
        %---decido dove e se aggiungere il complementare------
        if szNEW(1)<=szOLD(1)+szCONTACT(1)
            %--seleziono parte superiore e aggiungo complementare
            if U(2)<0
                Xf=sortrows([TMP(TMP(:,5)>mR-U(2),:);tmp],'ascend');
            %--seleziono parte inferiore e aggiungo complementare
            elseif U(1)>0
                Xf=sortrows([TMP(TMP(:,5)<MR-U(2),:);tmp],'ascend');
            end
        else
            %----non serve aggiungere il complementare----
            Xf=sortrows(TMP,'ascend');
        end         
    end
    
end

 