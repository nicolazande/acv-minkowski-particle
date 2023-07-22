function val=DISEGNA(RIS,BOUNDS,app,checkbox,savepath)
    
    %uso questa funzione come main dove chiamo le subfunction   
    dx=RIS(1);
    dy=RIS(2); 
    finito=0; 
    k=1;
    TMP=double.empty;
    OBS=[];
    val=0;
    %funzione stampa chiama stampa nell'app e pubblica il messaggio
    stampa=@app.stampa;
        
    %inizializzo la figura da cui poi prendo i dati
    fig=figure('WindowButtonDownFcn',@eventi);    
    ah = axes('SortMethod','childorder');
    %setto le spaziature dei minorthick
    ah.XAxis.MinorTick='on';
    ah.YAxis.MinorTick='on';
    ah.XAxis.MinorTickValues=BOUNDS(1):RIS(1):BOUNDS(2);
    ah.YAxis.MinorTickValues=BOUNDS(3):RIS(2):BOUNDS(4);
    ah.XMinorGrid='on';
    ah.YMinorGrid='on';
    %plotto figura 
    axis([BOUNDS(1),BOUNDS(2),BOUNDS(3),BOUNDS(4)]); xlabel('X [m]'); ylabel('Y [m]');title('StateSpace(2D)');
        
    %disegno bordi SS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bordX=[BOUNDS(1):dx:BOUNDS(2)]';
    bordY=[BOUNDS(3):dy:BOUNDS(4)]';    
    BORD=[bordX,repmat(BOUNDS(3),length(bordX),1);
          bordX,repmat(BOUNDS(4),length(bordX),1);
          repmat(BOUNDS(1),length(bordY),1),bordY;
          repmat(BOUNDS(2),length(bordY),1),bordY];
    hold on
    plot(BORD(:,1),BORD(:,2),'o');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %funzione per selezione evento dal mouse tasto destro/centrale/shift
    function eventi(src,evnt)        
      %tasto sinistro del mouse
      if strcmp(get(src,'SelectionType'),'normal')
         %store di [x,y,str] presi da disp_point
         [x,y,str]=disp_point(ah);
         finito=0;
         %condizione che mi crea la figura chiusa         
         if ~isempty(TMP) && ismember([x,y],TMP,'rows')             
             stampa('closed figure: press ENTER');
             finito=1;
         end
         %primo punto linea
         hl = line('XData',x,'YData',y,'Marker','.');         
         drawnow;
         %secondo punto linea chiamando subfunction
         set(src,'WindowButtonMotionFcn',@getpoint);         
         %se chiudo il poligono lo riempo e lo metto nel set OST{}
         if finito==1
             %creo bounding box intorno al poligono
             X=min(TMP(:,1)):dx:max(TMP(:,1));
             Y=min(TMP(:,2)):dy:max(TMP(:,2));
             L=1;
             A=zeros(length(X),2);
             for i=1:length(X)
                 for j=1:length(Y)
                     A(L,1)=X(i);
                     A(L,2)=Y(j);
                     L=L+1;
                 end
             end
             %TMP=punti interni ai vertici del poligono
             TMP=A(inpolygon(A(:,1),A(:,2),TMP(:,1),TMP(:,2)),:);
             hold on;
             plot(TMP(:,1),TMP(:,2),'o');
             %creo un set di ostacoli OBS come cell array
             OBS=[OBS;TMP];
             %svuoto TMP e posso ripartire con nuovo ostacolo
             TMP=double.empty;
             k=k+1;                          
         else             
         %continuo a aggiungere vertici del poligono
         TMP=[TMP;x,y]; 
         end
                 
      elseif strcmp(get(src,'SelectionType'),'extend')||strcmp(get(src,'SelectionType'),'open')
         %condizione di fine passo OBS alla subfunction BuildObstacle
         %(tasto centrale o doppio click mouse)
         transfer=@BulidObstacle;
         transfer(OBS);
         %chiudo la figura e passo all'app
         close(fig);
         val=1;
         return;
      end
      
      %funzione che crea la linea con i valori passati
      function getpoint(src,evnt)
         [xn,yn,str]=disp_point(ah);
         xdat=[x,xn];
         ydat=[y,yn];
         %se ho finito non crreo nuova linea
         if(~finito)
            set(hl,'XData',xdat,'YData',ydat);
         end
      end
       
   end

   %per registrare valori punti normalizzati su risoluzione
   function [x,y,str]=disp_point(ah)
      cp=get(ah,'CurrentPoint');  
      x=round(cp(1,1)/dx)*dx;
      y=round(cp(1,2)/dy)*dy;
      %se voglio stampo anche i label
      str=['(',num2str(x,'%0.3g'),', ',num2str(y,'%0.3g'),')'];    
   end

    %parto da ostacolo in 2D e lo trasformo in 5D in base ai parametri
   function BulidObstacle(OBS)
        %inizializzo il transfer per passare dati all'app
        transfer=@app.transfer;
        %creo tutte le dimensioni per passare al 5D
        T=BOUNDS(5):RIS(3):BOUNDS(6)-RIS(3);
        V=BOUNDS(7):RIS(4):BOUNDS(8);
        P=BOUNDS(9):RIS(5):BOUNDS(10);        
        %seleziono solo il primo ostacolo ma posso prenderne altri 
        A=zeros(length(OBS(:,1))*length(T)*length(V)*length(P),2);
        L=1;
        for j=1:length(OBS(:,1))
            for k=1:length(T)
                for l=1:length(V)
                    for m=1:length(P)
                        A(L,1:2)=OBS(j,:);
                        A(L,3)=T(k);
                        A(L,4)=V(l);
                        A(L,5)=P(m);                    
                        L=L+1;
                    end
                end
            end
        end
        stampa('5D obstacle is ready: press PLAY');
        %passo l'ostacolo completo all'app
        transfer(A,checkbox,savepath);
   end
   
end