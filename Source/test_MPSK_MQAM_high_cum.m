% % test_MPSK_MQAM_high_cum

% step 1
close all;
clear all;

% step 2
% high cumulation
C20 = @(s) (sum(s.^2) / length(s));
C21 = @(s) (sum(abs(s).^2) / length(s));
C40 = @(s) (sum(s.^4) / length(s) - 3*C20(s)^2);
C41 = @(s) (sum((s.^3).*conj(s)) / length(s) - 3*C20(s)*C21(s));
C42 = @(s) (sum(abs(s).^4) / length(s) - abs(C20(s))^2 - 2*C21(s)^2);
C60 = @(s) (sum(s.^6) / length(s) - 15*(sum(s.^4) / length(s))*C20(s) - 30*C20^3);
C63 = @(s) (sum(abs(s).^6) / length(s) - 9*C42(s)*C21(s) - 6*C21(s)^3);

% step 3
% initialize
snr = 0:100;
signal_type = {'BPSK', 'QPSK', '8PSK', '16PSK', '8QAM', '16QAM', '64QAM'};
color = 'bgrcmykb';
symbol = 'o*sdph+x';
n = length(signal_type);
rate = zeros(200);
type = '';
Tx.SampleRate = 32e9; % symbol Rate，信号的码元速率，可以自行定义
Tx.Linewidth = 0;% 发射信号的载波的线宽，一般与信号的相位噪声有关，大小可自行设置，这里暂时设置为0
Tx.Carrier = 0;% 发射信号的载波频率，可自行设置，这里暂设为0
Tx.data_num = 400;

% step 3
% 
figure(1); hold on; grid on;
for i = 1 : n
    for j = snr(1) : snr(end)
        type = signal_type(i);
        type = type{1};
        signal = generate_signal(type, j, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, Tx.data_num);
%         rate(1,j-snr(1)+1) = (abs(C40(signal)) / abs(C21(signal))^2);
        rate(1,j-snr(1)+1) = (abs(C42(signal)))^2;
%         rate(1,j-snr(1)+1) = abs(C63(signal))^2 / abs(C42(signal))^3;
%         rate(1,j-snr(1)+1) = abs(C63(signal)) / abs(C21(signal))^3;
    end
    plot(snr(1):snr(end), rate(1, 1:length(snr)), [color(i), '-', symbol(i)]);
    
end
xlabel('信噪比 snr dB');
axis([snr(1) snr(end) -0.1 1.4]);
ylabel('C42^2');
legend(signal_type);


