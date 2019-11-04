T_e = 0.1;

sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e);

simin.time = T_e*(0:999)';

simin.signals.values = [zeros(10,1); ones(990,1)]/2;
out = sim('CE1', 'StopTime', '99.9');

hold on
plot(simin.time - 1, out.simout.data*2, 'r')
title("Step response of the system");
step(sysd)

simin.signals.values = [zeros(10,1); ones(10,1); zeros(980,1)]/2;
out = sim('CE1', 'StopTime', '99.9');

figure
hold on
plot(simin.time - 1.5, out.simout.data*2, 'r')
title("Impulse response of the system");
impulse(sysd)