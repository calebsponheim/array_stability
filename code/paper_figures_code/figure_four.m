function figure_four(array_data)
%% Figure 4. % of arrays with yield >20% over different time points:

time_points_in_days = ((365/12)*3):((365/12)*3):(365*3);
one_month = 365/12;
array_names = unique({array_data.array_name});
yield_threshold = round([array_data.total_num_of_channels]*.2);
all_array_names_temp = {array_data.array_name};
all_days_temp = [array_data.relative_days];
all_good_channels_temp = [array_data.num_good_channels_corrected];
num_arrays_above_threshold = zeros(numel(time_points_in_days),1);

for iArray = 1:length(array_names)
    
    array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
    array_relative_days = all_days_temp(array_files_index);
    array_yield_thresh = yield_threshold(array_files_index);
    array_num_good_channels = all_good_channels_temp(array_files_index);
    
    for iTimePoint = 1:length(time_points_in_days)
        file_above_thresh = 0;
        for iFile = 1:length(array_relative_days)
            if (((time_points_in_days(iTimePoint)- one_month) < array_relative_days(iFile)) && (array_relative_days(iFile) < (time_points_in_days(iTimePoint)+ one_month))) && (array_num_good_channels(iFile) > array_yield_thresh(iFile))
                file_above_thresh = 1;
            end
        end
        num_arrays_above_threshold(iTimePoint) = num_arrays_above_threshold(iTimePoint) + file_above_thresh;
    end
end

percent_arrays_above_threshold = num_arrays_above_threshold / length(array_names);


%% plotting

figure('name','Long-term, chronic array recordings','visible','off','color','w');
plot(time_points_in_days/one_month,percent_arrays_above_threshold,'o-','linewidth',2)
xlabel('Months Post Implantation (DPI)')
xticks(time_points_in_days/one_month);
ylabel('Portion of Arrays over 20% Yield')
title('% of arrays with yield >20% over different time points')
set(gcf,'pos',[1150,400,700,500])
box off

clear num_arrays_above_threshol
%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_four.png');
else
    saveas(gcf,'figure_four.png');
end

close(gcf);


end