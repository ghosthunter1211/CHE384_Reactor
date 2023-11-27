clear all
z=[1, 0, 0;
   0.5, 0.25, 0.25];
step=0;

for Comp=1:2
    for T=80:134
        step=step+1;
        [M(step), x(step, :)]=reactor(z(Comp, :), 50, T);
    end
end

half=length(M)/2;
close=length(M);

TAB=table(M', x);
subplot(1,3,1)
plot(1:half, M(1:half))
hold on
plot(1:half, M((half+1):close));
hold off

subplot(1,3,2)
plot(80:134, x(1:half, 1))
hold on
plot(80:134, x(1:half, 2))
plot(80:134, x(1:half, 3))
legend('A', 'B', 'C')
hold off

subplot(1,3,3)
plot(80:134, x((half+1):close, 1))
hold on
plot(80:134, x((half+1):close, 2))
plot(80:134, x((half+1):close, 3))
legend('A', 'B', 'C')
hold off
