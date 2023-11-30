function [y3, y5, x6, M3, M5, M6] = SepSys(z, vIN, T)

    step=0;

    %Reactor process
    for Temp=50:130
        step=step+1;
        [M2(step), z2(step, :)]=reactor(z, vIN, Temp);
    end
    

    %Two seperation processes
    for step=1:step
        [y3(step, :), x4(step, :), M3(step), M4(step)]=composite(z2(step, :), M2(step), T);
        [y5(step, :), x6(step, :), M5(step), M6(step)]=composite(x4(step, :), M4(step), T);
    end
end