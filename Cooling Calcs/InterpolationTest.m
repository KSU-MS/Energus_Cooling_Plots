clc;
clear;
warning off

f = readtable(['temps_real_NoFans.csv']);
f = table2array(f);

high_temp = f(:,4);
y = isnan(high_temp);
high_temp = high_temp(~y)';
low_temp = f(:,5);
low_temp = low_temp(~y)';
%pack_current = f(:,6)';
%pack_sum_voltage = f(:,7)';
time = f(:,8)';
time = time(~y);
index = 1:100;

v1 = interp1(time, high_temp, index, "cubic");
%plot(time, high_temp, 'r')
%hold on
%plot(time, low_temp, 'y')

plot(time,high_temp,'or',index,v1,'k'); %title('linear');