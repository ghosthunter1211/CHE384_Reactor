clear all

T=[110 95 120.0;
    140 90 160.;
    175 170 180;
    140 160 90.;
    140 160 150;
    140 90 130];

z=[0.4 0.3 0.3;
   0.8 0.1 0.1;
   0.1 0.8 0.1;
   0.1 0.1 0.8];

step=0;
mL=zeros(size(T,1)*size(z,1), 1);
mG=mL;

for Temp=1:size(T, 1)
    for Comp=1:size(z, 1)
        step=step+1;
        [mL(step), mG(step)]=composite(z(Comp, :), 5, T(Temp, :));
        Tstack(step)={T(Temp, :)};
        Cstack(step)={z(Comp, :)};
    end
end

TAB=table(Tstack', Cstack', mL, mG);
