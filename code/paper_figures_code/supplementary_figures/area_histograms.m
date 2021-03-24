function area_histograms(array_data)
%% Figure 5a: Distribution of max # of electrodes with units over arrays.
% This figure is meant to show the maximum potential yield for arrays.
% What's the best performance you get on average from your arrays?
% Additionally, is there any difference in max performance between
% different brain areas?


%%
figure('name','Histograms','visible','off','color','w');
set(gcf,'pos',[350,400,1000,500])
array_names = unique({array_data.array_name});
all_array_names_temp = {array_data.array_name};
all_good_channels_temp = [array_data.num_good_channels_corrected];
all_total_num_channels_temp = [array_data.total_num_of_channels];
all_days_temp = [array_data.relative_days];
for iArray = 1:length(array_names)
    array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
    array_max_good_channels(iArray) = max(all_good_channels_temp(array_files_index)...
        ./all_total_num_channels_temp(array_files_index));
        
    all_days_temp_temp = all_days_temp(array_files_index);
    dpi_temp = all_days_temp_temp(all_good_channels_temp(array_files_index) == max(all_good_channels_temp(array_files_index)));
    array_max_good_channels_dpi(iArray) = dpi_temp(1);
    if array_max_good_channels(iArray) >= .9
        finding_maxed_out_arrays{iArray,1} = array_max_good_channels_dpi(iArray);
        finding_maxed_out_arrays{iArray,2} = array_names{iArray};
    end
end
subplot(1,2,1);
bar(.05:.1:.95,histcounts(array_max_good_channels,0:.1:1))
xlabel('Electrode Yield')
ylabel('Number of Arrays')
xticks(0:.1:1)
xticklabels({'0%' '10%' '20%' '30%' '40%' '50%' '60%' '70%' '80%' '90%' '100%'})
xlim([0 1])
title('a','units','normalized', 'Position', [-0.1,1,1]);
grid on
box off

%% second plot
subplot(1,2,2);
bar(25:50:775,histcounts(array_max_good_channels_dpi,0:50:800))
grid on
box off
xticks(0:100:800)
xlim([0 800])
xlabel('Days Post-Implantation')
ylabel('Number of Arrays')
title('b','units','normalized', 'Position', [-0.1,1,1]);

clear array_max_good_channels
%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\supplementary_figures\area_histograms.png');
else
    saveas(gcf,'area_histograms.png');
end

close(gcf);
end
