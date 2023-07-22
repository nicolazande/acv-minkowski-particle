clearvars

%inizializzo variabili globali
global fixP
global fixB
global fixR
global ax
global RIS
global SP
global ICS
global K
global Xf
global A
global B
global BOUNDS
global INPUT
global Rcar
global dt
global WS
global figEvolver
fixP=0;
fixB=0;
fixR=0;
errP=0.05;
errB=0.05;
errR=0.05;
load('settings.mat');
load('K.mat');
load('ICS.mat');
global FIG;
FIG=figure();

%inizializzo figura interatiiva
fig = uifigure('WindowButtonDownFcn',@eventi,'Position',[100 100 1000 500]);
ax = uiaxes('SortMethod','childorder','Parent',fig,...
            'Units','pixels',...
            'Xlim',[-B(1),B(2)],...
            'Ylim',[-B(3),B(4)],...
            'XMinorGrid','on',...
            'YMinorGrid','on',...
            'Position', [400, 50, 500, 400]);
ax.XLabel.String='X';
ax.YLabel.String='Y';
ax.Title.String='2D section';
%titolo
annotation(fig,'textbox', [0.4, 0.96, 0, 0],...
           'FitBoxToText','on',...
           'string', 'EVOLVER')
%slider1
txaP= uitextarea(fig,'Position',[260 340 70 20]);
sldP = uislider(fig,'Value',0,'Position',[60 350 150 3],'limits',[-B(5),B(6)],'ValueChangingFcn',@(sldP,event) Pchange(event,txaP,ax));                
annotation(fig,'textbox', [0.01, 0.72, 0, 0], 'string', 'Psi: ')
%slider2
txaB= uitextarea(fig,'Position',[260 240 70 20]);
sldB = uislider(fig,'Value',0,'Position',[60 250 150 3],'limits',[-B(7),B(8)],'ValueChangingFcn',@(sldB,event) Bchange(event,txaB,ax));
annotation(fig,'textbox', [0.01, 0.52, 0, 0], 'string', 'Beta: ')
%slider3
txaR= uitextarea(fig,'Position',[260 140 70 20]);
sldR = uislider(fig,'Value',0,'Position',[60 150 150 3],'limits',[-B(9),B(10)],'ValueChangingFcn',@(sldR,event) Rchange(event,txaR,ax));
annotation(fig,'textbox', [0.01, 0.32, 0, 0], 'string', 'R: ')
%scegli un punto
btn=uibutton(fig,'push',...
             'Text', 'scegli',...
             'Position',[100, 40, 100, 22],...
             'ButtonPushedFcn', @(btn,event) OKPushed(btn,ax));
%vai avanti        
avanti=uibutton(fig,'push',...
             'Text', 'avanti',...
             'Position',[250, 40, 100, 22],...
             'ButtonPushedFcn', @(avanti,event) Favanti);
%plotta un sezione tanto per        
szICS=size(ICS);
sezione=ICS(abs(ICS(:,3)-repmat(fixP,szICS(1),1))<repmat(errP,szICS(1),1) & abs(ICS(:,4)-repmat(fixB,szICS(1),1))<repmat(errB,szICS(1),1) & abs(ICS(:,5)-repmat(fixR,szICS(1),1))<repmat(errR,szICS(1),1),:);
scatter(ax,sezione(:,1),sezione(:,2),'s','fill','MarkerEdgeColor','k');

%-------------funzioni per callback---------------------------------
%se premo scegli parto
function OKPushed(btn,ax)
        global RIS
        errP=0.02;
        errB=0.02;
        errR=0.02;
        global fixP
        global fixB
        global fixR
        global ICS
        global SP
        global Xf
        

        szICS=size(ICS);
        sezione=ICS(abs(ICS(:,3)-repmat(fixP,szICS(1),1))<repmat(errP,szICS(1),1) & abs(ICS(:,4)-repmat(fixB,szICS(1),1))<repmat(errB,szICS(1),1) & abs(ICS(:,5)-repmat(fixR,szICS(1),1))<repmat(errR,szICS(1),1),:);
        Xf=[SP,fixP,fixB,fixR];
        save('Xf.mat','Xf'); 
        bbb_evolvi;

end
%cambio slider1
function Pchange(event,txaP,ax)
    global RIS
    errP=0.02;
    errB=0.02;
    errR=0.02;
    global fixP
    global fixB
    global fixR
    global ICS
    global B
    global FIG
    fixP=round(event.Value/RIS(3))*RIS(3);
    txaP.Value = num2str(fixP);

    szICS=size(ICS);
    sezione=ICS(abs(ICS(:,3)-repmat(fixP,szICS(1),1))<repmat(errP,szICS(1),1) & abs(ICS(:,4)-repmat(fixB,szICS(1),1))<repmat(errB,szICS(1),1) & abs(ICS(:,5)-repmat(fixR,szICS(1),1))<repmat(errR,szICS(1),1),:);
    scatter(ax,sezione(:,1),sezione(:,2),'s','fill','MarkerEdgeColor','k');
    FIG
    scatter(sezione(:,1),sezione(:,2),'s','fill','MarkerEdgeColor','k');;grid minor;axis([-B(1),B(2),-B(3),B(4)]);
    
end
%cambio slider2
function Bchange(event,txaB,ax)
    global RIS
    errP=0.02;
    errB=0.02;
    errR=0.02;
    global fixP
    global fixB
    global fixR
    global ICS
    global B
    global FIG
    fixB=round(event.Value/RIS(4))*RIS(4);
    txaB.Value = num2str(fixB);
  
    szICS=size(ICS);
    sezione=ICS(abs(ICS(:,3)-repmat(fixP,szICS(1),1))<repmat(errP,szICS(1),1) & abs(ICS(:,4)-repmat(fixB,szICS(1),1))<repmat(errB,szICS(1),1) & abs(ICS(:,5)-repmat(fixR,szICS(1),1))<repmat(errR,szICS(1),1),:);
    scatter(ax,sezione(:,1),sezione(:,2),'s','fill','MarkerEdgeColor','k');
    
    FIG
    scatter(sezione(:,1),sezione(:,2),'s','fill','MarkerEdgeColor','k');;grid minor;axis([-B(1),B(2),-B(3),B(4)]);
    
end
%cambio slider3
function Rchange(event,txaR,ax)
    global RIS
    errP=0.02;
    errB=0.02;
    errR=0.02;
    global fixP
    global fixB
    global fixR
    global ICS
    global B
    global FIG
    fixR=round(event.Value/RIS(5))*RIS(5);
    txaR.Value = num2str(fixR);
    
    szICS=size(ICS);
    sezione=ICS(abs(ICS(:,3)-repmat(fixP,szICS(1),1))<repmat(errP,szICS(1),1) & abs(ICS(:,4)-repmat(fixB,szICS(1),1))<repmat(errB,szICS(1),1) & abs(ICS(:,5)-repmat(fixR,szICS(1),1))<repmat(errR,szICS(1),1),:);
    scatter(ax,sezione(:,1),sezione(:,2),'s','fill','MarkerEdgeColor','k');
    
    FIG
    scatter(sezione(:,1),sezione(:,2),'s','fill','MarkerEdgeColor','k');grid minor;axis([-B(1),B(2),-B(3),B(4)]);

end
%get eventi mouve
function eventi(src,evnt)
    global ax
    global SP
    global RIS
    global FIG
    if strcmp(get(src,'SelectionType'),'normal')
        cp=get(ax,'CurrentPoint');
        hold(ax,'on')
        SP=[round(cp(1,1)/RIS(1))*RIS(1),round(cp(1,2)/RIS(2))*RIS(2)];
        scatter(ax,SP(1),SP(2),'s','fill','MarkerEdgeColor','r');
        hold(ax,'off')
        hold on
        FIG
        scatter(SP(1),SP(2),'s','fill','MarkerEdgeColor','r');
        hold off
    end
end
%evolvi MAIN
function bbb_evolvi()
    global fixP
    global fixB
    global fixR
    global ax
    global RIS
    global SP
    global ICS
    global K
    global Xf
    global A
    global B
    global BOUNDS
    global INPUT
    global Rcar
    global dt
    global WS
    global figEvolver

    
    clearvars
    load('Xf.mat'); %Punto su cui lavoro
    load('ICS.mat');
    load('K.mat');
    load('settings.mat');
    
    %LIBERO_Forward
    m=sett(1); Lf=sett(2); Lr=sett(3); J=sett(4); Cf=sett(5); Cr=sett(6); v=sett(7);
    dx=RIS(1); dy=RIS(2); dPsi=RIS(3); dB=RIS(4); dR=RIS(5); dt=RIS(6);
    szA=size(A);

    X =     Xf(:,1) + round(v * cos(Xf(:,3) + Xf(:,4)) * dt / dx) * dx;
    Y =     Xf(:,2) + round(v * sin(Xf(:,3) + Xf(:,4)) * dt / dy) * dy;
    Psi =   Xf(:,3) + round(Xf(:,5) * dt / dPsi) * dPsi;
    b =     Xf(:,4) + round(( (-(Cr+Cf)/(m*v))*Xf(:,4) + (-1+(Cr*Lr-Cf*Lf)/(m*v^2)) * Xf(:,5)) *dt / dB) * dB;
    R =     Xf(:,5) + round(( (Cr*Lr-Cf*Lf)/J*Xf(:,4) + (-(Cr*Lr^2+Cf*Lr^2)/(J*v)) * Xf(:,5)) *dt / dR) * dR;

    %tmp_lib = [X,Y,Psi,b,R]; 
    tmp_lib = [X,Y,Psi,b,R];

    % %Salvo solo i punti che effettivamente potrei trovare in Alg_2
    % OUT_lib = tmp_lib(sum(tmp_lib*A<=repmat(B,szXf(1),1),2)==szA(2),:);

    %Forzato_Forward
    szXf = size(tmp_lib);
    RIS_Input = load('settings.mat').dINPUT;
    tmp_forz = double.empty;
    INPUT = [65*INPUT(1),65*INPUT(2)]; %Attento qui!

    for i=1:length(INPUT)
        dB=round(Cf/(m*v)*INPUT*dt/RIS(4))*RIS(4);
        dR=round((Cf*Lf/J)*INPUT*dt/RIS(5))*RIS(5); 
        U = [dB,dR];
        tmp_forz=[tmp_forz; tmp_lib(:,1:3),tmp_lib(:,4)+repmat(U(1),szXf(1),1),tmp_lib(:,5)+repmat(U(2),szXf(1),1)];
    end

    tmp_forz = unique(tmp_forz,'rows');

    ib  = ismember(ICS, K, 'rows');
    pb = ICS(~ib,:);

    norm = 200;

    %Starting point
    figure(1)
    plot(K(:,1),K(:,2),'o','MarkerEdgeColor','#D95319');
    grid on;
    xlabel('x [m]');
    ylabel('y [m]');
    title('Only K');
    hold on
    Xf_depth = (Xf(5)/(pi/2)) * norm + norm; %Allargo il punto in funzione di r
    scatter(Xf(:,1),Xf(:,2),Xf_depth,'o','MarkerEdgeColor','k','MarkerFaceColor','#77AC30');%<- Green initial point
    hold on
    quiver(Xf(1),Xf(2),cos(Xf(3)),sin(Xf(3)),'LineWidth',1,'Color','#FF0000');
    hold on
    quiver(Xf(1),Xf(2),cos(Xf(3)+Xf(4))/2,sin(Xf(3)+Xf(4))/2,'LineWidth',1,'Color','#00FF00');
    axis([-B(1),B(2),-B(3),B(4)]);

    %After Libero
    figure(2)
    plot(K(:,1),K(:,2),'o','MarkerEdgeColor','#D95319');
    grid on;
    xlabel('x [m]');
    ylabel('y [m]');
    title('After Libero');
    hold on

    Xf_depth = (Xf(5)/(pi/2))*norm + norm; %Allargo il punto in funzione di r
    scatter(Xf(:,1),Xf(:,2),Xf_depth,'o','MarkerEdgeColor','k','MarkerFaceColor','#77AC30');%<- Green initial point
    hold on
    quiver(Xf(1),Xf(2),cos(Xf(3)),sin(Xf(3)),'LineWidth',1,'Color','#FF0000');
    hold on
    quiver(Xf(1),Xf(2),cos(Xf(3)+Xf(4))/2,sin(Xf(3)+Xf(4))/2,'LineWidth',1,'Color','#00FF00');

    hold on 

    tmp_lib_depth = (tmp_lib(5)/(pi/2))*norm + norm; %<- r
    scatter(tmp_lib(:,1),tmp_lib(:,2),tmp_lib_depth,'square','MarkerEdgeColor','k','MarkerFaceColor','#7E2F8E');%<- Violet dopo_libero points
    hold on
    quiver(tmp_lib(1),tmp_lib(2),cos(tmp_lib(3)),sin(tmp_lib(3)),'LineWidth',1,'Color','#FF0000'); % <-psi
    hold on
    quiver(tmp_lib(1),tmp_lib(2),cos(tmp_lib(3)+tmp_lib(4))/2,sin(tmp_lib(3)+tmp_lib(4))/2,'LineWidth',1,'Color','#00FF00'); %<-beta

    axis([-B(1),B(2),-B(3),B(4)]);

    %After_Forzato
    figure(3)
    plot(K(:,1),K(:,2),'o','MarkerEdgeColor','#D95319');
    grid on;
    xlabel('x [m]');
    ylabel('y [m]');
    title('After Forzato');
    hold on

    Xf_depth = (Xf(5)/(pi/2))*norm + norm; %Allargo il punto in funzione di r
    scatter(Xf(:,1),Xf(:,2),Xf_depth,'o','MarkerEdgeColor','k','MarkerFaceColor','#77AC30');%<- Green initial point
    hold on
    quiver(Xf(1),Xf(2),cos(Xf(3)),sin(Xf(3)),'LineWidth',1,'Color','#FF0000');
    hold on
    quiver(Xf(1),Xf(2),cos(Xf(3)+Xf(4))/2,sin(Xf(3)+Xf(4))/2,'LineWidth',1,'Color','#00FF00');

    hold on 

    tmp_lib_depth = (tmp_lib(5)/(pi/2))*norm + norm; %<- r
    scatter(tmp_lib(:,1),tmp_lib(:,2),tmp_lib_depth,'square','MarkerEdgeColor','k','MarkerFaceColor','#7E2F8E');%<- Violet dopo_libero points
    hold on
    quiver(tmp_lib(1),tmp_lib(2),cos(tmp_lib(3)),sin(tmp_lib(3)),'LineWidth',1,'Color','#FF0000'); % <-psi
    hold on
    quiver(tmp_lib(1),tmp_lib(2),cos(tmp_lib(3)+tmp_lib(4))/2,sin(tmp_lib(3)+tmp_lib(4))/2,'LineWidth',1,'Color','#00FF00'); %<-beta

    hold on 

    tmp_forz_depth = (tmp_forz(:,5)/(pi/2))*norm + repmat(norm,length(tmp_forz(:,1)),1); %<- r
    scatter(tmp_forz(:,1),tmp_forz(:,2),tmp_forz_depth,'d','MarkerEdgeColor','k','MarkerFaceColor','#A2142F');%<- RED dopo_forzato points
    hold on
    quiver(tmp_forz(:,1),tmp_forz(:,2),cos(tmp_forz(:,3)),sin(tmp_forz(:,3)),'LineWidth',1,'Color','#FF0000'); % <-psi
    hold on
    quiver(tmp_forz(:,1),tmp_forz(:,2),cos(tmp_forz(:,3)+tmp_forz(:,4))/2,sin(tmp_forz(:,3)+tmp_forz(:,4))/2,'LineWidth',1,'Color','#00FF00'); %<-beta

    axis([-B(1),B(2),-B(3),B(4)]);

    Xf=tmp_forz;
    save('Xf.mat','Xf');
    
end

function Favanti()
    global figEvolver
    close(figEvolver);
    bbb_evolvi
end
