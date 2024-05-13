clc;
clear all;
warning off;
%% Calibration Curve 
% This script takes in data from the keysight logger to plot temp v voltage
% and to get a calibration curve for the energus temp sensors

% make sure to match channel names to excel and convert scientific data to
% general form in the raw file.

%read data into struct
data = readtable("E:\5-12-24_Energus CalCurve\MY58032496_20240512_200522079\dat00001.csv");

column_names = data.Properties.VariableNames;
dataStruct = struct();

for i = 1:length(column_names)
    column_name = column_names{i};
    dataStruct.(column_name) = data.(column_name);
end

%convert struct to array
time = dataStruct.Time;
voltage = dataStruct.Chan101;
temp1 = dataStruct.Chan102;
temp2 = dataStruct.Chan103;
temp3 = dataStruct.Chan104;
temp4 = dataStruct.Chan105;
ambientTemp = dataStruct.Chan106;

avgTemp = (temp1+ temp2 + temp3 + temp4)/4;

figure(1);
scatter(voltage, avgTemp);
hold on;
scatter(voltage, ambientTemp)
xlabel('Voltage (V)');
ylabel('Temperature (°C)');
title('Temp v Voltage (RAW)');
legend("Cell Temp", "Ambient Temp")
grid on;
hold off

%% Curve Fit
delta_threshold = 0.5; %thermal soak thershold in C
threshold_indices = abs(avgTemp - ambientTemp) < delta_threshold;

voltage_groups = voltage(threshold_indices);
avgTemp_groups = avgTemp(threshold_indices);
ambientTemp_groups = ambientTemp(threshold_indices);

%ployfit
degree = 6; % adjust degree
coefficients = polyfit(voltage_groups, avgTemp_groups, degree);
voltage_range = linspace(min(voltage_groups), max(voltage_groups), 10000);
avgTemp_fit = polyval(coefficients, voltage_range);

%display eqn
coeff_str = sprintf('%.4f', coefficients(1));
for i = 2:length(coefficients)
    coeff_str = [coeff_str ' + ' sprintf('%.4f', coefficients(i)) 'x^' num2str(i-1)];
end
equation_str = ['eqn: ' coeff_str];
disp(equation_str);
%

figure(2);
scatter(voltage_groups,avgTemp_groups)
hold on;
scatter(voltage_groups, ambientTemp_groups)
plot(voltage_range, avgTemp_fit, 'r')
xlabel('Voltage (V)');
ylabel('Temperature (°C)');
title('PolyFit Graph');
legend("Cell Temp", "Ambient Temp")
grid on;
hold off



