function [x,y] = flash(z, T)
    K=zeros(1,3);
    x=zeros(1,3);
    y=x;

    for species=1:3
        %K=Partial pressure
        K(species)=Antoine(T, species);
    end


    %Determine if the system is below or above Bubble/Dew point

    Dew=sum(z./K); Bubble=sum(z.*K);
    if Dew<=1
        Dew=true;
    elseif Bubble<=1
        Bubble=true;
    else
        disp('Beta calculation')
        Dew=false; Bubble=false;
        %Perform root finding to calculate Beta
    end


    for spec=1:3
        if Bubble
            %all liquid
            x(spec)=1;
            y(spec)=0;
        elseif Dew
            %all gas
            y(spec)=1;
            x(spec)=0;
        else
            %Beta estimation
            Beta=root_finding(z,K);
            x(spec)=z(spec)/(1+Beta*(K(spec)-1));
            y(spec)=K(spec)*x(spec);
        end
    end
end


function Beta=root_finding(z,K)
    f=@(B)(z(1)*(K(1)-1))/(1+B*(K(1)-1))+(z(2)*(K(2)-1))/(1+B*(K(2)-1))+(z(3)*(K(3)-1))/(1+B*(K(3)-1));
          

    run=true;
    a=0.000001; b=1;
    err_max=0.01;
    step=0;

    while run
        step=step+1;
        c=((b-a)/2)+a;
        A=f(a); B=f(b);C=f(c);

        if A*C<0
            b=c;
        elseif B*C<0
            a=c;
        else
            Beta=c;
            run=false;
        end
        
        err=b-a;
        if err<err_max
            Beta=c;
            run=false;
        end

        if step>150
            Beta=c;
            run=false;
        end
    end
end

