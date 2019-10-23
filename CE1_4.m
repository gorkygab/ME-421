T_e = 0.1;
u = prbs(7, 4)/2;
N = length(u);
simin.signals.values = u;
simin.time = T_e*(0:(N-1))';

K = 100;

out = sim('CE1', 'StopTime', num2str((N - 1)*T_e));
y = out.simout.data;

R_yu = intcor(y, u);
R_uu = intcor(u, u);
% R_yu = unbiased_intcor(y, u);
% R_uu = unbiased_intcor(u, u);
g = toeplitz(R_uu(1:K))\R_yu(1:K);

hold on
plot(simin.time(1:K), g/T_e, 'r')

R_yu = xcorr(y, u);
R_uu = xcorr(u, u);
g = toeplitz(R_uu(N:N+K-1))\R_yu(N:N+K-1);

plot(simin.time(1:K), g/T_e, 'g')

sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e);
impulse(sysd)