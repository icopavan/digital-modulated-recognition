function type = recognize_MQAM(signal)

% high cumulation
C20 = @(s) (sum(s.^2) / length(s));
C21 = @(s) (sum(abs(s).^2) / length(s));
C40 = @(s) (sum(s.^4) / length(s) - 3*C20(s)^2);
C41 = @(s) (sum((s.^3).*conj(s)) / length(s) - 3*C20(s)*C21(s));
C42 = @(s) (sum(abs(s).^4) / length(s) - abs(C20(s))^2 - 2*C21(s)^2);

flag = 0.85;

f = (abs(C40(signal)) / abs(C21(signal))^2);

if (f > flag)
    type = '8QAM';
else 
    type = recognize_16QAM_64QAM(signal);
end

end