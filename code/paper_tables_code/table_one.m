function table_one()
% Script Description

%% Load
subject_array_info = readtable('.\data\subject_info_data.csv');
subject_array_info_cropped = subject_array_info(:,[2,4:end]);
%% Writing to pre-formatted excel doc

subject_array_info_cropped.Properties.VariableNames = ...
    {'Array Name' 'Brain Area' 'Implant Date' 'Electrode Length' 'Array Size' 'Metallization' 'Number of Recordings'};
formatted_table_filename = '.\figures\paper_figures\table_one.xlsx';

writetable(subject_array_info_cropped,formatted_table_filename,'Sheet',1,'Range','A1')

% formatted_table_filename_onedrive = 'C:\Users\calebsponheim\OneDrive - The University of Chicago\table_one.xlsx';
% writetable(subject_array_info_cropped,formatted_table_filename_onedrive,'Sheet',1,'Range','A1')

end