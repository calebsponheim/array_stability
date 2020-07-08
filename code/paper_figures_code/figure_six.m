function figure_six(array_data)

%% Figure 6: Mean SNR at 3,6,12,18 months, and >2 years over 4 cortical areas (grouped bar graphs).

time_points_in_days = [round((365/12)*3),round((365/12)*6),365,round(365/2 + 365),365*2,5000];

array_names = unique({array_data.array_name});
all_array_names_temp = {array_data.array_name};
all_days_temp = [array_data.relative_days];
all_SNR_temp = [array_data.SNR_good_channels];
mean_snr_per_array = zeros(numel(time_points_in_days));

for iArray = 1:length(array_names)
    
    array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
    array_relative_days = all_days_temp(array_files_index);
    array_SNR = all_SNR_temp(array_files_index);
    
    for iTimePoint = 1:length(time_points_in_days)-1
%         mean_snr_per_array(iArray,iTimePoint) = ...
%             mean(array_SNR((array_relative_days >= time_points_in_days(iTimePoint) && array_relative_days < time_points_in_days(iTimePoint+1)));
    end
end

mean_SNR_over_all_arrays = mean(mean_snr_per_array,1);


%% plotting

figure('name','Long-term, chronic array recordings','visible','off','color','w');
bar(time_points_in_days,mean_SNR_over_all_arrays,6)
xlabel('Days Post Implantation (DPI)')
xticks(time_points_in_days(1:end-1));
ylabel('SNR')
title('Mean SNR of different arrays')
set(gcf,'pos',[1150,400,700,500])
box off

%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_six.png');
else
    saveas(gcf,'figure_six.png');
end

close(gcf);


end