function figure_one(array_data)

figure('name','Long-term, chronic array recordings','visible','off','color','w');
box off
array_names = unique({array_data.array_name});
colors = jet(length(array_names));
set(gcf,'pos',[350,200,1000,750])
%% Figure 1a. Examples from 3 arrays lasting over 2 years including Mack’s
% lasting 9 years as a function of days post implantation (DPI)
% with an SNR threshold of 1.5 (or 2) (3 line graphs).

subplot(2,3,1:3); hold on;

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
    
    if max(relative_days_temp) > (365*2)
        plot_names{iPlotName} = strrep(array_names{iArray},'_',' ');
        plot(relative_days_temp,good_channels_temp,'.','linewidth',1,'color',colors(iArray,:));
        quad_fit_to_good_channels = polyfit(relative_days_temp,good_channels_temp,1);
        quad_fit_to_good_channels = ...
            polyval(quad_fit_to_good_channels,min(relative_days_temp):.1:max(relative_days_temp));
        
        if max(quad_fit_to_good_channels)>128
            disp('stop, who are you even')
        else
            plots{iPlotName} = ...
                plot(min(relative_days_temp):.1:max(relative_days_temp),...
                quad_fit_to_good_channels,'-','color',colors(iArray,:),'linewidth',2);
        end
        iPlotName = iPlotName + 1;
    end
    
    clear good_channels_temp
    clear relative_days_temp
end
ylabel('proportion good channels');
ylim([0 1]);
xlim([0 max([array_data.relative_days])]);
box off

legend([plots{:}],plot_names,'location','northeastoutside')

grid on
xlabel('days post implantation');
title('all arrays channel yield over time');

clear plot_names
clear plots
%% Figure 1b. Example spike waveforms at specific time points from
% these 3 arrays.

subplot(2,3,4); hold on;

t = text(0.1,.5,{'waveform', 'examples','go here'});
t.FontSize = 24;


%% Figure 1c. Mean SNR versus DPI for three example arrays (3 line graphs).

subplot(2,3,5:6); hold on;

iPlotName = 1;
for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            if ~ischar(array_data(iFile).SNR_all_channels)
                SNR_temp(file_count) = array_data(iFile).SNR_all_channels;
                relative_days_temp(file_count) = array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end
    end
    color = [rand rand rand];
    
    if max(relative_days_temp) > (365*2)
        plot_names{iPlotName} = strrep(array_names{iArray},'_',' ');
        plot(relative_days_temp,SNR_temp,'.','linewidth',1,'color',colors(iArray,:));
        quad_fit_to_SNR = polyfit(relative_days_temp,SNR_temp,1);
        quad_fit_to_SNR = polyval(quad_fit_to_SNR,min(relative_days_temp):.1:max(relative_days_temp));
        
        if max(quad_fit_to_SNR)>128
        else
            plots{iPlotName} = ...
                plot(min(relative_days_temp):.1:max(relative_days_temp),...
                quad_fit_to_SNR,'-','color',colors(iArray,:),'linewidth',2);
        end
        iPlotName = iPlotName + 1;
    end
    
    clear SNR_temp
    clear relative_days_temp
end
ylabel('Signal to Noise Ratio');
ylim([0 max([array_data.SNR_all_channels])]);
xlim([0 max([array_data.relative_days])]);
box off

legend([plots{:}],plot_names,'location','northeastoutside')
title('all arrays SNR over time');

grid on
xlabel('days post implantation');

%% Save

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_one.png');
else
    saveas(gcf,'figure_one.png');
end

close(gcf);

end