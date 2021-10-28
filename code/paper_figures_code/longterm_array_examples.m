function longterm_array_examples(array_data)
% Figure 1a. Examples from 3 arrays lasting over 2 years including Mack’s
% lasting 9 years as a function of days post implantation (DPI)
% with an SNR threshold of 1.5 (or 2) (3 line graphs).

% This figure, I think, is the real summary figure. It only shows results
% from arrays that lasted longer than two years, but we have a lot of
% those.
%%
figure('name','Long-term, chronic array recordings','visible','off','color','w');
box off
array_names = unique({array_data.array_name});
array_names_for_legend = unique([array_data.array_name_abbrev]);
colors = [[141,211,199];...
[255,127,0];...
[190,186,218];...
[251,128,114];...
[128,177,211];...
[253,180,98];...
[179,222,105];...
[252,205,229];...
[217,217,217];...
[188,128,189]]/255;
% Making Dot Colors (less saturated)

HSV = rgb2hsv(colors);
% "20% more" saturation:
HSV(:, 2) = HSV(:, 2) * 0;
% or add:
% HSV(:, :, 2) = HSV(:, :, 2) + 0.2;
HSV(HSV > 1) = 1;  % Limit values
colors_dots = hsv2rgb(HSV);


set(gcf,'pos',[350,200,1000,750])

%%

% subplot spans were used to make the plots size correctly.
subplot(2,2,1:2); hold on;

for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            good_channels_temp(file_count) = array_data(iFile).num_good_channels_corrected / array_data(iFile).total_num_of_channels;
            relative_days_temp(file_count) = array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end
    if max(relative_days_temp) > 950
%         plot(relative_days_temp,good_channels_temp,'.','markersize',5,'color',colors_dots(iArray,:));
    end
    clear good_channels_temp
    clear relative_days_temp

end
iPlotName = 1;
color_count = 1;
for iArray = 1:length(array_names)
    %     if contains(array_names{iArray},'P1') || contains(array_names{iArray},'P2')
    %     else
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            good_channels_temp(file_count) = array_data(iFile).num_good_channels_corrected / array_data(iFile).total_num_of_channels;
            relative_days_temp(file_count) = array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end
     
    if max(relative_days_temp) > 950
        if strcmp(array_names{iArray},'P1_A') || strcmp(array_names{iArray},'P1_P')
            plot_names{iPlotName} = strrep(array_names_for_legend{iArray},'_',' ');
            % First Half
            quad_fit_to_good_channels = fitlm(relative_days_temp(relative_days_temp <= 563),good_channels_temp(relative_days_temp <= 563));
            plots{iPlotName} = ...
                plot([min(relative_days_temp(relative_days_temp <= 563)),max(relative_days_temp(relative_days_temp <= 563))],...
                [quad_fit_to_good_channels.Fitted(1),quad_fit_to_good_channels.Fitted(end)],'-','color',colors(color_count,:),'linewidth',2);
            quad_fit_first = quad_fit_to_good_channels.Fitted;
            % Second Half
            quad_fit_to_good_channels = fitlm(relative_days_temp(relative_days_temp > 563),good_channels_temp(relative_days_temp > 563));
            plot([min(relative_days_temp(relative_days_temp > 563)),max(relative_days_temp(relative_days_temp > 563))],...
                [quad_fit_to_good_channels.Fitted(1),quad_fit_to_good_channels.Fitted(end)],'-','color',colors(color_count,:),'linewidth',2);
            
%                         plot(relative_days_temp,good_channels_temp,'.','markersize',5,'color',colors(color_count,:));

            line([563,575],[quad_fit_first(end),quad_fit_to_good_channels.Fitted(1)],'LineStyle',':','color',colors(color_count,:),'Linewidth',2)
            iPlotName = iPlotName + 2;
            color_count = color_count + 1;
        else
            plot_names{iPlotName} = strrep(array_names_for_legend{iArray},'_',' ');
            
            quad_fit_to_good_channels = fitlm(relative_days_temp,good_channels_temp);
            
            
            if max(quad_fit_to_good_channels.Fitted)>1
                disp('stop, who are you even')
            elseif mod(iPlotName,2) == 1
                 plots{iPlotName} = plot([min(relative_days_temp),max(relative_days_temp)],...
                    [quad_fit_to_good_channels.Fitted(1),quad_fit_to_good_channels.Fitted(end)],'-','color',colors(color_count,:),'linewidth',2);
            else
                 plots{iPlotName} = plot([min(relative_days_temp),max(relative_days_temp)],...
                    [quad_fit_to_good_channels.Fitted(1),quad_fit_to_good_channels.Fitted(end)],'-','color',colors(color_count,:),'linewidth',2);
            end
%                         plot(relative_days_temp,good_channels_temp,'.','markersize',5,'color',colors(color_count,:));
            iPlotName = iPlotName + 1;
            color_count = color_count + 1;
        end
    end
    
    clear good_channels_temp
    clear relative_days_temp
    %     end
end



ylabel('Percent Good Channels');
ylim([0 1]);
yticks(0:.25:1)
yticklabels({'0%' '25%' '50%' '75%' '100%'})
xlim([0 max([array_data.relative_days])]);
box off

legend([plots{:}],plot_names(~cellfun(@isempty,plot_names)),'location','northeastoutside')

grid on
xlabel('Days Post-Implantation');
title('a','units','normalized', 'Position', [-0.1,1.05,1]);
clear plot_names
clear plots
%% Figure 1b. Example spike waveforms at specific time points from
% these 3 arrays.


% This literally just makes space for the waveform pictures that I put in
% manually post-hoc. If I have time (hello readers), I'll write code to
% actually pull in specific waveforms from specific files and have it be
% all nice. for now, it's hacky. Whoops!

subplot(2,2,3); hold on;

title('b','units','normalized', 'Position', [-0.3,1.05,1]);
set(gca, 'Color','w', 'XColor','w', 'YColor','w')


%% Figure 1c. Mean SNR versus DPI for three example arrays (3 line graphs).

subplot(2,2,4); hold on;

iPlotName = 1;
color_count = 4;
for iArray = 1:length(array_names)
    %     if contains(array_names{iArray},'P1') || contains(array_names{iArray},'P2')
    %     else
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,'Mack_M1mb')
            if ~ischar(array_data(iFile).SNR_all_channels) && ~isnan(array_data(iFile).SNR_all_channels)
                SNR_temp(file_count) = array_data(iFile).SNR_all_channels;
                relative_days_temp(file_count) = array_data(iFile).relative_days;
                file_count = file_count + 1;
            end
        end
    end
    
    if (max(relative_days_temp) > 1000) && (strcmp(array_names{iArray},'Mack_M1mb'))
        plot_names{iPlotName} = strrep(array_names_for_legend{iArray},'_',' ');
        plot(relative_days_temp,SNR_temp,'.','linewidth',1,'color',colors(color_count,:));
        
        % Linear Regression to each array's data points.
        quad_fit_to_SNR = polyfit(relative_days_temp,SNR_temp,1);
        quad_fit_to_SNR = polyval(quad_fit_to_SNR,min(relative_days_temp):1:max(relative_days_temp));
        
        if max(quad_fit_to_SNR)>128
        else
            plots{iPlotName} = ...
                plot(min(relative_days_temp):1:max(relative_days_temp),...
                quad_fit_to_SNR,'-','color',colors(color_count,:),'linewidth',2);
        end
        iPlotName = iPlotName + 1;
    end
    
    clear SNR_temp
    clear relative_days_temp
    %     end
end
ylabel('Signal to Noise Ratio');
ylim([0 max([array_data.SNR_all_channels])]);
xlim([0 max([array_data.relative_days])]);
box off

legend([plots{:}],plot_names,'location','northeast')
title('c','units','normalized', 'Position', [-0.1,1.05,1]);
grid on
xlabel('Days Post-Implantation');

%% Save

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\longterm_array_examples.png');
else
    saveas(gcf,'longterm_array_examples.png');
end

close(gcf);

end