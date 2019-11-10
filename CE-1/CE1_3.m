T_e = 0.1;
N = 400;
K = 200;
M = 1;

simin.time = T_e*(0:(N-1))';
simin.signals.values = rand(N, 1) - 0.5;
U = toeplitz(simin.signals.values, [simin.signals.values(1) zeros(1, N-1)]);
out = sim('CE1', 'StopTime', num2str((N - 1)*T_e));
THETA = (U(:,1:K)'*U(:,1:K))\U(:,1:K)'*out.simout.data/T_e;

%%
hold on
plot(simin.time(1:K), THETA, 'r')
%%
sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e);
impulse(sysd, simin.time(1:K))
%%
true_theta = impulse(sysd, simin.time(1:K));
error = sqrt(sum((THETA - true_theta).^2));