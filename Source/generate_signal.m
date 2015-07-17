function signal = generate_signal(type, snr, sampleRate, lineWidth, carrier, data_n)
% 产生调制信号 （类型，信噪比，码元速率，线宽，载波频率，数据点个数）

% step 1
% initialize
type = upper(type); % 大写
if length(type) == 4
    if strcmp(type(1), 'Q')
        n = 4;   
        style = type(2:4);
    elseif strcmp(type(1), 'B')
        n = 2;
        style = type(2:4);
    else
        n = str2double(type(1));
        style = type(2:4);
    end
elseif length(type) == 5
    n = str2double(type(1:2));
    style = type(3:5);
elseif length(type) == 6
    n = str2double(type(1:3));
    style = type(4:6);
else
    error('error input in generate_signal');
    return;
end

% step 2
% 设置参数
System.BitPerSymbol = log2(n); % 码元位

Tx.SampleRate = sampleRate; % symbol Rate，信号的码元速率，可以自行定义
Tx.Linewidth = lineWidth;% 发射信号的载波的线宽，一般与信号的相位噪声有关，大小可自行设置，这里暂时设置为0
Tx.Carrier = carrier;% 发射信号的载波频率，可自行设置，这里暂设为0
M = 2^System.BitPerSymbol;% 进制数

Tx.DataSymbol = randi([0 M-1],1,data_n);% 1*10000的0-M-1随机矩阵，每一次随机产生的数据量，这里暂时设为数据点个数为10000个

% step 3
% 调制
switch style
    case {'ASK'}


    case {'FSK'}
% fskmod函数  格式：y=fskmod(x,M,freq_sep,nsamp) y=fskmod(x,M,freq_sep,nsamp,Fs)  其中，x是消息信号；M是消息的符号数，必须是2的整数次幂，消息信号是0～M-1之间的整数；freq_sep是两载波频率之间的频率间隔，单位为Hz；nsamp是输出信号y中每符号的采样数，必须是大于1的正整数；Fs是采样频率，freq_sep和M必须满足（M-1）*freq_sep<=Fs。
            Tx.DataConstel = fskmod(Tx.DataSymbol, M, 10, 8, Tx.SampleRate);
    case {'PSK'}
            h = modem.pskmod('M', M, 'SymbolOrder', 'Gray'); % 格雷码
            Tx.DataConstel = modulate(h,Tx.DataSymbol); % 调制
    case {'QAM'}
        if M ~= 8
            h = modem.qammod('M', M, 'SymbolOrder', 'Gray'); % 格雷码
            Tx.DataConstel = modulate(h,Tx.DataSymbol); % 调制
        else % 这里把2^3（8QAM）的形式单独拿出来设置，是为了实现最优的星型8QAM星座图
            tmp = Tx.DataSymbol;
            tmp2  = zeros(1,length(Tx.DataSymbol));
            for kk = 1:length(Tx.DataSymbol)
                switch tmp(kk)
                    case 0
                        tmp2(kk) = 1 + 1i;
                    case 1
                        tmp2(kk) = -1 + 1i;
                    case 2
                        tmp2(kk) = -1 - 1i;
                    case 3
                        tmp2(kk) = 1 - 1i;
                    case 4
                        tmp2(kk) = 1+sqrt(3);
                    case 5
                        tmp2(kk) = 0 + 1i .* (1+sqrt(3));
                    case 6
                        tmp2(kk) = 0 - 1i .* (1+sqrt(3));
                    case 7
                        tmp2(kk) = -1-sqrt(3);
                end
            end
            Tx.DataConstel = tmp2;
            clear tmp tmp2;
        end
    otherwise
        error('error in generate signal');
        return;
end

% step 4
% 预处理
Tx.Signal = Tx.DataConstel;

% 数据的载波加载，考虑到相位噪声等
N = length(Tx.Signal);
dt = 1/Tx.SampleRate; % 采样定理何在？
t = dt*(0:N-1);
Phase1 = [0, cumsum(normrnd(0,sqrt(2*pi*Tx.Linewidth/(Tx.SampleRate)), 1, N-1))]; % 均值0 标准差 1xN-1 高斯随机 每列累加和
carrier1 = exp(1i*(2*pi*t*Tx.Carrier + Phase1));
Tx.Signal = Tx.Signal.*carrier1;

Rx.Signal = awgn(Tx.Signal,snr,'measured');% 加特定信噪比的噪声，数据在AWGN信道下的接收，‘measured’表示函数在噪声之前测定信号强度

CMAOUT = Rx.Signal;

% normalization接收信号功率归一化
CMAOUT=CMAOUT/sqrt(mean(abs(CMAOUT).^2));

% step 5
% 返回
% signal = Tx.Signal;
% signal = Rx.Signal;
signal = CMAOUT;

% plot(t, signal);

end