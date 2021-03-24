function yield_and_SNR_over_time(array_data)
% This Figure plots the Signal-to-noise ratio and Channel Yield (in
% percentage) for the array stability project. Includes a subplot
% highlighting the first 30 days after implant.


%% Figure 2a. Mean (se) number of channels over all arrays versus DPI.
array_names = unique({array_data.array_name});

% histcounts and average

% define bin width in days
bin_width = 30; %days

% define bins, out to the maximum number of relative days in the dataset
bins = 0:bin_width:max([array_data.relative_days]);
averaging_prep = zeros(length(array_names),size(bins,2)-1);
for iArray = 1:length(array_names)
        file_count = 1;
        good_channels_temp = zeros(size(array_data,2),1);
        relative_days_temp = zeros(size(array_data,2),1);
        for iFile = 1:size(array_data,2)
            if strcmp(array_data(iFile).array_name,array_names{iArray}) && strcmp(array_data(iArray).species,'NHP')
                good_channels_temp(file_count) = array_data(iFile).num_good_channels_corrected / array_data(iFile).total_num_of_channels;
                relative_days_temp(file_count) = array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end %iFile
        
        for iBin = 1:(size(bins,2)-1)
            averaging_prep(iArray,iBin) = nanmean(good_channels_temp((relative_days_temp > bins(iBin)) & (relative_days_temp <= bins(iBin+1))));      
        end %iBin
               
        clear good_channels_temp
        clear relative_days_temp
end %iArray

avg_channels = zeros(size(bins,2)-1,1);
std_channels = zeros(size(bins,2)-1,1);
std_err_channels = zeros(size(bins,2)-1,1);
for iBin = 1:(size(bins,2)-1)   
    avg_channels(iBin) = sum(averaging_prep(:,iBin),'omitnan')/sum(averaging_prep( :,iBin) > 0);
    std_channels(iBin) = std(averaging_prep(:,iBin),'omitnan');
    std_err_channels(iBin) = std_channels(iBin) / sqrt(sum(averaging_prep(:,iBin) > 0));
end %iBin

%% initializing figure
figure('name','SNR and Channel Yield over time, all arrays','visible','off','color','w');
box off
colors = lines(4);
set(gcf,'pos',[0,0,1000,1250])

%main plot
subplot(4,4,1:3); hold on;

% creating a de-saturated, transparent version of the line color for the
% error bars:
HSV_color = rgb2hsv(colors(1,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

% patch() is a great way to create error bars.
patch([bins(~isnan(std_err_channels))+bin_width fliplr(bins(~isnan(std_err_channels))+bin_width)],[(avg_channels(~isnan(std_err_channels))+std_err_channels(~isnan(std_err_channels)))' fliplr((avg_channels(~isnan(std_err_channels))-std_err_channels(~isnan(std_err_channels)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_channels,'linewidth',2,'Color',colors(1,:));
xlim([0 1500])
ylim([0 1])

box off
grid on
xlabel('Days Post-Implantation');
ylabel('Electrode Yield (Percentage of total number)');
yticks([0 .2 .4 .6 .8 1])
yticklabels({'0%','20%','40%','60%','80%','100%'})
title('a','units','normalized', 'Position', [-0.1,1.05,1]);

%% making inset with different bin size to show increase post-implant

% define bin width in days
bin_width = 4; %days

% define bins, out to the maximum number of relative days in the dataset
bins = 0:bin_width:max([array_data.relative_days]);
averaging_prep = zeros(length(array_names),size(bins,2)-1);
for iArray = 1:length(array_names)
        file_count = 1;
        good_channels_temp = zeros(size(array_data,2),1);
        relative_days_temp = zeros(size(array_data,2),1);
        for iFile = 1:size(array_data,2)
            if strcmp(array_data(iFile).array_name,array_names{iArray}) && strcmp(array_data(iArray).species,'NHP')
                good_channels_temp(file_count) = array_data(iFile).num_good_channels_corrected / array_data(iFile).total_num_of_channels;
                relative_days_temp(file_count) = array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end %iFile
        
        for iBin = 1:(size(bins,2)-1)
            averaging_prep(iArray,iBin) = nanmean(good_channels_temp((relative_days_temp > bins(iBin)) & (relative_days_temp <= bins(iBin+1))));      
        end %iBin
               
        clear good_channels_temp
        clear relative_days_temp
end %iArray

avg_channels = zeros(size(bins,2)-1,1);
std_channels = zeros(size(bins,2)-1,1);
std_err_channels = zeros(size(bins,2)-1,1);
for iBin = 1:(size(bins,2)-1)   
    avg_channels(iBin) = sum(averaging_prep(:,iBin),'omitnan')/sum(averaging_prep(:,iBin) > 0);
    std_channels(iBin) = std(averaging_prep(:,iBin),'omitnan');
    std_err_channels(iBin) = std_channels(iBin) / sqrt(sum(averaging_prep(:,iBin) > 0));
end %iBin

%inset plot
subplot(4,4,4); hold on;

patch([bins(~isnan(std_err_channels))+bin_width fliplr(bins(~isnan(std_err_channels))+bin_width)],[(avg_channels(~isnan(std_err_channels))+std_err_channels(~isnan(std_err_channels)))' fliplr((avg_channels(~isnan(std_err_channels))-std_err_channels(~isnan(std_err_channels)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_channels,'linewidth',2,'Color',colors(1,:));
xlim([0 50])
ylim([0 1])
yticks([0 .2 .4 .6 .8 1])
yticklabels({'0%','20%','40%','60%','80%','100%'})

title('b','units','normalized', 'Position', [-0.1,1.05,1]);

box off
xlabel('Days Post-Implantion');

clear averaging_prep
clear HSV_color
clear subject_lines
clear averaging_count
%% Figure 2b. Mean (se) SNR over all arrays versus DPI.
% define bin width in days
bin_width = 30; %days

% define bins, out to the maximum number of relative days in the dataset
bins = 0:bin_width:max([array_data.relative_days]);
averaging_prep = zeros(length(array_names),size(bins,2)-1);
for iArray = 1:length(array_names)
        file_count = 1;
        SNR_temp = zeros(size(array_data,2),1);
        relative_days_temp = zeros(size(array_data,2),1);
        for iFile = 1:size(array_data,2)
            if strcmp(array_data(iFile).array_name,array_names{iArray}) && strcmp(array_data(iArray).species,'NHP')
                SNR_temp(file_count) = array_data(iFile).SNR_good_channels;
                relative_days_temp(file_count) = array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end %iFile
        
        for iBin = 1:(size(bins,2)-1)
            averaging_prep(iArray,iBin) = nanmean(SNR_temp((relative_days_temp > bins(iBin)) & (relative_days_temp <= bins(iBin+1))));      
        end %iBin
               
        clear SNR_temp
        clear relative_days_temp
end %iArray

avg_SNR = zeros(size(bins,2)-1,1);
std_SNR = zeros(size(bins,2)-1,1);
std_err_SNR = zeros(size(bins,2)-1,1);
for iBin = 1:(size(bins,2)-1)   
    avg_SNR(iBin) = sum(averaging_prep(:,iBin),'omitnan')/sum(averaging_prep(:,iBin) > 0);
    std_SNR(iBin) = std(averaging_prep(:,iBin),'omitnan');
    std_err_SNR(iBin) = std_SNR(iBin) / sqrt(sum(averaging_prep(:,iBin) > 0));
end %iBin

subplot(4,4,5:7); hold on;

HSV_color = rgb2hsv(colors(2,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

patch([bins(~isnan(std_err_SNR))+bin_width fliplr(bins(~isnan(std_err_SNR))+bin_width)],[(avg_SNR(~isnan(std_err_SNR))+std_err_SNR(~isnan(std_err_SNR)))' fliplr((avg_SNR(~isnan(std_err_SNR))-std_err_SNR(~isnan(std_err_SNR)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_SNR,'linewidth',2,'Color',colors(2,:));
xlim([0 1500])
ylim([0 max(avg_SNR)])

ylim_both = [0 max(avg_SNR)];


box off
grid on
xlabel('Days Post-Implantation');
ylabel('SNR');
title('c','units','normalized', 'Position', [-0.1,1.05,1]);

%%
%inset plot for SNR
subplot(4,4,8); hold on;
% define bin width in days
bin_width = 4; %days

% define bins, out to the maximum number of relative days in the dataset
bins = 0:bin_width:max([array_data.relative_days]);
averaging_prep = zeros(length(array_names),size(bins,2)-1);
for iArray = 1:length(array_names)
        file_count = 1;
        SNR_temp = zeros(size(array_data,2),1);
        relative_days_temp = zeros(size(array_data,2),1);
        for iFile = 1:size(array_data,2)
            if strcmp(array_data(iFile).array_name,array_names{iArray}) && strcmp(array_data(iArray).species,'NHP')
                SNR_temp(file_count) = array_data(iFile).SNR_good_channels;
                relative_days_temp(file_count) = array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end %iFile
        
        for iBin = 1:(size(bins,2)-1)
            averaging_prep(iArray,iBin) = nanmean(SNR_temp((relative_days_temp > bins(iBin)) & (relative_days_temp <= bins(iBin+1))));      
        end %iBin
               
        clear SNR_temp
        clear relative_days_temp
end %iArray

avg_SNR = zeros(size(bins,2)-1,1);
std_SNR = zeros(size(bins,2)-1,1);
std_err_SNR = zeros(size(bins,2)-1,1);
for iBin = 1:(size(bins,2)-1)   
    avg_SNR(iBin) = sum(averaging_prep(:,iBin),'omitnan')/sum(averaging_prep(:,iBin) > 0);
    std_SNR(iBin) = std(averaging_prep(:,iBin),'omitnan');
    std_err_SNR(iBin) = std_SNR(iBin) / sqrt(sum(averaging_prep(:,iBin) > 0));
end %iBin


HSV_color = rgb2hsv(colors(2,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

patch([bins(~isnan(std_err_SNR))+bin_width fliplr(bins(~isnan(std_err_SNR))+bin_width)],[(avg_SNR(~isnan(std_err_SNR))+std_err_SNR(~isnan(std_err_SNR)))' fliplr((avg_SNR(~isnan(std_err_SNR))-std_err_SNR(~isnan(std_err_SNR)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_SNR,'linewidth',2,'Color',colors(2,:));
xlim([0 50])
ylim(ylim_both)

title('d','units','normalized', 'Position', [-0.1,1.05,1]);

box off
xlabel('Days Post-Implantation');

clear averaging_prep
clear HSV_color
clear subject_lines

%% Human Data

% clear array_data


array_count = 1;
for iArray = 1:size(array_data,2)
    if strcmp(array_data(iArray).species,'HP')
        human_array_data(array_count) = array_data(iArray);
        array_count = array_count + 1;
    end
end


%% Panel a. Mean (se) number of channels over all human arrays versus DPI.
array_names = unique({human_array_data.array_name});

% histcounts and average

% define bin width in days
bin_width = 30; %days

% define bins, out to the maximum number of relative days in the dataset
bins = 0:bin_width:max([human_array_data.relative_days]);
averaging_prep = zeros(length(array_names),size(bins,2)-1);
for iArray = 1:length(array_names)
    file_count = 1;
    good_channels_temp = zeros(size(human_array_data,2),1);
    relative_days_temp = zeros(size(human_array_data,2),1);
    for iFile = 1:size(human_array_data,2)
        if strcmp(human_array_data(iFile).array_name,array_names{iArray})
            good_channels_temp(file_count) = human_array_data(iFile).num_good_channels_corrected / human_array_data(iFile).total_num_of_channels;
            relative_days_temp(file_count) = human_array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end %iFile
    
    for iBin = 1:(size(bins,2)-1)
        averaging_prep(iArray,iBin) = nanmean(good_channels_temp((relative_days_temp > bins(iBin)) & (relative_days_temp <= bins(iBin+1))));
    end %iBin
    
    clear good_channels_temp
    clear relative_days_temp
end %iArray

avg_channels = zeros(size(bins,2)-1,1);
std_channels = zeros(size(bins,2)-1,1);
std_err_channels = zeros(size(bins,2)-1,1);
for iBin = 1:(size(bins,2)-1)
    avg_channels(iBin) = sum(averaging_prep(:,iBin),'omitnan')/sum(averaging_prep(:,iBin) > 0);
    std_channels(iBin) = std(averaging_prep(:,iBin),'omitnan');
    std_err_channels(iBin) = std_channels(iBin) / sqrt(sum(averaging_prep(:,iBin) > 0));
end %iBin

%% initializing figure
% figure('name','SNR and Channel Yield over time, all arrays','visible','off','color','w');
% box off
% colors = lines(4);
% set(gcf,'pos',[350,200,1000,750])
% 
%main plot
subplot(4,4,9:11); hold on;

% creating a de-saturated, transparent version of the line color for the
% error bars:
HSV_color = rgb2hsv(colors(1,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

% patch() is a great way to create error bars.
patch([bins(~isnan(std_err_channels))+bin_width fliplr(bins(~isnan(std_err_channels))+bin_width)],[(avg_channels(~isnan(std_err_channels))+std_err_channels(~isnan(std_err_channels)))' fliplr((avg_channels(~isnan(std_err_channels))-std_err_channels(~isnan(std_err_channels)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_channels,'linewidth',2,'Color',colors(1,:));
xlim([0 max([human_array_data.relative_days])])
ylim([0 1])
yticks([0 .2 .4 .6 .8 1])
yticklabels({'0%','20%','40%','60%','80%','100%'})

box off
grid on
xlabel('Days Post-Implantation');
ylabel('Electrode Yield');
title('e','units','normalized', 'Position', [-0.1,1.05,1]);

clear averaging_prep
clear HSV_color
clear subject_lines
clear averaging_count

%% making inset with different bin size to show increase post-implant

% define bin width in days
bin_width = 4; %days

% define bins, out to the maximum number of relative days in the dataset
bins = 0:bin_width:max([human_array_data.relative_days]);
averaging_prep = zeros(length(array_names),size(bins,2)-1);
for iArray = 1:length(array_names)
        file_count = 1;
        good_channels_temp = zeros(size(human_array_data,2),1);
        relative_days_temp = zeros(size(human_array_data,2),1);
        for iFile = 1:size(human_array_data,2)
            if strcmp(human_array_data(iFile).array_name,array_names{iArray})
                good_channels_temp(file_count) = human_array_data(iFile).num_good_channels_corrected / human_array_data(iFile).total_num_of_channels;
                relative_days_temp(file_count) = human_array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end %iFile
        
        for iBin = 1:(size(bins,2)-1)
            averaging_prep(iArray,iBin) = nanmean(good_channels_temp((relative_days_temp > bins(iBin)) & (relative_days_temp <= bins(iBin+1))));      
        end %iBin
               
        clear good_channels_temp
        clear relative_days_temp
end %iArray

avg_channels = zeros(size(bins,2)-1,1);
std_channels = zeros(size(bins,2)-1,1);
std_err_channels = zeros(size(bins,2)-1,1);
for iBin = 1:(size(bins,2)-1)   
    avg_channels(iBin) = sum(averaging_prep(:,iBin),'omitnan')/sum(averaging_prep(:,iBin) > 0);
    std_channels(iBin) = std(averaging_prep(:,iBin),'omitnan');
    std_err_channels(iBin) = std_channels(iBin) / sqrt(sum(averaging_prep(:,iBin) > 0));
end %iBin

%inset plot
subplot(4,4,12); hold on;

patch([bins(~isnan(std_err_channels))+bin_width fliplr(bins(~isnan(std_err_channels))+bin_width)],[(avg_channels(~isnan(std_err_channels))+std_err_channels(~isnan(std_err_channels)))' fliplr((avg_channels(~isnan(std_err_channels))-std_err_channels(~isnan(std_err_channels)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_channels,'linewidth',2,'Color',colors(1,:));
xlim([0 50])
ylim([0 1])
yticks([0 .2 .4 .6 .8 1])
yticklabels({'0%','20%','40%','60%','80%','100%'})

title('f','units','normalized', 'Position', [-0.1,1.05,1]);

box off
xlabel('Days Post-Implantion');

clear averaging_prep
clear HSV_color
clear subject_lines
clear averaging_count
%% Panel b. Mean (se) SNR over all human arrays versus DPI.
% define bin width in days
bin_width = 30; %days

% define bins, out to the maximum number of relative days in the dataset
bins = 0:bin_width:max([human_array_data.relative_days]);
averaging_prep = zeros(length(array_names),size(bins,2)-1);
for iArray = 1:length(array_names)
    file_count = 1;
    SNR_temp = zeros(size(human_array_data,2),1);
    relative_days_temp = zeros(size(human_array_data,2),1);
    for iFile = 1:size(human_array_data,2)
        if strcmp(human_array_data(iFile).array_name,array_names{iArray})
            SNR_temp(file_count) = human_array_data(iFile).SNR_good_channels;
            relative_days_temp(file_count) = human_array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end %iFile
    
    for iBin = 1:(size(bins,2)-1)
        averaging_prep(iArray,iBin) = nanmean(SNR_temp((relative_days_temp > bins(iBin)) & (relative_days_temp <= bins(iBin+1))));
    end %iBin
    
    clear SNR_temp
    clear relative_days_temp
end %iArray

avg_SNR = zeros(size(bins,2)-1,1);
std_SNR = zeros(size(bins,2)-1,1);
std_err_SNR = zeros(size(bins,2)-1,1);
for iBin = 1:(size(bins,2)-1)
    avg_SNR(iBin) = sum(averaging_prep(:,iBin),'omitnan')/sum(averaging_prep(:,iBin) > 0);
    std_SNR(iBin) = std(averaging_prep(:,iBin),'omitnan');
    std_err_SNR(iBin) = std_SNR(iBin) / sqrt(sum(averaging_prep(:,iBin) > 0));
end %iBin

subplot(4,4,13:15); hold on;

HSV_color = rgb2hsv(colors(2,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

patch([bins(~isnan(std_err_SNR))+bin_width fliplr(bins(~isnan(std_err_SNR))+bin_width)],[(avg_SNR(~isnan(std_err_SNR))+std_err_SNR(~isnan(std_err_SNR)))' fliplr((avg_SNR(~isnan(std_err_SNR))-std_err_SNR(~isnan(std_err_SNR)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_SNR,'linewidth',2,'Color',colors(2,:));
xlim([0 max([human_array_data.relative_days])])
ylim([1.5 3.5])

ylim_both = [min(avg_SNR) max(avg_SNR)];


box off
grid on
xlabel('Days Post-Implantation');
ylabel('SNR');
title('g','units','normalized', 'Position', [-0.1,1.05,1]);



%% inset plot for SNR
subplot(4,4,16); hold on;
% define bin width in days
bin_width = 4; %days

% define bins, out to the maximum number of relative days in the dataset
bins = 0:bin_width:max([human_array_data.relative_days]);
averaging_prep = zeros(length(array_names),size(bins,2)-1);
for iArray = 1:length(array_names)
        file_count = 1;
        SNR_temp = zeros(size(human_array_data,2),1);
        relative_days_temp = zeros(size(human_array_data,2),1);
        for iFile = 1:size(human_array_data,2)
            if strcmp(human_array_data(iFile).array_name,array_names{iArray})
                SNR_temp(file_count) = human_array_data(iFile).SNR_good_channels;
                relative_days_temp(file_count) = human_array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end %iFile
        
        for iBin = 1:(size(bins,2)-1)
            averaging_prep(iArray,iBin) = nanmean(SNR_temp((relative_days_temp > bins(iBin)) & (relative_days_temp <= bins(iBin+1))));      
        end %iBin
               
        clear SNR_temp
        clear relative_days_temp
end %iArray

avg_SNR = zeros(size(bins,2)-1,1);
std_SNR = zeros(size(bins,2)-1,1);
std_err_SNR = zeros(size(bins,2)-1,1);
for iBin = 1:(size(bins,2)-1)   
    avg_SNR(iBin) = sum(averaging_prep(:,iBin),'omitnan')/sum(averaging_prep(:,iBin) > 0);
    std_SNR(iBin) = std(averaging_prep(:,iBin),'omitnan');
    std_err_SNR(iBin) = std_SNR(iBin) / sqrt(sum(averaging_prep(:,iBin) > 0));
end %iBin


HSV_color = rgb2hsv(colors(2,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

patch([bins(~isnan(std_err_SNR))+bin_width fliplr(bins(~isnan(std_err_SNR))+bin_width)],[(avg_SNR(~isnan(std_err_SNR))+std_err_SNR(~isnan(std_err_SNR)))' fliplr((avg_SNR(~isnan(std_err_SNR))-std_err_SNR(~isnan(std_err_SNR)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_SNR,'linewidth',2,'Color',colors(2,:));
xlim([0 50])
ylim([0 max(avg_SNR)])

title('h','units','normalized', 'Position', [-0.1,1.05,1]);

box off
xlabel('Days Post-Implantation');

clear averaging_prep
clear HSV_color
clear subject_lines

%% Saving

% if you're on my computer, then it saves in the right spot. if not, then
% it just dumps the figure file in your local directory. whoops!
if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\yield_and_SNR_over_time.png');
else
    saveas(gcf,'yield_and_SNR_over_time.png');
end

close(gcf);


end