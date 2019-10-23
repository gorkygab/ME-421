simin.signals.values = [zeros(10,1); ones(990,1)];
simin.time = (0.1:0.1:100)';
out = sim('CE1', 'StopTime', '99.9');
plot(out.simout)

figure
simin.signals.values = [1; zeros(999,1)];
out = sim('CE1', 'StopTime', '99.9');
plot(out.simout)