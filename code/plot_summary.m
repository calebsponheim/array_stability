

% addpath(genpath(pwd));
% clear; close all


%% change this to Z:\ for Rebecca's PC or yours
params.dataDirServer = '\\prfs.cri.uchicago.edu\nicho-lab\';
% params.dataDirServer = '/volumes/nicho-lab/';
% params.dataDirServer = 'Z:\';

%% choose monkey and array
params.monkeyIN = ' ';
params.xls2read = [params.dataDirServer 'Leda Pentousi\all_files2_CS.xlsx'];
sheets_to_read = xl_xlsfinfo(params.xls2read);
sheets_to_read = sheets_to_read(5:end);

for iSheet = 1:length(sheets_to_read)
    params.arrayIN = sheets_to_read{iSheet};
    params.sheet2read =  sheets_to_read{iSheet};
    % params.xls2read = [params.dataDirServer 'Leda Pentousi\Excel dates\' params.monkeyIN '.xlsx'];
    % params.xls2read = [params.dataDirServer 'Leda Pentousi\all_files2_CS.xlsx'];
    plot_summary_function(params);
end
