function type = recognize_16QAM_64QAM(signal)

% 0.1 7
% 0.25 4
ra = 0.25;
flag = 4;
c = subclust(abs(signal'), ra);

n = length(c);
if n < flag
    type = '16QAM';
else 
    type = '64QAM';
end

end