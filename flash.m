function [x,y,mL,mG] = flash(z, mI, T)
    if nargin<2
        disp('ERROR! Not enough input arguements for flash function')
        return
    end
    
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
% 
%     %false position method
%     run=true;
%     up=1; low=0; 
%     while run == true
% 
%         xr=up -(f(up)*(low-up))/(f(low)-f(up));
% 
%         err = abs((xr-up)/xr);
%         if err <= 0.00000000001
%             Beta_opt=xr;
%             break
%         end
%         
%         %switches whatever boundary condition is the same sign
%         if f(xr)*f(up) > 0
%             up=xr;
%         elseif f(xr)*f(low) > 0
%             low=xr;
%         else
%             disp('ERROR IN THE BETA CALCULATION FALSE POSITION METHOD')
%         end     
%     end
end




