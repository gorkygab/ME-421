load('laserbeamdataN.mat')
N = length(u);
f = 1000;
t = (0:N-1)/f;

m = 2;
n = 2;
phi = [toeplitz(zeros(n, 1), [0; -y(1:end-1)]); toeplitz(zeros(m, 1), [0; u(1:end-1)])]';

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

sys = tf(theta_hat(3:4)', [1 theta_hat(1:2)'], 1/f);
y_m = lsim(sys, u, t);

figure
hold on
plot(t, y, 'b')
plot(t, y_m, 'r')
title('System Output')
legend({'$y$', '$\hat{y}$'},'Interpreter','latex')
xlabel('Time [s]')
ylabel('Beam position [m]')

J_m = sum((y - y_m).^2, 1);

y_hat_iv = y_m;
for i = 1:10
    phi_iv = [toeplitz(zeros(n, 1), [0; -y_hat_iv(1:end-1)]); toeplitz(zeros(m, 1), [0; u(1:end-1)])]';

    theta_hat_iv = (phi_iv'*phi)\phi_iv'*y;
    sys = tf(theta_hat_iv(3:4)', [1 theta_hat_iv(1:2)'], 1/f);
    y_hat_iv = lsim(sys, u, t);
end

figure
hold on
plot(t, y, 'b')
plot(t, y_hat_iv, 'r')
title('System Output')
legend({'$y$', '$\hat{y}$'},'Interpreter','latex')
xlabel('Time [s]')
ylabel('Beam position [m]')

J_iv = sum((y - y_hat_iv).^2, 1);