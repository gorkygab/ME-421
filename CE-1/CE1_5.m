T_e = 0.1;
p = 4;
n = 9;
u = prbs(n, p)/2;
N = length(u);
P = N/p;
simin.signals.values = u;
simin.time = T_e*(0:(N-1))';

out = sim('CE1', 'StopTime', num2str((N - 1)*T_e));
y = out.simout.data;

u_hat = zeros(P, 1);
y_hat = zeros(P, 1);
for i = 0:p-1
    u_hat = u_hat + fft(u(1+i*P:(i+1)*P));
    y_hat = y_hat + fft(y(1+i*P:(i+1)*P));
end
u_hat = u_hat/p;
y_hat = y_hat/p;
g_hat = y_hat./u_hat;

x = (2*pi/T_e)/P*(0:P-1);

hold on

sys = frd(g_hat, x);
bode(sys, x)

sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e);
bode(sysd, x)