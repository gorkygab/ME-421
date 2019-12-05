%% Init
load('CE2.mat')
N = length(u);
t = (0:N-1)*Te;

%% 1
training_ratio = 0.6;

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
resid(data_testing, sys_arx)
figure
resid(data_testing, sys_iv4)
figure
resid(data_testing, sys_armax)
figure
resid(data_testing, sys_oe)
figure
resid(data_testing, sys_bj)
figure
resid(data_testing, sys_n4sid)