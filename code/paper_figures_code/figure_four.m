function figure_four(array_data)
%% Figure 4. % of arrays with yield >20% over different time points:
% 3 months, 6 months, 1 year, 1.5 years, >2 years

time_points_in_days = [round((365/12)*3),round((365/12)*6),365,round(365/2 + 365),365*2];

array_names = unique({array_data.array_name});
yield_threshold = round(128*.2);
all_array_names_temp = {array_data.array_name};
all_days_temp = [array_data.relative_days];
all_good_channels_temp = [array_data.num_good_channels_corrected];
num_arrays_above_threshold = zeros(numel(time_points_in_days));

for iArray = 1:length(array_names)
    
    array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
    array_relative_days = all_days_temp(array_files_index);
    array_num_good_channels = all_good_channels_temp(array_files_index);
    
    for iTimePoint = 1:length(time_points_in_days)
        num_arrays_above_threshold(iTimePoint) = num_arrays_above_threshold(iTimePoint) + ((sum(array_num_good_channels(array_relative_days > time_points_in_days(iTimePoint)) > yield_threshold)) > 0);
    end
end

percent_arrays_above_threshold = num_arrays_above_threshold / length(array_names);


%% plotting

figure('name','Long-term, chronic array recordings','visible','off','color','w');
bar(time_points_in_days,percent_arrays_above_threshold,6)
xlabel('Days Post Implantation (DPI)')
xticks(time_points_in_days);
ylabel('Percent of Arrays over 20% Yield')
title('% of arrays with yield >20% over different time points')
set(gcf,'pos',[1150,400,700,500])
box off

%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_four.png');
else
    saveas(gcf,'figure_four.png');
end

close(gcf);


end