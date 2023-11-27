function [y3, x6, M3, M6] = composite(z1, mIN, T, display)
    if nargin < 3
        format_spec = 'Error in composite function. Expected three input arguements, and %d was given';
        sprintf(format_spec, nargin)
        return
    elseif nargin < 4 
        display = false;
    end

    Iter=100; %Number of iterations

    [x5, y2, M2, M5] = flash(z1, mIN, T(1));    %initial flash unit
    [x4, y3, M4, M3] = flash(y2, M2, T(2));     %gas flash unit 2
    [x6, y7, M6, M7] = flash(x5, M5, T(3));     %liquid flash unit 3
    
    %Iterative method that performs Jacobian of the three flash units
    for step=1:Iter
        %Recalculates the incoming stream composition to 1st flash unit
        z1=(z1*mIN + x4*M4 + y7*M7)/(mIN+M4+M7);

        [x5, y2, M5, M2] = flash(z1, mIN, T(1));    %initial flash unit
        [x4, y3, M4, M3] = flash(y2, M2, T(2));     %gas flash unit 2
        [x6, y7, M6, M7] = flash(x5, M5, T(3));     %liquid flash unit 3
        Masses(step, :)=[M3, M4, M6, M7];

    end    
    
    if display==true
        plot(1:length(Masses(:,1)), Masses(:,1))
        hold on
        plot(1:length(Masses(:,1)), Masses(:,2))
        plot(1:length(Masses(:,1)), Masses(:,3))
        plot(1:length(Masses(:,1)), Masses(:,4))
        
        legend('M3', 'M4', 'M6', 'M7')
        xlim([0, Iter])
        ylim([0, mIN])
        hold off
    end
end