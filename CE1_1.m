T_e = 0.1;

sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e);

simin.time = T_e*(1:1000)';

simin.signals.values = [zeros(10,1); ones(990,1)];
out = sim('CE1', 'StopTime', '99.9');

hold on
plot(out.simout/(2*pi*T_e))
title("Step response of the system");
step(sysd)

simin.signals.values = [1; zeros(999,1)];
out = sim('CE1', 'StopTime', '99.9');

figure
hold on
plot(out.simout/(2*pi*T_e))
title("Impulse response of the system");
impulse(sysd)