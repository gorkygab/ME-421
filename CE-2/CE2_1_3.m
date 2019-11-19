load('laserbeamdataN.mat')
N = length(u);
f = 1000;
t = (0:N-1)/f;
r = 10;

y_aug = [y; zeros(r - 1, 1)];
u_aug = [u; zeros(r - 1, 1)];

Y = zeros(r, N);
U = zeros(r, N);

for k = 1:N
    Y(:,k) = y_aug(k:k+r-1);
    U(:,k) = u_aug(k:k+r-1);
end
U_ort = eye(N) - U'/(U*U')*U;

% Y = zeros(r, N - r);
% U = zeros(r, N - r);
% 
% for k = 1:(N - r + 1)
%     Y(:,k) = y(k:k+r-1);
%     U(:,k) = u(k:k+r-1);
% end
% U_ort = eye(N - r + 1) - U'/(U*U')*U;

Q = Y*U_ort;
S = svd(Q);
O_r = Q(:,S > S(1)/10);
n = size(O_r, 2);

C_hat = O_r(1,:);
A_hat = O_r(1:r-1,:)\O_r(n:end,:);

q = tf('z', 1/f);
sys_u = C_hat/(q*eye(n) - A_hat);
u_f = [lsim(sys_u(1), u) lsim(sys_u(2), u)];

phi = u_f;
B_hat = (phi'*phi)\phi'*y;

sys = ss(A_hat, B_hat, C_hat, 0, 1/f);
y_hat = lsim(sys, u);

hold on
plot(t, y_hat, 'r')
plot(t, y, 'b')
title('System Output')
legend({'$y$', '$\hat{y}$'},'Interpreter','latex')
xlabel('Time [s]')
ylabel('Beam position [m]')

J = sum((y - y_hat).^2, 1);