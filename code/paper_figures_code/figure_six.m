function figure_six(array_data)

%% Figure 6: Mean SNR at 3,6,12,18 months, and >2 years over 3 cortical areas (grouped bar graphs).


time_points_in_days = ((365/12)*3):((365/12)*3):(365*3);
one_month = 365/12;
array_names = unique({array_data.array_name});
all_array_names_temp = {array_data.array_name};
all_days_temp = [array_data.relative_days];
all_SNR_temp = [array_data.SNR_all_channels];
array_SNR = nan(numel(time_points_in_days),numel(array_names));
areas = {'M1','PMd','PMv'};
colors = hsv(numel(areas));

for iArea = 1:numel(areas)
    array_SNR = nan(length(time_points_in_days),length(array_names));
    for iArray = 1:length(array_names)
        if strfind(array_names{iArray},areas{iArea})
            array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
            array_relative_days = all_days_temp(array_files_index);
            array_SNR_per_file = all_SNR_temp(array_files_index);
            for iTimePoint = 1:length(time_points_in_days)
                ind_array_SNR = nan(numel(array_relative_days),1);
                for iFile = 1:length(array_relative_days)
                    if ((time_points_in_days(iTimePoint)- one_month) < array_relative_days(iFile)) && (array_relative_days(iFile) < (time_points_in_days(iTimePoint)+ one_month))
                        ind_array_SNR(iFile) = array_SNR_per_file(iFile);
                    end
                end
                array_SNR(iTimePoint,iArray) = nanmean(ind_array_SNR);
                clear ind_array_SNR
            end
        end
    end
    
    mean_array_SNR{iArea} = nanmean(array_SNR,2);
end
%% plotting

figure('name','Long-term, chronic array recordings','visible','off','color','w'); hold on
for iArea = 1:numel(areas)
    plots{iArea} = plot(time_points_in_days/one_month,mean_array_SNR{iArea},'o-','linewidth',2,'color',colors(iArea,:));
end
xlabel('Months Post Implantation (DPI)')
xticks(time_points_in_days/one_month);
legend([plots{:}],areas)
ylabel('Signal to Noise Ratio')
title('Average SNR Over Time, For Different Brain Areas')
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