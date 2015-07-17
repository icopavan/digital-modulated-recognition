function [cn, c] = sub_clust(x, ra)
x0 = x;
x = abs(x);
rb = 1.5*ra;
cn = 1;
n = length(x);
xones = ones(1, n);
delta = 5;

D = zeros(1, n);
for i = 1:n
    D(i) = sum(exp(-(abs(xones*x(i) - x).^2)/((ra / 2)^2)));%(abs(0.5+0.5*j)^2)
end;
% for i = 1:n
%     for j =1:n
%         D(i) = D(i) + exp(-abs(x(i) - x(j))^2 / (ra / 2)^2);
%     end
% end

while max(D) > delta
    [Dc1, t] = max(D);
    c(cn) = x0(t);
    cn = cn+1;
    
    for i = 1:n
        D(i) = D(i) - Dc1 * exp(-abs(x(i)-x(t)) / (rb / 2)^2);
    end
end

end

