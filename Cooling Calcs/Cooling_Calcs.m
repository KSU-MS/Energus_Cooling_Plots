%% Cooling Calcs

% import data from teams (RMS for most accurate temp data, AVG for Energy)

%hacked

% Import data in order from right to left (RMS, AVG, FC)
% will add suffixes after RMS import

End_time = 1649; % Enter Endurance time to whole seconds
%% Vehicle Battery Parameters for Endurance (30mins)

figure(1)
hold on
plot(Time,OpenCircuitV1)
plot(Time,CloseCircuitC1)
ylabel('Voc , Vcc , [V]')

yyaxis right
plot(Time,Current)
plot(Time,SoE1)
ylabel("Current [A] , SoE [%}")
yline(0,'-',{'0% SoE'})

xlabel('Time (s)')
xline(End_time,'-',{'Endurance','Time'});
title('Voc, Vcc, Current, SoE')
legend('Vcc','Voc','Current','SoE')
hold off

%% Thermal Mass Calculations Heat Calcs

figure(2)


t = find(Temp(:,1)<55);
temp_max = length(t);                       %find when thermal mass reaches 55C

hold on

plot(Time,Temp)
ylabel('Temp [C]')
plot(Time,Current)
plot(Time,SoE1)
ylabel('Soe [%} , Current [A] , Temp [C]')
yline(0,'-',{'0% SoE'})                     % 0 SoE

xline(End_time,'-',{'Endurance','Time'});   % Endurance Time
xline(temp_max,'-',{'55C'});                % 55C Time
xlabel('Time [s]')
title('THERMAL MASS ONLY: Temp , Current , SoE')
legend("Temp","Current","SoE")


% Plots with Heat generation values [Thermal Mass]-------------------------

figure(3)
hold on

plot(Time,Temp)
ylabel('Temp [C]')
plot(Time,Current)
ylabel('Current [A] , Temp [C]')


yyaxis right
plot(Time,HeatGeneration)
plot(Time,HeatEnergy)
ylabel("Qgen [kW] , Q [kJ]")

xline(temp_max,'-',{'55C'});                % 55C Time
xlabel('Time [s]')
title('THERMAL MASS ONLY: Heat Generation Plots')
legend("Temp","Current","Heat Generation","Heat Energy")

%% Forced Convection Heat Calcs

figure(4)


t_fc = find(Temp2(:,1)<55);
tempfc_max = length(t_fc);                  %find time when thermal mass reaches 55C

hold on

plot(Time,Temp2)
ylabel('Temp [C]')
plot(Time,Current2)
plot(Time,SoE1)
ylabel('Soe [%} , Current [A] , Temp [C]')
yline(0,'-',{'0% SoE'})                     % 0 SoE

xline(End_time,'-',{'Endurance','Time'});   % Endurance Time
xline(tempfc_max,'-',{'55C'});              % 55C Time
xlabel('Time [s]')
title('Forced Convection: Temp , Current , SoE')
legend("Temp","Current","SoE")

% Plots with Heat generation values [Forced Convection]--------------------

figure(5)
hold on

plot(Time,Temp2)
ylabel('Temp [C]')
plot(Time,Current2)
ylabel('Current [A] , Temp [C]')

yyaxis right
plot(Time,HeatGeneration2)
plot(Time,FanCooling)
plot(Time,HeatEnergy2,'LineWidth',2)
ylabel("Qgen [kW] , Qfan [kW] , Q [kJ]")

xline(tempfc_max,'-',{'55C'});                % 55C Time
xlabel('Time [s]')
title('Forced Convection: Heat Generation Plots')
legend("Temp","Current","Heat Generation [Qgen]","Fan Cooling [Qfan]","Heat Energy")
