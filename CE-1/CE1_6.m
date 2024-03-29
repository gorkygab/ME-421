T_e = 0.1;
N = 2000;
p = 1;
%u = normrnd(0, 0.2, N, 1);
%u = rand(N, 1) - 0.5;
u = prbs(8,20);
u=u(1:2000,:);
%u = prbs(N,p);
M = 100;
%Hann window:
%f = [0.5 + 0.5*cos(pi/M*(0:M)) zeros(1, N-M-1)]';
f = ones(N,1);
%number of blocks:
m = 50; 

simin.signals.values = u;
simin.time = T_e*(0:(N-1))';

out = sim('CE1', 'StopTime', num2str((N - 1)*T_e));
y = out.simout.data;

phi_hat_yu = zeros(N/m, 1);
phi_hat_uu = zeros(N/m, 1);

for i = 0:m-1
    phi_hat_yu = phi_hat_yu + fft(intcor(y(1+i*N/m:(i+1)*N/m), u(1+i*N/m:(i+1)*N/m)).*f(1:N/m));
    phi_hat_uu = phi_hat_uu + fft(intcor(u(1+i*N/m:(i+1)*N/m), u(1+i*N/m:(i+1)*N/m)).*f(1:N/m));
end

phi_hat_yu = phi_hat_yu/m;
phi_hat_uu = phi_hat_uu/m;

G_hat = phi_hat_yu./phi_hat_uu;
x = (2*pi/T_e)/(N/m)*(0:(N/m)-1);

hold on

sys = frd(G_hat, x);
bode(sys, x)

sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e);
bode(sysd, x)