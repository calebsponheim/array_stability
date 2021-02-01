% Run all Figure Code

% load current version of the data
load('C:\Users\calebsponheim\Documents\git\array_stability\data\array_data.mat')

%% Re-generate all figures

longterm_array_examples(array_data)
metallization_comparison(array_data)
summary_heatmap_figure(array_data)
yield_and_SNR_over_time(array_data)
yield_over_time(array_data)
area_histograms(array_data)
electrode_length_figure(array_data)
snr_by_area(array_data)
human_summary_figure(array_data)

%%

clear