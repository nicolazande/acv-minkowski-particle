function OUTPUT=FDT_byc(INPUT,RIS,sett)
    m=sett(1); Lf=sett(2); J=sett(4); Cf=sett(5); v=sett(7); dt = RIS(6);
    %la scrivo in base al mio sistema:INPUT/OUTPUT
    dB=round(Cf/(m*v)*INPUT*dt/RIS(4))*RIS(4);
    dR=round(0.1*(Cf*Lf/J)*INPUT*dt/RIS(5))*RIS(5);
    OUTPUT=[dB;dR];
end