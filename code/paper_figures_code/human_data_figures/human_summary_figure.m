function human_summary_figure(array_data)

% long-term figure for panel A and B (top left and top right,
% respectively), with channel yield and SNR.

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
figure('name','SNR and Channel Yield over time, all arrays','visible','off','color','w');
box off
colors = lines(4);
set(gcf,'pos',[350,200,1000,750])

%main plot
subplot(4,2,1:2); hold on;

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

box off
grid on
xlabel('Days Post-Implantation');
ylabel('Proportion of Total Channels');
title('a','units','normalized', 'Position', [-0.1,1.05,1]);

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

subplot(4,2,3:4); hold on;

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
title('b','units','normalized', 'Position', [-0.1,1.05,1]);

%% Individual lines

array_names_for_legend = unique({human_array_data.array_name});
colors = lines(length(array_names));

% subplot spans were used to make the plots size correctly.
subplot(4,2,[5,7]); hold on;

iPlotName = 1;
for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(human_array_data,2)
        if strcmp(human_array_data(iFile).array_name,array_names{iArray})
            good_channels_temp(file_count) = human_array_data(iFile).num_good_channels_corrected / human_array_data(iFile).total_num_of_channels;
            relative_days_temp(file_count) = human_array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end
    
    if max(relative_days_temp) > (365*2)
        if strcmp(array_names{iArray},'P1_A') || strcmp(array_names{iArray},'P1_P')
            plot_names{iPlotName} = strrep(array_names_for_legend{iArray},'_',' ');
            plot(relative_days_temp,good_channels_temp,'.','linewidth',1,'color',colors(iArray,:));
            
            % First Half
            quad_fit_to_good_channels = polyfit(relative_days_temp(relative_days_temp <= 563),good_channels_temp(relative_days_temp <= 563),1);
            quad_fit_to_good_channels = ...
                polyval(quad_fit_to_good_channels,min(relative_days_temp(relative_days_temp <= 563)):1:max(relative_days_temp(relative_days_temp <= 563)));
            plots{iPlotName} = ...
                    plot(min(relative_days_temp(relative_days_temp <= 563)):1:max(relative_days_temp(relative_days_temp <= 563)),...
                    quad_fit_to_good_channels,'-','color',colors(iArray,:),'linewidth',2);
            % Second Half
            quad_fit_to_good_channels = polyfit(relative_days_temp(relative_days_temp > 563),good_channels_temp(relative_days_temp > 563),1);
            quad_fit_to_good_channels = ...
                polyval(quad_fit_to_good_channels,min(relative_days_temp(relative_days_temp > 563)):1:max(relative_days_temp(relative_days_temp > 563)));
            plot(min(relative_days_temp(relative_days_temp > 563)):1:max(relative_days_temp(relative_days_temp > 563)),...
            quad_fit_to_good_channels,'-','color',colors(iArray,:),'linewidth',2);
            
            iPlotName = iPlotName + 2;
        else
            plot_names{iPlotName} = strrep(array_names_for_legend{iArray},'_',' ');
            plot(relative_days_temp,good_channels_temp,'.','linewidth',1,'color',colors(iArray,:));
            quad_fit_to_good_channels = polyfit(relative_days_temp,good_channels_temp,1);
            quad_fit_to_good_channels = ...
                polyval(quad_fit_to_good_channels,min(relative_days_temp):1:max(relative_days_temp));
            
            if max(quad_fit_to_good_channels)>128
                disp('stop, who are you even')
            else
                plots{iPlotName} = ...
                    plot(min(relative_days_temp):1:max(relative_days_temp),...
                    quad_fit_to_good_channels,'-','color',colors(iArray,:),'linewidth',2);
            end
            iPlotName = iPlotName + 1;
        end
    end
    
    clear good_channels_temp
    clear relative_days_temp
    %     end
end
ylabel('Electrode Yield (Percentage of total number)');
ylim([0 1]);
yticks(0:.25:1)
yticklabels({'0%' '25%' '50%' '75%' '100%'})
xlim([0 max([human_array_data.relative_days])]);
box off

legend([plots{:}],plot_names([1,3,5,6]),'location','northeastoutside')

grid on
xlabel('Days Post-Implantation');
title('c','units','normalized', 'Position', [-0.25,.95,1]);
clear plot_names
clear plots

%% panel d
subplot(4,2,[6,8]); hold on;

iPlotName = 1;
for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(human_array_data,2)
        if strcmp(human_array_data(iFile).array_name,array_names{iArray})
            if ~ischar(human_array_data(iFile).SNR_all_channels) && ~isnan(human_array_data(iFile).SNR_all_channels)
                SNR_temp(file_count) = human_array_data(iFile).SNR_all_channels;
                relative_days_temp(file_count) = human_array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end
    end
    
    if max(relative_days_temp) > (365*2)
        plot_names{iPlotName} = strrep(array_names{iArray},'_',' ');
        plot(relative_days_temp,SNR_temp,'.','linewidth',1,'color',colors(iArray,:));
        
        % Linear Regression to each array's data points.
        quad_fit_to_SNR = polyfit(relative_days_temp,SNR_temp,1);
        quad_fit_to_SNR = polyval(quad_fit_to_SNR,min(relative_days_temp):1:max(relative_days_temp));
        
        if max(quad_fit_to_SNR)>128
        else
            plots{iPlotName} = ...
                plot(min(relative_days_temp):1:max(relative_days_temp),...
                quad_fit_to_SNR,'-','color',colors(iArray,:),'linewidth',2);
        end
        iPlotName = iPlotName + 1;
    end
    
    clear SNR_temp
    clear relative_days_temp
    %     end
end
ylabel('Signal to Noise Ratio');
ylim([0 max([human_array_data.SNR_all_channels])]);
xlim([0 max([human_array_data.relative_days])]);
box off

legend([plots{:}],plot_names,'location','northeastoutside')
title('d','units','normalized', 'Position', [-0.25,.95,1]);
grid on
xlabel('Days Post-Implantation');
%%
if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\human_data_figure.png');
else
    saveas(gcf,'human_data_figure.png');
end

close(gcf);

end