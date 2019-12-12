%% Init
load('CE2.mat')
N = length(u);
t = (0:N-1)*Te;

data = iddata(y, u, Te);
data = detrend(data);

%% 1
U = fft(data.u);
Y = fft(data.y);

threshold = 0.1*max(U);
non_zeros = abs(U) > threshold;

G = Y(non_zeros)./U(non_zeros);
frqs = (0:N-1)*2*pi/Te/N;
frqs = frqs(non_zeros);

sys = frd(G', frqs);
bode(sys)

%% 2
loss_func = zeros(1, 10);
for n = 1:10
    sys_arx = arx(data, [n n 1]);
    loss_func(n) = sys_arx.EstimationInfo.LossFcn;
end

figure
plot(loss_func)

%% 3
for n = 4:7
    sys_armax = armax(data, [n n n 1]);
    figure
    hold on
    h = iopzplot(sys_armax);
    showConfidence(h, 2)
end

%% 4
n = 5;
sys_armax = armax(data, [n, n, n, 1]);

figure
errorbar(sys_armax.b, sys_armax.db)

figure
hold on
for i = 1:n
    model = arx(data, [5 i 1]);
    plot(i, model.EstimationInfo.LossFcn, '*')
end

%% 5

NN = struc(1:5, 1:5, 1);
V = arxstruc(data, data, NN);
selstruc(V);