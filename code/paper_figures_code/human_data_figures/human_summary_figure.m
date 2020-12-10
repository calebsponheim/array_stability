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

clear array_data

%% setup figure
figure('name','Long-term, chronic array recordings','visible','on','color','w');
box off
array_names = unique({human_array_data.array_name});
array_names_for_legend = unique({human_array_data.array_name});
colors = jet(length(array_names));
set(gcf,'pos',[350,200,1000,750])

%% Array Yield for Human Data

subplot(2,3,1:2); hold on;

iPlotName = 1;
for iArray = 1:length(array_names)
%     if contains(array_names{iArray},'P1') || contains(array_names{iArray},'P2') 
%     else
        file_count = 1;
        for iFile = 1:size(human_array_data,2)
            if strcmp(human_array_data(iFile).array_name,array_names{iArray})
                good_channels_temp(file_count) = human_array_data(iFile).num_good_channels_corrected / human_array_data(iFile).total_num_of_channels;
                relative_days_temp(file_count) = human_array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end
        
        if max(relative_days_temp) > (365*2)
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
        
        clear good_channels_temp
        clear relative_days_temp
%     end
end
ylabel('Percent Good Channels');
ylim([0 1]);
yticks(0:.25:1)
yticklabels({'0%' '25%' '50%' '75%' '100%'})
xlim([0 max([human_array_data.relative_days])]);
box off

legend([plots{:}],plot_names,'location','northeastoutside')

grid on
xlabel('Days Post Implantation');
title('a','units','normalized', 'Position', [-0.1,1.05,1]);
clear plot_names
clear plots


%% SNR for human data
subplot(2,3,4:5); hold on;

iPlotName = 1;
for iArray = 1:length(array_names)
%     if contains(array_names{iArray},'P1') || contains(array_names{iArray},'P2') 
%     else
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
title('b','units','normalized', 'Position', [-0.1,1.05,1]);
grid on
xlabel('Days Post Implantation');


%% initial signal recovery for human data - channel yield

% histcounts and average
iPlotName = 1;
for iArray = 1:length(array_names)
%     if contains(array_names{iArray},'P1') || contains(array_names{iArray},'P2')
%     else
        
        file_count = 1;
        for iFile = 1:size(human_array_data,2)
            if strcmp(human_array_data(iFile).array_name,array_names{iArray})
                good_channels_temp(file_count) = human_array_data(iFile).num_good_channels_corrected / human_array_data(iFile).total_num_of_channels;
                relative_days_temp(file_count) = human_array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end
        
        plot_names{iPlotName} = strrep(array_names{iArray},'_',' ');
        
        % linear regression of all points for each array separately
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
%     end
end

averaging_prep(averaging_prep == 0) = NaN;
for iColumn = 1:size(averaging_prep,2)
    averaging_count(iColumn) = sum(~isnan(averaging_prep(:,iColumn)));
end

% There is a challenge associated with averaging this kind of
% non-continuous data over time; you can't simply take a mean because there
% isn't data at every time point. not only that, but there are different
% numbers of data points at each time point as well. The approach I used
% here was to calculate a linear regression fit to all of the data points
% available for each array, bounded by the first and last recording point,
% giving me a bunch of lines. Then, I averaged across all the lines that
% were available for each time point. this creates some weird edge effects,
% and I'm sure I could do it better.

avg_channels = nanmean(averaging_prep,1);
avg_channels(isnan(avg_channels)) = 0;
std_channels = nanstd(averaging_prep,1);
std_channels(isnan(std_channels)) = 0;
std_err_channels = std_channels ./ sqrt(averaging_count);
std_err_channels(isnan(std_err_channels)) = 0;

%main plot
% subplot(2,4,1:3); hold on;

% creating a de-saturated, transparent version of the line color for the
% error bars:
HSV_color = rgb2hsv(colors(1,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

% patch() is a great way to create error bars.
% patch([1:length(avg_channels) fliplr(1:length(avg_channels))],[avg_channels+std_err_channels fliplr(avg_channels-std_err_channels)],patch_color,'edgecolor','none')
% plot(avg_channels,'linewidth',2,'Color',colors(1,:));
% xlim([0 1137])
% 
% 
% box off
% grid on
% xlabel('Days Post Implantation');
% ylabel('Channel Yield (proportion of total number)');
% title('a','units','normalized', 'Position', [-0.1,1.05,1]);


%inset plot
subplot(2,3,3); hold on;

patch([1:length(avg_channels) fliplr(1:length(avg_channels))],[avg_channels+std_err_channels fliplr(avg_channels-std_err_channels)],patch_color,'edgecolor','none')
plot(avg_channels,'linewidth',2,'Color',colors(1,:));
xlim([0 200])
title('b','units','normalized', 'Position', [-0.1,1.05,1]);

box off
xlabel('days post implantation');

clear averaging_prep
clear HSV_color
clear subject_lines
clear averaging_count

%% initial signal recovery for human data - SNR

iPlotName = 1;
for iArray = 1:length(array_names)
%     if contains(array_names{iArray},'P1') || contains(array_names{iArray},'P2')
%     else
        
        file_count = 1;
        for iFile = 1:size(human_array_data,2)
            if strcmp(human_array_data(iFile).array_name,array_names{iArray})
                if ~ischar(human_array_data(iFile).SNR_all_channels)
                    SNR_temp(file_count) = human_array_data(iFile).SNR_all_channels;
                    relative_days_temp(file_count) = human_array_data(iFile).relative_days;
                    file_count = file_count + 1;
                end
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
%     end
end

averaging_prep(averaging_prep == 0) = NaN;
for iColumn = 1:size(averaging_prep,2)
    averaging_count(iColumn) = sum(~isnan(averaging_prep(:,iColumn)));
end
avg_SNR = nanmean(averaging_prep,1);
avg_SNR(isnan(avg_SNR)) = 0;
std_SNR = nanstd(averaging_prep,1);
std_SNR(isnan(std_SNR)) = 0;
std_err_SNR = std_SNR ./ sqrt(averaging_count);
std_err_SNR(isnan(std_err_SNR)) = 0;

% subplot(2,4,5:7); hold on;

HSV_color = rgb2hsv(colors(2,:));
HSV_color(2) = HSV_color(2) * .6;
patch_color = hsv2rgb(HSV_color);

% patch([1:length(avg_SNR) fliplr(1:length(avg_SNR))],[avg_SNR-std_err_SNR fliplr(avg_SNR+std_err_SNR)],patch_color,'edgecolor','none')
% plot(avg_SNR,'linewidth',2,'Color',colors(2,:));
% xlim([0 1137])

% box off
% grid on
% xlabel('days post implantation');
% ylabel('SNR');
% title('c','units','normalized', 'Position', [-0.1,1.05,1]);
% 

%inset plot
subplot(2,3,6); hold on;

patch([1:length(avg_SNR) fliplr(1:length(avg_SNR))],[avg_SNR-std_err_SNR fliplr(avg_SNR+std_err_SNR)],patch_color,'edgecolor','none')
plot(avg_SNR,'linewidth',2,'Color',colors(2,:));
xlim([0 200])
title('d','units','normalized', 'Position', [-0.1,1.05,1]);

box off
xlabel('days post implantation');

clear averaging_prep
clear HSV_color
clear subject_lines

end