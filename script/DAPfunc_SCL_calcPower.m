function [power, conf] = DAPfunc_SCL_calcPower (movieSCL, conf)
 
%% remove outliers �޳���ֵ���ݣ�z��������3�����ݣ�����Ϊƽ��ֵ+3��std��
%% �����㷨���������ж�z�����ľ���ֵ�����²������ݵ�z�����Ǵ���3����С��-3��������Ϊƽ��ֵ+3��std�������Ǵ���3������Ϊmean+3*std�����޺�С��-3����Ϊmean-3*std�����ޡ�
%% ��Ȼ���������ź���˵�������м�Сֵ��һ���Ϊ����ֵ��eg:�Ŷ���ʱ�򣩡�
%% ���Ҫ���ݾ�������������õĻ�������ʹ������Script
%%
SCL(1, z_SCL>=3) = mean (SCL(1, remainMsk_SCL==1)) + 3*std(SCL, [], 2);
SCL(1, z_SCL<=-3) = mean (SCL(1, remainMsk_SCL==1)) - 3*std(SCL, [], 2);
%%
SCL = movieSCL.SCL(3, :);
len_SCL = length(SCL);
 
z_SCL = (SCL-repmat(mean(SCL, 2), 1, len_SCL))./repmat(std(SCL, [], 2), 1, len_SCL);
 
remainMsk_SCL = abs(z_SCL)<=3;
 
basepnts = round (conf.baseDuration*1000/conf.interval);
 
remainMsk_base = remainMsk_SCL(1:basepnts);
remainMsk_power = remainMsk_SCL;
remainMsk_power(1:basepnts) = 1;
 
SCL(1, remainMsk_base==0) = mean (SCL(1, remainMsk_SCL==1));
SCL(1, remainMsk_power==0) = mean (SCL(1, remainMsk_SCL==1)) + 3*std(SCL, [], 2);
 
%% calc power
SCL = SCL.*10^-4;
power = SCL.^2;
 
power = power(basepnts+1:end)-mean(power(1:basepnts));
