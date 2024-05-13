clc;
clear;
warning off

% Step 1: Specify folder containing CSV files
folder = 'E:\(BAD) 3-21-24_Energus CalCurve\parsed-data';

% Step 2: Get a list of CSV files in the folder
fileList = dir(fullfile(folder, '*.csv')); % Get list of CSV files

% Initialize cell array to store data from all files
dataCellArray = cell(1, numel(fileList));

% Step 3: Loop through files and import data
for i = 1:numel(fileList)
    % Read data from CSV file
    filename = fullfile(folder, fileList(i).name);
    data = readtable(filename); % Use readtable for structured data
    
    % Store data in cell array
    dataCellArray{i} = data;
end

% Step 4: Combine data
% Example: Concatenate tables vertically (assuming all tables have the same variables)
combinedData = vertcat(dataCellArray{:});

% Read the CSV file
raw_data = combinedData;

% Interpolated Data Creations
interp_data = table;
for col = 1:width(raw_data)
    interp_data.(raw_data.Properties.VariableNames{col}) = fillmissing(raw_data.(col), 'pchip');
end

% Extract column names
column_names = raw_data.Properties.VariableNames;

% Create variables for each column
for i = 1:17
    column_name = column_names{i};
    eval([column_name ' = table2array(interp_data(:,' num2str(i) '));']);
end


disp('CELL DATA IMPORTED');

cell_1 = cell37temp;
cell_2 = cell38temp;
cell_3 = cell39temp;
cell_4 = cell40temp;
cell_5 = cell41temp;
cell_6 = cell42temp;
cell_7 = cell43temp;
cell_8 = cell44temp;
cell_9 = cell45temp;
cell_10 = cell46temp;
cell_11 = cell47temp;
cell_12 = cell48temp;

%Convert Unix to Time array
unixTime = Time./1000;

disp('TIME CONVERTED')

% KEYSIGHT DATA IMPORT

folder = 'E:\(BAD) 3-21-24_Energus CalCurve\DAQ970A\Keysight Data';

fileList = dir(fullfile(folder, '*.csv')); 

dataCellArray = cell(1, numel(fileList));

for i = 1:numel(fileList)
    filename = fullfile(folder, fileList(i).name);
    data = readtable(filename);
    % Store data in cell array
    dataCellArray{i} = data;
end

KEYSIGHT_COMBINED = vertcat(dataCellArray{:});

raw_data = KEYSIGHT_COMBINED;

% Interpolated Data Creations
interp_data = table;
for col = 1:width(raw_data)
    interp_data.(raw_data.Properties.VariableNames{col}) = fillmissing(raw_data.(col), 'pchip');
end
% Extract column names
column_names = raw_data.Properties.VariableNames;
% Create variables for each column
for i = 1:7
    column_name = column_names{i};
    eval([column_name ' = table2array(interp_data(:,' num2str(i) '));']);
end

KEYSIGHT_UNIX = zeros(size(Time));

% Loop through each datetime object and convert to Unix time
for i = 1:numel(Time)
    KEYSIGHT_UNIX(i) = posixtime(Time(i));
end

disp('KEYSIGHT DATA IMPORTED')

commonTime = min(unixTime):1:max(unixTime);

for i=1:size(Chan101_C_)
    avg_cell_temp(i) = (Chan101_C_(i) + Chan102_C_(i) + Chan103_C_(i) + Chan104_C_(i))/4;
end
% Interpolate voltage and temperature onto the common time
interpVoltage = interp1(unixTime, cell_6, commonTime, 'pchip');
interpTemperature = interp1(KEYSIGHT_UNIX, avg_cell_temp, commonTime, 'pchip');

% Plot V x Temp
figure;
plot(interpVoltage, interpTemperature);
xlabel('Voltage');
ylabel('Temperature');
title('Voltage vs Temperature');
grid on;

% Polyfit
degree = 6; % Change the degree of the polynomial as needed
coefficients = polyfit(interpVoltage, interpTemperature, degree);

fitVoltage = linspace(min(interpVoltage), max(interpVoltage), 100); % Adjust the number of points as needed
fitTemperature = polyval(coefficients, fitVoltage);

hold on;
plot(fitVoltage, fitTemperature, 'r-', 'LineWidth', 2);
legend('Data', 'Polynomial Fit');
hold off;

eqn = sprintf('Fit: y = %.4f*x^6 + %.4f*x^5 + %.4f*x^4 + %.4f*x^3 + %.4f*x^2 + %.4f*x + %.4f', coefficients);
disp(eqn)

%%plot raw
figure;
plot(unixTime,cell_6)
hold on 
grid on
plot(unixTime,cell_1)
plot(unixTime,cell_3)
plot(unixTime,cell_4)
plot(unixTime,cell_10)
xlabel('Unix Time')
ylabel('voltage')
yyaxis right
plot(KEYSIGHT_UNIX,Chan105_C_);
plot(KEYSIGHT_UNIX,Chan101_C_);
plot(KEYSIGHT_UNIX,Chan102_C_);
plot(KEYSIGHT_UNIX,Chan103_C_);
plot(KEYSIGHT_UNIX,Chan104_C_);
ylabel('Temp (C)');
legend('cell 6','cell 1','cell 3','cell 4','cell 10','Ambient Temp','cell temp 1','cell temp 2','cell temp 3','cell temp 4');
title('unix time v voltage and temperature')
