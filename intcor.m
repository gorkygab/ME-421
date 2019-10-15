function [R, h] = intcor(u, y)
L = length(u);
N = length(y);
M = lcm(L, N);
h = 0:M-1;
R = zeros(M, 1);
u = repmat(u, [M/L, 1]);
y = repmat(y, [M/N, 1]);

for i = h
    R(i+1) = u'*circshift(y, i);
end
R = R/M;
h = h';
end