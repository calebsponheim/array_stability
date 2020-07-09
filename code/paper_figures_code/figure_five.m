function figure_five(array_data)
figure('name','Histograms','visible','off','color','w');
set(gcf,'pos',[350,400,1000,600])
array_names = unique({array_data.array_name});
all_array_names_temp = {array_data.array_name};
all_good_channels_temp = [array_data.num_good_channels_corrected];
all_total_num_channels_temp = [array_data.total_num_of_channels];
%% Figure 5a: Distribution of max # of electrodes with units over arrays.

for iArray = 1:length(array_names)
    array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
    array_max_good_channels(iArray) = max(all_good_channels_temp(array_files_index)./all_total_num_channels_temp(array_files_index));
end

subplot(2,2,1)
bar(.1:.1:1,histcounts(array_max_good_channels,0:.1:1))
xlabel('Portion of Total Channels')
ylabel('Number of Arrays')
xticks(0:.1:1)
xlim([0 1.1])
title('Distribution of max # of electrodes with units over arrays')
box off

clear array_max_good_channels
%% Figure 5b: Distribution of max # of electrodes over M1 arrays
array_count = 1;
for iArray = 1:length(array_names)
    if strfind(array_names{iArray},'M1')
        array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
        array_max_good_channels(array_count) = max(all_good_channels_temp(array_files_index)./all_total_num_channels_temp(array_files_index));
        array_count = array_count + 1;
    end
end

subplot(2,2,2)
bar(.1:.1:1,histcounts(array_max_good_channels,0:.1:1))
xlabel('Portion of Total Channels')
ylabel('Number of Arrays')
xticks(0:.1:1)
xlim([0 1.1])
title('Distribution of max # of electrodes over M1 arrays')
box off

clear array_max_good_channels
%% Figure 5c: Distribution of max # of electrodes over PMd and PMv arrays

array_count = 1;
for iArray = 1:length(array_names)
    if strfind(array_names{iArray},'PM')
        array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
        array_max_good_channels(array_count) = max(all_good_channels_temp(array_files_index)./all_total_num_channels_temp(array_files_index));
        array_count = array_count + 1;
    end
end

subplot(2,2,3)
bar(.1:.1:1,histcounts(array_max_good_channels,0:.1:1))
xlabel('Portion of Total Channels')
ylabel('Number of Arrays')
xticks(0:.1:1)
xlim([0 1.1])
title('Distribution of max # of electrodes over Premotor arrays')
box off

clear array_max_good_channels
%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_five.png');
else
    saveas(gcf,'figure_five.png');
end

close(gcf);
end
