u = prbs(6,4);
[R, h] = intcor(u, u);

plot(h, R)