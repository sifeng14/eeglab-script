function [power, conf] = DAPfunc_SCL_calcPower (movieSCL, conf)
 
%% remove outliers 剔除极值数据（z分数大于3的数据，设置为平均值+3个std）
%% 但是算法的问题是判断z分数的绝对值，导致不管数据的z分数是大于3或者小于-3，都设置为平均值+3个std，而不是大于3的设置为mean+3*std的上限和小于-3设置为mean-3*std的下限。
%% 当然对于生理信号来说，很少有极小值，一般均为极大值（eg:脚动的时候）。
%% 如果要根据具体情况进行设置的话，可以使用以下Script
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
