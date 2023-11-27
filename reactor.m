function [mTot, z] = reactor(z, V, T)

    %Constants
    Ea = 120*1000;      %Activation Energy
    R = 8.314;          %Gas Constant   
    v = .5;             %Velocity
    A = 1.0686*10^13;   %pre-exponential factor
    Ca1=0.2;            %initial concentration of A
    %V=50;              %Volumetric flow rate (L/s)
    step=0;
    L=100;              %Length of the rod
    inc=0.1;            %increment amount
    


    %Variables
    T=T+273;                    %Temp from Celcius to Kelvin
    mTot=(z(1)/(Ca1*V))^-1;     %Calculates total mols in system
    mBC=0.5*(mTot - Ca1*V);     %Calculates mols of B/C components
    Cb1=mBC/V; Cc1=mBC/V;       %Calculates the concentration of B/C components
    
    %Euler function for first concentration equation for species A
    Ca=@(Ca1)((-1/v)*(Ca1^0.5)*A*exp(-Ea/(R*T)));
    Cb=@(Ca1)((1/v)*(Ca1^0.5)*A*exp(-Ea/(R*T)));
    Cc=@(Ca1)((1/v)*(Ca1^0.5)*A*exp(-Ea/(R*T)));

    C2=zeros(length(0:inc:L), 3);
    for i=0:inc:L
        step=step+1;

        %Eulers for the three species concentrations
        C2(step, 1)=Ca1+Ca(Ca1)*inc;  
        C2(step, 2)=Cb1+Cb(Ca1)*inc;
        C2(step, 3)=Cc1+Cc(Ca1)*inc;

        Ca1=C2(step, 1);
        Cb1=C2(step, 2);
        Cc1=C2(step, 3);
    end

    plot(0:inc:L, C2(:, 1));
    hold on
    plot(0:inc:L, C2(:, 2));
    plot(0:inc:L, C2(:, 3));
    legend('A', 'B', 'C');
    hold off

    mA=Ca1*V; mB=Cb1*V; mC=Cc1*V;               %Recalculation of molar output
    mTot=mA+mB+mC;
    z(1)=mA/mTot; z(2)=mB/mTot; z(3)=mC/mTot;   %Concentration calculation
end