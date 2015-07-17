% test_MPSK_4_high_cum

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

% step 3
% initialize
snr = -10:100;
signal_type = {'BPSK', 'QPSK', '8PSK'};
color = 'bgrcmykw';
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
        rate(1,j-snr(1)+1) = abs(C40(signal)) / abs(C42(signal));
        rate(2,j-snr(1)+1) = abs(C41(signal)) / abs(C42(signal));
    end
    subplot(121);hold on;
    plot(snr(1):snr(end), rate(1, 1:length(snr)), [color(i), '-', symbol(i)]);
    subplot(122);hold on;
     plot(snr(1):snr(end), rate(2, 1:length(snr)), [color(i), '-', symbol(i)]);
    
end
subplot(121); 
xlabel('信噪比 snr dB');
axis([snr(1) snr(end) -0.1 1.4]);
ylabel('f1');title('f1');
legend(signal_type);

subplot(122);
xlabel('信噪比 snr dB');
axis([snr(1) snr(end) -0.1 1.4]);
ylabel('f2');title('f2');
legend(signal_type);

