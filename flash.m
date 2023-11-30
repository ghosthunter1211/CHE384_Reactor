function [x,y,mL,mG] = flash(z, mI, T)
    if nargin<2
        disp('ERROR! Not enough input arguements for flash function')
        return
    end
    
    K=zeros(1,3);
    x=zeros(1,3);
    y=x;

    %Partial pressure of each species
    for species=1:3
        K(species)=Antoine(T, species);
    end

    %Checks to ensure that Bubble and Dew root finding methods are working
    DD=sum(z./K); BB=sum(z.*K);

    %Root finding method that determines Dew/Bubble point temperature
    D=@(z,K)(sum(z./K)-1);
    B=@(z,K)(sum(z.*K)-1);
%     Dew=DewBub(z,D);
%     Bubble=DewBub(z,B);

    if DD<1
        Dew=true;
        Bubble=false;
    elseif BB<1
        Bubble=true;
        Dew=false;
    else
        Dew=false; Bubble=false;
        %Perform root finding to calculate Beta
    end

    for spec=1:3
        if Bubble==true
            %all liquid
            x(spec)=z(spec);
            y(spec)=0;
        elseif Dew==true
            %all gas
            y(spec)=z(spec);
            x(spec)=0;
        else
            %Beta estimation
            Beta=root_finding(z,K);
            x(spec)=z(spec)/(1+Beta*(K(spec)-1));
            y(spec)=K(spec)*x(spec);
        end
    end
    %mI = inlet mass
    %mL = liquid outlet mass
    %mG = gas outlet mass 

    %Mass balance calculation
    if Bubble==true
        mL=mI; mG=0;
    elseif Dew==true
        mG=mI; mL=0;
   else
         mL=(mI-(z(1)*mI)/y(1))/(1-x(1)/y(1));
         mG=(mI-(z(1)*mI)/x(1))/(1-y(1)/x(1));

         if mL+mG < mI*0.98
             disp('Unequal input and output streams')
             text=[mL+mG, mI];
             disp(text)
         end
    end
end

function Beta=root_finding(z,K)
    f=@(B)(z(1)*(K(1)-1))/(1+B*(K(1)-1))+(z(2)*(K(2)-1))/(1+B*(K(2)-1))+(z(3)*(K(3)-1))/(1+B*(K(3)-1));

    run=true;
    a=0; b=1;
    err_max=0.000001;
    step=0;

%   BISECTION SEARCH METHOD
%---------------------------------------------------------------------
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

        if step>3000
            Beta=c;
            run=false;
        end
    end
end




