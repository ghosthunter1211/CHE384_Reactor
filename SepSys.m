function [M3, M5, M6, y3, y5, x6] = SepSys(z, vIN, T)
    %T is a vector:
    %T(1) -> reactor temp
    %T(2-4) -> Separator 1/2 flash temp
    
    %Reactor process
    [M2, z2]=reactor(z, vIN, T(1));
    
    %Two seperation processes
    [y3, x4, M3, M4]=composite(z2, M2, T(2:4));
    [y5, x6, M5, M6]=composite(x4, M4, T(2:4));
end