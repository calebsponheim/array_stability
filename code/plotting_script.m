%% Plotting Script

%% First, Load Data

load('C:\Users\calebsponheim\Documents\git\array_stability\data\all_files_struct_CS.mat','array_data');

%% Per-Subject Summary Plot


plot_summary_function(array_data)


%% Plot all array lines on top of one another

plot_all_data(array_data)