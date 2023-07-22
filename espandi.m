function OBS=espandi(OBS,Rcar,RIS,BOUNDS)
    %fa la somma di minkowski tra macchina (Raggio) e ostacolo solo nella
    %direzione in cui serve (non sbatte in retro altrimenti avrebbe
    %sbattuto di fronte)
    j=1;
    step=min(RIS(1),RIS(2));
    ORIGINAL=OBS;
    while j*step<=Rcar
        CAR=[round(j*step*cos(ORIGINAL(:,3))/RIS(1))*RIS(1),round(j*step*sin(ORIGINAL(:,3))/RIS(2))*RIS(2)];
        OBS=unique([OBS;[ORIGINAL(:,1:2)-CAR,ORIGINAL(:,3:5)]],'rows');
        j=j+1;
    end
 
end