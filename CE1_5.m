T_e = 0.1;
u = prbs(9, 4)/2;
N = length(u);
P = N/4;
simin.signals.values = u;
simin.time = T_e*(0:(N-1))';

sim CE1
y = simout.data;

u_hat = zeros(P, 1);
y_hat = zeros(P, 1);
for i = 0:3
    u_hat = u_hat + fft(u(1+i*P:(i+1)*P));
    y_hat = y_hat + fft(y(1+i*P:(i+1)*P));
end
u_hat = u_hat/4;
y_hat = y_hat/4;
g_hat = y_hat./u_hat;

x = (2*pi/T_e)/P*(0:P-1);

sys = frd(g_hat, x, 2*pi/T_e);
bode(sys, x)
hold on
sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e);
bode(sysd, x)