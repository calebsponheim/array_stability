function figure_two(array_data)

figure('name','Long-term, chronic array recordings','visible','off','color','w');
box off
array_names = unique({array_data.array_name});
colors = autumn(4);
set(gcf,'pos',[350,200,1000,750])

%% Figure 2a. Mean (se) number of channels over all arrays versus DPI.

% histcounts and average
iPlotName = 1;
for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            good_channels_temp(file_count) = array_data(iFile).num_good_channels_corrected / array_data(iFile).total_num_of_channels;
            relative_days_temp(file_count) = array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end
    
        plot_names{iPlotName} = strrep(array_names{iArray},'_',' ');
        quad_fit_to_good_channels = polyfit(relative_days_temp,good_channels_temp,1);
        quad_fit_to_good_channels = ...
            polyval(quad_fit_to_good_channels,min(relative_days_temp):max(relative_days_temp));
        
        if max(quad_fit_to_good_channels)>128
            disp('stop, who are you even')
        else
            subject_lines{iPlotName,1} = min(relative_days_temp):max(relative_days_temp);
            subject_lines{iPlotName,2} = quad_fit_to_good_channels;
        end
        
        averaging_prep(iArray,subject_lines{iPlotName,1}) = subject_lines{iPlotName,2};
        
        iPlotName = iPlotName + 1;
    
    clear good_channels_temp
    clear relative_days_temp
end

averaging_prep(averaging_prep == 0) = NaN;
avg_channels = nanmean(averaging_prep,1);
avg_channels(isnan(avg_channels)) = 0;
std_channels = nanstd(averaging_prep,1);
std_channels(isnan(std_channels)) = 0;


%main plot
subplot(2,4,1:3); hold on;

HSV_color = rgb2hsv(colors(1,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

patch([1:length(avg_channels) fliplr(1:length(avg_channels))],[avg_channels+std_channels fliplr(avg_channels-std_channels)],patch_color,'edgecolor','none')
plot(avg_channels,'linewidth',2,'Color',colors(1,:));


box off
grid on
xlabel('Days Post Implantation');
ylabel('Channel Yield (proportion of total number)');
title('Average Array Yield Over Time');


%inset plot
subplot(2,4,4); hold on;

patch([1:length(avg_channels) fliplr(1:length(avg_channels))],[avg_channels+std_channels fliplr(avg_channels-std_channels)],patch_color,'edgecolor','none')
plot(avg_channels,'linewidth',2,'Color',colors(1,:));
xlim([0 30])

box off
xlabel('days post implantation');

clear averaging_prep
clear HSV_color
clear subject_lines
%% Figure 2b. Mean (se) SNR over all arrays versus DPI.


iPlotName = 1;
for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            SNR_temp(file_count) = array_data(iFile).SNR_all_channels;
            relative_days_temp(file_count) = array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end
    
        plot_names{iPlotName} = strrep(array_names{iArray},'_',' ');
        quad_fit_to_SNR = polyfit(relative_days_temp,SNR_temp,1);
        quad_fit_to_SNR = ...
            polyval(quad_fit_to_SNR,min(relative_days_temp):max(relative_days_temp));
        
        if max(quad_fit_to_SNR)>128
            disp('stop, who are you even')
        else
            subject_lines{iPlotName,1} = min(relative_days_temp):max(relative_days_temp);
            subject_lines{iPlotName,2} = quad_fit_to_SNR;
        end
        
        averaging_prep(iArray,subject_lines{iPlotName,1}) = subject_lines{iPlotName,2};
        
        iPlotName = iPlotName + 1;
    
    clear SNR_temp
    clear relative_days_temp
end

averaging_prep(averaging_prep == 0) = NaN;
avg_SNR = nanmean(averaging_prep,1);
avg_SNR(isnan(avg_SNR)) = 0;
std_SNR = nanstd(averaging_prep,1);
std_SNR(isnan(std_SNR)) = 0;

subplot(2,4,5:7); hold on;

HSV_color = rgb2hsv(colors(2,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

patch([1:length(avg_SNR) fliplr(1:length(avg_SNR))],[avg_SNR-std_SNR fliplr(avg_SNR+std_SNR)],patch_color,'edgecolor','none')
plot(avg_SNR,'linewidth',2,'Color',colors(2,:));

box off
grid on
xlabel('days post implantation');
ylabel('SNR');
title('mean SNR over time');


%inset plot
subplot(2,4,8); hold on;

patch([1:length(avg_SNR) fliplr(1:length(avg_SNR))],[avg_SNR+std_SNR fliplr(avg_SNR-std_SNR)],patch_color,'edgecolor','none')
plot(avg_SNR,'linewidth',2,'Color',colors(2,:));
xlim([0 30])

box off
xlabel('days post implantation');

clear averaging_prep
clear HSV_color
clear subject_lines

%% Saving
if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_two.png');
else
    saveas(gcf,'figure_two.png');
end

close(gcf);


end