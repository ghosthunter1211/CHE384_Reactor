function Temp=DewBub(z, f)
    run=true;
    up=200; low=0; xr_old=(up-low)/2;
    Kup=zeros(1, 3); Klow=Kup; Kr=Kup;

    for species=1:3
        Kup(species)=Antoine(up, species);
    end
    for species=1:3
       Klow(species)=Antoine(low, species);
    end

    while run == true
        xr=up -(f(z,Kup)*(low-up))/(f(z, Klow)-f(z, Kup));
        xr=xr_old+((xr-xr_old)*0.5);
        for species=1:3
           Kr(species)=Antoine(xr, species);
        end

        err = abs((xr-up)/xr);
        if err <= 0.00001
            Temp=xr;
            break
        end
        
        %switches whatever boundary condition is the same sign
        if f(z,Kr)*f(z,Kup) > 0
            up=xr;
            Kup=Kr;
        elseif f(z,Kr)*f(z,Klow) > 0
            low=xr;
            Klow=Kr;
        else
            disp('ERROR IN THE BETA CALCULATION FALSE POSITION METHOD')
        end     
    end
end