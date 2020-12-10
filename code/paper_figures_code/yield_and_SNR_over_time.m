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
            if strcmp(array_data(iFile).array_name,array_names{iArray})
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

%% initializing figure
figure('name','SNR and Channel Yield over time, all arrays','visible','off','color','w');
box off
colors = autumn(4);
set(gcf,'pos',[350,200,1000,750])

%main plot
subplot(2,4,1:3); hold on;

% creating a de-saturated, transparent version of the line color for the
% error bars:
HSV_color = rgb2hsv(colors(1,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

% patch() is a great way to create error bars.
patch([bins(~isnan(std_err_channels))+bin_width fliplr(bins(~isnan(std_err_channels))+bin_width)],[(avg_channels(~isnan(std_err_channels))+std_err_channels(~isnan(std_err_channels)))' fliplr((avg_channels(~isnan(std_err_channels))-std_err_channels(~isnan(std_err_channels)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_channels,'linewidth',2,'Color',colors(1,:));
xlim([0 1500])


box off
grid on
xlabel('Days Post Implantation');
ylabel('Channel Yield (proportion of total number)');
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
            if strcmp(array_data(iFile).array_name,array_names{iArray})
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
subplot(2,4,4); hold on;

patch([bins(~isnan(std_err_channels))+bin_width fliplr(bins(~isnan(std_err_channels))+bin_width)],[(avg_channels(~isnan(std_err_channels))+std_err_channels(~isnan(std_err_channels)))' fliplr((avg_channels(~isnan(std_err_channels))-std_err_channels(~isnan(std_err_channels)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_channels,'linewidth',2,'Color',colors(1,:));
xlim([0 50])
title('b','units','normalized', 'Position', [-0.1,1.05,1]);

box off
xlabel('days post implantation');

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
            if strcmp(array_data(iFile).array_name,array_names{iArray})
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

subplot(2,4,5:7); hold on;

HSV_color = rgb2hsv(colors(2,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

patch([bins(~isnan(std_err_SNR))+bin_width fliplr(bins(~isnan(std_err_SNR))+bin_width)],[(avg_SNR(~isnan(std_err_SNR))+std_err_SNR(~isnan(std_err_SNR)))' fliplr((avg_SNR(~isnan(std_err_SNR))-std_err_SNR(~isnan(std_err_SNR)))')],patch_color,'edgecolor','none')
plot(bins(2:end),avg_SNR,'linewidth',2,'Color',colors(2,:));
xlim([0 1500])

box off
grid on
xlabel('days post implantation');
ylabel('SNR');
title('c','units','normalized', 'Position', [-0.1,1.05,1]);

%%
%inset plot for SNR
subplot(2,4,8); hold on;
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
            if strcmp(array_data(iFile).array_name,array_names{iArray})
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
xlim([0 30])
title('d','units','normalized', 'Position', [-0.1,1.05,1]);

box off
xlabel('days post implantation');

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