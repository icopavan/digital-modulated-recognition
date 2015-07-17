function type = recognize(signal)

% high cumulation
C20 = @(s) (sum(s.^2) / length(s));
C21 = @(s) (sum(abs(s).^2) / length(s));
C40 = @(s) (sum(s.^4) / length(s) - 3*C20(s)^2);
C41 = @(s) (sum((s.^3).*conj(s)) / length(s) - 3*C20(s)*C21(s));
C42 = @(s) (sum(abs(s).^4) / length(s) - abs(C20(s))^2 - 2*C21(s)^2);
C60 = @(s) (sum(s.^6) / length(s) - 15*(sum(s.^4) / length(s))*C20(s) - 30*C20^3);
C63 = @(s) (sum(abs(s).^6) / length(s) - 9*C42(s)*C21(s) - 6*C21(s)^3);

% 以0.6作为判决基准
flag = 0.6;
f = (abs(C42(signal)))^2;

% flag = 2.5;
% f = abs(C63(signal)) / abs(C21(signal))^3;

if f > flag
    type = recognize_MPSK(signal);
else 
    type = recognize_MQAM(signal);
end

end


