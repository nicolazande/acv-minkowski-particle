function [ICS,h,K]=MAIN(INPUT,RIS,B,sett,K,Rcar,app,sicurezza,stopper,USCITA)

%funzione per stampare messaggio
stampa=@app.stampa;

%espando ostacolo con minksum
if Rcar~=0
    K=espandi(K,Rcar,RIS,B);
end

%definisco lo SS come Ax<=b
A=  [-1,  0,  0,  0,  0;
      1,  0,  0,  0,  0;
      0, -1,  0,  0,  0;
      0,  1,  0,  0,  0;
      0,  0, -1,  0,  0;
      0,  0,  1,  0,  0;
      0,  0,  0, -1,  0;
      0,  0,  0,  1,  0;
      0,  0,  0,  0, -1;
      0,  0,  0,  0,  1]';

W=K;
Xs=double.empty;
Rnew=double.empty;
Rold=double.empty;
newEXIT=cell(1,4);
oldEXIT=cell(1,4);

k=1;
while k<100 %upper bound
    stampa("iterazione="+string(k))
    Xs=unique([W;Rold],'rows');
    Xf=Xs;    
    
    %sottrazione minkowski (movimento forzato)
    pos=[0;0];
    for i=1:length(INPUT)
         U=FDT(INPUT(i),RIS,sett);
         %fa insieme forzato e intersezione
         Xf=MINKOWSKI(Xf,U-pos,A,B,RIS);
         %aggiorno la posizione relativa
         pos=U;
    end    
    
    %----movimento libero (con taglio)-------------
    [Rnew,newEXIT]=LIBERO(Xf,A,B,RIS,sett,sicurezza,USCITA);  
    %----------------------------------------------

    %condizione uscita multipla    
    if isequal(newEXIT,oldEXIT)
            Rnew=unique([Rnew;W],'rows');
            break;
    else
        Rold=Rnew;
        oldEXIT=newEXIT;
        k=k+1;              
    end
    
    %------plotta evoluzione-----------------------
    %newEXIT{1}=Area, newEXIT{2}=XY, newEXIT{3}=Xb, newEXIT{4}=Npunti ...
    if USCITA(2)
        if k>1
            EVnew=newEXIT{2};
            EVold=oldEXIT{2};
            plot(EVnew(:,1),EVnew(:,2),'o');grid minor;axis([-B(1),B(2),-B(3),B(4)]);title('evoluzione');
            hold on
            plot(EVold(:,1),EVold(:,2),'o');grid minor;
        end
    end
    %---------------------------------------------
    
end
close
ICS=Rnew;

%-----------salvo tutto per alalizer--------------------------
save('analizer\settings.mat','A','B','INPUT','Rcar','RIS','sett');
save('analizer\K.mat','K');
save('analizer\ICS.mat','ICS');
%-------------------------------------------------------------
stampa('ICS completed!');
h=figure;
end

