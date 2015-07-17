% test_phase

% step 1
clear all;
close all;


% step 2
% initialize
times = 200; % 独立仿真次数
snr = 10;
signal_type = {'64QAM'};
color = 'bgrcmykb';
symbol = 'o*sdph+x';
n = length(signal_type);
Tx.SampleRate = 32e9; % symbol Rate，信号的码元速率，可以自行定义
Tx.Linewidth = 0;% 发射信号的载波的线宽，一般与信号的相位噪声有关，大小可自行设置，这里暂时设置为0
Tx.Carrier = 0;% 发射信号的载波频率，可自行设置，这里暂设为0
Tx.data_num = 400; % 数据点个数

Linewidth = 0:1:90;



% step 3
% 识别并判断
figure; hold on; grid on;
for i = 1 : n
    disp(signal_type(i));

        
        for t = 1 : length(Linewidth)
            correct = 0;
            for k = 1 : times
                type = signal_type(i);
                type = type{1};
                signal = generate_signal(type, snr, Tx.SampleRate, Linewidth(t), Tx.Carrier, Tx.data_num);
                rtype = recognize(signal);

                if judge(type, rtype)
                    correct = correct + 1;
                end
            end
            rate(t) = correct / times * 100;
        end
  
    plot(Linewidth, rate);
  
    
end
axis([Linewidth(1) Linewidth(end) 0 100]);
xlabel('相位差');
ylabel('识别正确率 % ');
legend(signal_type);

