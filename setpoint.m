function index=setpoint(Xf,current,step,err)
    index=1;
    while sum(abs(Xf(index,1:4)-current)<err)==4 || step>1
        if sum(abs(Xf(index,1:4)-current)>err,2)>0
            current=Xf(index,1:4);
        	step=step-1;
        end
        index=index+1;
    end
end