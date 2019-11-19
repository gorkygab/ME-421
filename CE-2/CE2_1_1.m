load('laserbeamdataN.mat')
N = length(u);
f = 1000;
t = (0:N-1)/f;

m = 50;
phi = toeplitz(zeros(m, 1), [0; u(1:end-1)])';

theta_hat = (phi'*phi)\phi'*y;
y_hat = phi*theta_hat;

hold on
plot(t, y, 'b')
plot(t, y_hat, 'r')
title('System Output')
legend({'$y$', '$\hat{y}$'},'Interpreter','latex')
xlabel('Time [s]')
ylabel('Beam position [m]')

J = sum((y - y_hat).^2, 1);

sigma_2 = J/(N - m);
cov_theta_hat = sigma_2*inv(phi'*phi);

figure
errorbar(theta_hat, 2*(diag(cov_theta_hat).^0.5))
title('Impulse response')