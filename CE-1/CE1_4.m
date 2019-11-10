T_e = 0.1;
u = prbs(7, 4)/2;
N = length(u);
simin.signals.values = u;
simin.time = T_e*(0:(N-1))';

K = 120;

out = sim('CE1', 'StopTime', num2str((N - 1)*T_e));
y = out.simout.data;

sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e); %blue code
true = impulse(sysd, simin.time(1:K));

R_yu = intcor(y, u);
R_uu = intcor(u, u);
g = toeplitz(R_uu(1:K))\R_yu(1:K)/T_e;
intcor_error = sqrt(sum((g - true).^2))

hold on
plot(simin.time(1:K), g, 'r') %intcor impulse response

R_yu = xcorr(y, u);
R_uu = xcorr(u, u);
g = toeplitz(R_uu(N:N+K-1))\R_yu(N:N+K-1)/T_e;
xcorr_error = sqrt(sum((g - true).^2))

plot(simin.time(1:K), g, 'g') %xcorr impulse response
impulse(sysd)

legend('intcor', 'xcorr', 'true')