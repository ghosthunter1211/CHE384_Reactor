z=[1,0,0];
T=[110, 95, 120;
   140, 90, 160;
   175, 170, 180];
vIN=50;
    
for Temp=1:size(T, 1)
    [y3, y5, x6, M3, M5, M6]=SepSys(z, vIN, T(Temp, :));
    
    %Calculation of Phenol produced in outlet streams
    mPhen=y3(:, 2).*M3' + y5(:, 2).*M5' + x6(:, 2).*M6';
    
    %Calculation of Phenol purity
    
    
    %Plotting stream 3 component 
    subplot(2,2,1)
    plot(50:130, y3(:, 1))
    hold on
    plot(50:130, y3(:, 2))
    plot(50:130, y3(:, 3))
    title('Stream 3 Concentration')
 %   legend('A', 'B', 'C')
    xlabel('Reactor Temperature (C)')
    ylabel('Composition')
    hold off
    
    %Plotting stream 5 components
    subplot(2,2,2)
    plot(50:130, y5(:, 1))
    hold on
    plot(50:130, y5(:, 2))
    plot(50:130, y5(:, 3))
    title('Stream 5 Concentration')
%    legend('A', 'B', 'C')
    xlabel('Reactor Temperature (C)')
    ylabel('Composition')
    hold off
    
    %Plotting stream 6 components
    subplot(2,2,3)
    plot(50:130, x6(:, 1))
    hold on
    plot(50:130, x6(:, 2))
    plot(50:130, x6(:, 3))
    title('Stream 6 Composition')
  %  legend('A', 'B', 'C')
    xlabel('Reactor Temperature (C)')
    ylabel('Composition')
    hold off
    
    %Plotting molar flow rates
    subplot(2,2,4)
    plot(50:130, M3)
    hold on 
    plot(50:130, M5)
    plot(50:130, M6)
    plot(50:130, mPhen)
    title('Molar Flow Rates')
  %  legend('3', '5', '6', 'Phenol')
    xlabel('Reactor Temperature (C)')
    ylabel('Mols/s')
    hold off
end

