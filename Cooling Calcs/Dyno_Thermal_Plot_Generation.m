clc;
clear all;
warning off
% this script takes in the formated cell temperatures from the staeady state
% dyno test to plot against time and to confirm thermal model

[filename, pathname] = uigetfile('*.csv');
disp(filename);

% Read the CSV file
raw_data = readtable(fullfile(pathname, filename));

interp_data = table;
for col = 1:width(raw_data)
    interp_data.(raw_data.Properties.VariableNames{col}) = fillmissing(raw_data.(col), 'pchip');
end

column_names = raw_data.Properties.VariableNames;

for i = 1:length(column_names)
    column_name = column_names{i};
    eval([column_name ' = table2array(interp_data(:,' num2str(i) '));']);
end

disp('.csv variables imported');

%Convert Unix 
Time = Time./1000;
dateTime = datetime(Time, 'ConvertFrom', 'posixtime');
realTime = zeros(size(dateTime, 1), 1);
for i = 1:size(dateTime, 1)
        realTime(i) = seconds(dateTime(i) - dateTime(1));
end

%% Plots
scatter(realTime,High_Temperature);
hold on
scatter(realTime,Low_Temperature);
ylabel("Cell Temp (C)")
xlabel("Time (s)")
yyaxis right
scatter(realTime,D2_Motor_Speed);
ylabel("RPM")
legend("Low Temperature","High Temperature","D2 MotorSpeed")



