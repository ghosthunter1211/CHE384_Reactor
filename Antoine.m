function [pressure, antConst]=Antoine(Temp, Species)
    if nargin < 2
        Species=1;
    end
    
    table=[
        %0.0 0.0012 0.0000 0.0883; 
        10. 0.0025 0.0001 0.1549
        20. 0.0046 0.0003 0.2317;
        30. 0.0083 0.0007 0.3565;
        40. 0.0155 0.0016 0.5603;
        50. 0.0263 0.0031 0.7877;
        60. 0.0409 0.0062 1.1514;
        70. 0.0610 0.0116 1.6082;
        80. 0.0993 0.0191 2.1452;
        90. 0.1395 0.0321 2.9000;
        100 0.1999 0.0542 3.6087;
        110 0.2944 0.0842 4.8907;
        120 0.3771 0.1329 6.3590;
        130 0.5129 0.1944 7.8993;
        140 0.7275 0.2781 9.0558;
        150 0.9483 0.3653 11.4287;
        160 1.2168 0.5049 13.8756
        170 1.5846 0.6846 17.2175
        180 1.9935 0.9785 20.3455
        190 2.5033 1.2999 24.5083
        200 2.9401 1.6368 27.5756];

    Z=zeros(height(table), 3);

    %Creates a vector containing all temperatures
    T=table(:,1);
        
    %Tabulates each pressure for different species from list
    SpecA=table(:,2); SpecB=table(:,3); SpecC=table(:,4);
    Spec=[SpecA, SpecB, SpecC];
    
    Species=Spec(:,Species);

    Z=[ones(length(T), 1), 1./T, -log10(Species)./T];
    A=(Z'*Z)\(Z'*log10(Species));
    
    a=A(1); 
    c=A(3); 
    b=a*c-A(2);

    P=@(t)10.^(a-b./(t+c));
    pressure=P(Temp);
%     plot(T, Species, "Color","b","LineWidth", 1)
%     hold on
%     plot(T,P(T), "Color", "r", "LineWidth", 1)
%     scatter(Temp, pressure)
%     hold off

    antConst=[a,b,c];
end