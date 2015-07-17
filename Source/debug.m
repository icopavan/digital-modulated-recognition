% debug
Tx.SampleRate = 32e9; % symbol Rate，信号的码元速率，可以自行定义
Tx.Linewidth = 0;% 发射信号的载波的线宽，一般与信号的相位噪声有关，大小可自行设置，这里暂时设置为0
Tx.Carrier = 0;% 发射信号的载波频率，可自行设置，这里暂设为0

ra = 0.04;
delta = 0.1;

signal1 = generate_signal('2FSK', 50, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, 400);
% [cn c] = sub_clust(signal1, ra, delta);
subplot(121)
% plot(signal1, '.'); hold on; plot(c, 'r*');
plot(psd(signal1));


signal2 = generate_signal('4FSK', 50, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, 400);
% [cn c] = sub_clust(signal2, ra, delta);
subplot(122)
% plot(signal2, '.'); hold on; plot(c, 'r*');
plot(psd(signal2));




