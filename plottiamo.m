function h=plottiamo(ICS,fix4,fix5,dim1,dim2,dim3,min1,max1,min2,max2,min3,max3,h,label,RIS)
    
    err4=2*RIS(4);
    err5=2*RIS(5);
    szICS=size(ICS);
    sezione=ICS(abs(ICS(:,4)-repmat(fix4,szICS(1),1))<repmat(err4,szICS(1),1) & abs(ICS(:,5)-repmat(fix5,szICS(1),1))<repmat(err5,szICS(1),1),:);
    
    if label=='2D'
        h=scatter(sezione(:,1),sezione(:,2),'s','fill','MarkerEdgeColor','k');grid minor;axis([min1,max1,min2,max2]);xlabel(dim1);ylabel(dim2);title(string(dim1)+'-'+string(dim2));
        %shp=alphaShape(sezione(:,1),sezione(:,2));
        %h=plot(shp);grid minor;axis([min1,max1,min2,max2]);xlabel(dim1);ylabel(dim2);title(string(dim1)+'-'+string(dim2));
    else
        h=scatter3(sezione(:,1),sezione(:,2),sezione(:,3),'s','fill','MarkerEdgeColor','k');grid minor;axis([min1,max1,min2,max2,min3,max3]);xlabel(dim1);ylabel(dim2);zlabel(dim3);title(string(dim1)+'-'+string(dim2)+'-'+string(dim3));
        %shp=alphaShape(sezione(:,1),sezione(:,2),sezione(:,3),1);
        %h=plot(shp);grid minor;axis([min1,max1,min2,max2,min3,max3]);xlabel(dim1);ylabel(dim2);zlabel(dim3);title(string(dim1)+'-'+string(dim2)+'-'+string(dim3));
    end
    
end