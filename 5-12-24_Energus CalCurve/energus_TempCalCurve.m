clc;
clear all;
warning off;
%% Calibration Curve 
% This script takes in data from the keysight logger to plot temp v voltage
% and to get a calibration curve for the energus temp sensors

% make sure to match channel names to excel and convert scientific data to
% general form in the raw file.

%read data into struct
data = readtable("C:\Users\bw_gr\Documents\GitHub\Battery-Pack-Thermal-Model\5-12-24_Energus CalCurve\MY58032496_20240512_200522079\dat00001.csv");

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
coeff_str = sprintf('%.4f', coefficients(end));
for i = length(coefficients)-1:-1:1
    coeff_str = [coeff_str ' + ' sprintf('%.4f', coefficients(i)) 'x^' num2str(length(coefficients)-i)];
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

%% Specific Heat Capacity Calculation

logFrq = 0.1; % Hz
timeStep = 1/logFrq; % Log interval in seconds
mass = (48 * 8)/1000; % Cell mass * particle count


threshold_1_indices = find(threshold_indices == 1);
numIndices = length(threshold_1_indices);
specificHeatCapacity = zeros(numIndices - 1, 1); % Cp J/kg°C
heatEnergy = zeros(numIndices - 1, 1); % Joules

T_ambient = zeros(numIndices,1);
T_body = zeros(numIndices,1);
T_delta = zeros(numIndices,1);
timeSoak = zeros(numIndices,1);

for i = 2:numIndices
    T_ambient(i) = ambientTemp(threshold_1_indices(i));
    T_body(i) = ambientTemp(i)-5;
    T_delta(i) = T_ambient(i) - T_body(i); % Delta temperature
    
    if T_delta(i) == 0
        T_delta(i) = 5; % Set a minimum delta T to avoid division by zero
    end
    
    time1 = threshold_1_indices(i);
    time2 = threshold_1_indices(i-1);

    timeSoak(i) = (time1 - time2) * timeStep; % Calculate time soak in seconds
    
    heatEnergy(i) = mass * ((T_delta(i)) / (timeSoak(i)));

    specificHeatCapacity(i) = heatEnergy(i) / ((T_delta(i)) * mass);
end


% Plot specific heat capacity
figure(3);
scatter(1:numIndices, specificHeatCapacity, 'b');
hold on;
grid on;
xlabel('Index');
ylabel('Specific Heat Capacity (J/kg°C)');
yyaxis right;

scatter(1:numIndices, T_ambient, 'g');
scatter(1:numIndices, T_body, 'r');


ylabel('Temp (°C)');
legend("CP",'Ambient', 'Body');
title('Specific Heat Capacity and Temperature vs. Index');








