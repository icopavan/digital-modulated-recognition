function type = recognize_MPSK(signal)

% high cumulation
C20 = @(s) (sum(s.^2) / length(s));
C21 = @(s) (sum(abs(s).^2) / length(s));
C40 = @(s) (sum(s.^4) / length(s) - 3*C20(s)^2);
C41 = @(s) (sum((s.^3).*conj(s)) / length(s) - 3*C20(s)*C21(s));
C42 = @(s) (sum(abs(s).^4) / length(s) - abs(C20(s))^2 - 2*C21(s)^2);


f1 = abs(C40(signal)) / abs(C42(signal));
f2 = abs(C41(signal)) / abs(C42(signal));

% 以0.5作为判决基准
if f1 < 0.5
    f1 = 0;
else 
    f1 = 1;
end

if f2 < 0.5
    f2 = 0;
else
    f2 = 1;
end

if f1 == 1 && f2 == 1
    type = 'BPSK';
elseif f1 == 1 && f2 == 0
    type = 'QPSK';
elseif f1 == 0 && f2 == 0 % 其实>=8PSK也在这里的
    type = '8PSK';
else
    warning('off')
    warning('error in recognize_MPSK_high_cum!');
    type = 'none';
    warning('on')
end

end