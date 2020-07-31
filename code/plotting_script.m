%% Plotting Script

% this script plots each array's data separately, into a plot per array.
% used to examine individual lifespans. 

%% First, Load Data

load('C:\Users\calebsponheim\Documents\git\array_stability\data\array_data.mat','array_data');

%% Per-Subject Summary Plot


plot_summary_function(array_data)


%% Plot all array lines on top of one another

% this plots ALL of the data, with a linear regression for each array. It's
% a pretty chaotic graph.

plot_all_data(array_data)