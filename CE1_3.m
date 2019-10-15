T_e = 0.1;
N = 400;
K = 100;
M = 1000;

THETA_MEAN = zeros(1, K);
for i = 1:M
    simin.signals.values = rand(400,1) - 0.5;
    U = toeplitz(simin.signals.values, [simin.signals.values(1) zeros(1, N-1)]);
    simin.time = T_e*(0:(N-1))';
    sim CE1
    THETA = (U(:,1:K)'*U(:,1:K))\U(:,1:K)'*simout.data(1:end-1);
    THETA_MEAN = THETA_MEAN + THETA;
end

THETA_MEAN = THETA_MEAN/M;

hold on
plot(simin.time(1:K), THETA_MEAN/T_e, 'r')

sys = tf([-1 3], [1 1.12 2]);
sysd = c2d(sys, T_e);
impulse(sysd)