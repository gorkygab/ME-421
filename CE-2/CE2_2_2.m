%% Init
load('CE2.mat')
N = length(u);
t = (0:N-1)*Te;

%% 1
training_ratio = 0.5;

u_training = u(1:floor(training_ratio*N));
y_training = y(1:floor(training_ratio*N));
data_training = iddata(y_training, u_training, Te);
data_training = detrend(data_training);
N_training = length(u_training);

u_testing = u(floor(training_ratio*N)+1:end);
y_testing = y(floor(training_ratio*N)+1:end);
data_testing = iddata(y_testing, u_testing, Te);
data_testing = detrend(data_testing);
N_testing = length(u_testing);

%% 2
n = 5;
na = 5;
nb = 5;
nc = na;
nd = na;
nf = na;
nk = 1;

sys_arx = arx(data_training, [na nb nk]);
sys_iv4 = iv4(data_training, [na nb nk]);
sys_armax = armax(data_training, [na nb nc nk]);
sys_oe = oe(data_training, [nb nf nk]);
sys_bj = bj(data_training, [nb nc nd nf nk]);
sys_n4sid = n4sid(data_training, n);

%% 3
compare(data_testing, sys_arx, sys_iv4, sys_armax, sys_oe, sys_bj, sys_n4sid)

%% 4
data = iddata(y, u, Te);
data = detrend(data);

U = fft(data.u);
Y = fft(data.y);

threshold = 0.1*max(U);
non_zeros = abs(U) > threshold;

G = Y(non_zeros)./U(non_zeros);
frqs = (0:N-1)*2*pi/Te/N;
frqs = frqs(non_zeros);

sys = frd(G', frqs);

%% 5
figure
bode(sys, sys_arx, sys_iv4, sys_armax, sys_oe, sys_bj, sys_n4sid, frqs)
axes_handles = findall(gcf, 'type', 'axes');
legend(axes_handles(3), {'Ref', 'ARX', 'IV4', 'ARMAX', 'OE', 'BJ', 'N4SID'}, 'Location', 'southwest', 'NumColumns', 2)

mag_ref = bode(sys, frqs);
mag_arx = bode(sys_arx, frqs);
mag_iv4 = bode(sys_iv4, frqs);
mag_armax = bode(sys_armax, frqs);
mag_oe = bode(sys_oe, frqs);
mag_bj = bode(sys_bj, frqs);
mag_n4sid = bode(sys_n4sid, frqs);

J_arx = sum((mag_arx - mag_ref).^2)
J_iv4 = sum((mag_iv4 - mag_ref).^2)
J_armax = sum((mag_armax - mag_ref).^2)
J_oe = sum((mag_oe - mag_ref).^2)
J_bj = sum((mag_bj - mag_ref).^2)
J_n4sid = sum((mag_n4sid - mag_ref).^2)

%% 6
figure
resid(data_testing, sys_arx)
title('Residue Correlation for ARX')

figure
resid(data_testing, sys_iv4)
title('Residue Correlation for IV4')

figure
resid(data_testing, sys_armax)
title('Residue Correlation for ARMAX')

figure
resid(data_testing, sys_oe)
title('Residue Correlation for OE')

figure
resid(data_testing, sys_bj)
title('Residue Correlation for BJ')

figure
resid(data_testing, sys_n4sid)
title('Residue Correlation for N4SID')