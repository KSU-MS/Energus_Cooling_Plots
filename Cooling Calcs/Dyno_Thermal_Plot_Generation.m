
clear;
warning off

[filename, pathname] = uigetfile('*.csv');
disp(filename);

% Read the CSV file
raw_data = readtable(fullfile(pathname, filename));

% Interpolated Data Creations
interp_data = table;
for col = 1:width(raw_data)
    interp_data.(raw_data.Properties.VariableNames{col}) = fillmissing(raw_data.(col), 'pchip');
end

% Extract column names
column_names = raw_data.Properties.VariableNames;

% Create variables for each column
for i = 1:length(column_names)
    column_name = column_names{i};
    eval([column_name ' = table2array(interp_data(:,' num2str(i) '));']);
end

disp('.csv variables imported');

%Convert Unix to Time array
Time = Time./1000;
dateTime = datetime(Time, 'ConvertFrom', 'posixtime');
realTime = zeros(size(dateTime, 1), 1);
for i = 1:size(dateTime, 1)
        realTime(i) = seconds(dateTime(i) - dateTime(1));
end

%% Plots
plot(realTime,High_Temperature);
hold on
plot(realTime,Low_Temperature);
ylabel("Cell Temp (C)")
xlabel("Time (s)")
yyaxis right
plot(realTime,D2_Motor_Speed);
ylabel("RPM")
legend("Low Temperature","High Temperature","D2 MotorSpeed")



