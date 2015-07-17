% the main script

% step 1
clear all;
% clc;
close all;

% step 2
% 初始化参数
times = 200; % 独立仿真次数
snr = 0:100; % 信噪比范围
% signal_type = {'16QAM', '64QAM'};
signal_type = {'BPSK', 'QPSK', '8PSK', '8QAM', '16QAM', '64QAM'};
color = 'bgrcmykb'; % 画图颜色
symbol = 'o*sdph+x'; % 画图线型
n = length(signal_type); 
rate = zeros(1,200);
type = '';
Tx.SampleRate = 32e9; % symbol Rate，信号的码元速率，可以自行定义
Tx.Linewidth = 0;% 发射信号的载波的线宽，一般与信号的相位噪声有关，大小可自行设置，这里暂时设置为0
Tx.Carrier = 10000;% 发射信号的载波频率，可自行设置，这里暂设为0
Tx.data_num = 400; % 数据点个数

% step 3
% 识别并判断
figure; hold on; grid on;
for i = 1 : n
    disp(signal_type(i));
    for j = snr(1) : snr(end)
        correct = 0;
        for k = 1 : times
            type = signal_type(i);
            type = type{1};
            signal = generate_signal(type, j, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, Tx.data_num);
            rtype = recognize(signal);
           
            if judge(type, rtype)
                correct = correct + 1;
            else
%                 if strcmpi(type, '16qam')
%                     disp(rtype);
%                     disp(length(subclust(abs(signal'), 0.15)));
%                 end
            end
        end
        rate(j-snr(1)+1) = correct / times * 100;
    end
    plot(snr(1):snr(end), rate(1:length(snr)), [color(i), '-', symbol(i)]);
    
end
axis([snr(1) snr(end) 0 100]);
xlabel('信噪比 snr dB');
ylabel('识别正确率 % ');
legend(signal_type);


