clear all
z=[0.4,0.3,0.3];

step=0;
for T=50:200
    step=step+1;
    [x(step, :), y(step, :), ~, ~]=flash(z, 5, T);
end

xa=length(x(:,1))+49;

subplot(2,1,1)
hold on
plot(50:xa,x(:, 1))
plot(50:xa,x(:, 2))
plot(50:xa,x(:, 3))
hold off
xlabel('Temperature')
ylabel('Composition')
legend('Species A', 'Species B', 'Species C')
title('Liquid Component')

subplot(2,1,2)
hold on
plot(50:xa,y(:, 1))
plot(50:xa,y(:, 2))
plot(50:xa,y(:, 3))
hold off
xlabel('Temperature')
ylabel('Composition')
legend('Species A', 'Species B', 'Species C')
title('Gas Component')
