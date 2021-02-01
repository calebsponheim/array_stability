function summary_heatmap_figure(array_data)
%% Figure 3. Summary heat map with array number and Days Post Implant on y and x axes and \
% color denoting number of units or mean SNR.

% This is meant to be a summary figure of all the data; I'm not sure how
% well it serves that purpose at the moment. The plot displays four
% different variables: time, array number, SNR, and channel yield.
array_names = unique({array_data.array_name});
array_names_abbrev = unique([array_data.array_name_abbrev]);
% Generating Lifetime Length Order
for iArray = 1:numel(array_names)
    file_count = 1;
    % three columns:
    %
    % 1 - the array number in the list
    lifetime_order{iArray,1} = iArray;
    
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray}) %&& strcmp(array_data(iFile).species,'NHP')
            relative_days_temp(file_count) = array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end

    % 2 - the maximum relative days of that array
    
    lifetime_order{iArray,2} = max(relative_days_temp);
    lifetime_order{iArray,4} = array_names_abbrev{iArray};
    clear relative_days_temp
    clear file_count
end

% (order it by max days)

[~, sort_order] = sort([lifetime_order{:,2}],'ascend');
temp_order = sort([lifetime_order{:,1}],'descend');
for iArray = 1:size(lifetime_order,1)
    lifetime_order{iArray,3} = sort_order(iArray);
    lifetime_order{iArray,1} = temp_order(iArray);
end
% 3 - numbered order after sorting
%
% (resort by array number)
%

for iArray = 1:numel(array_names)
    for iFile = 1:length(array_data)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            implant_order(iFile,1) = lifetime_order{([lifetime_order{:,3}] == iArray),1};
            implant_name{iFile} = array_names_abbrev(iArray);
        end
    end
end

all_SNR = [array_data.SNR_all_channels];
all_SNR = all_SNR(~isnan(all_SNR));
all_percent_channels = (([array_data.num_good_channels_corrected] ./ [array_data.total_num_of_channels])+.01);
all_percent_channels = all_percent_channels(~isnan(all_SNR));
all_relative_days = [array_data.relative_days];
all_relative_days = all_relative_days(~isnan(all_SNR));
implant_order = implant_order(~isnan(all_SNR));

figure('name','Long-term, chronic array recordings','visible','off','color','w'); hold on
scatter(all_relative_days,implant_order,all_percent_channels*100,all_SNR,'filled')
box off
ax1 = gca;
colormap(cool(6));
c = colorbar('location','manual','position',[.585,.5,.03,.17]);
hL = ylabel(c,'Signal to Noise Ratio');     
set(hL,'Rotation',0,'Position',[.5,0,0]);
hold off

% plotting the main figure
hold(ax1, 'on');
xlabel('Days post-implant');
ylabel('Implant Order (By Lifetime Length)');
xticks(0:250:3250)  
ylim([0 max(implant_order)+1])
yticks(0:max(implant_order)+1)
yticklabels(vertcat(' ',flip(lifetime_order(sort_order,4))))



set(gcf,'pos',[0,0,750,925])
set(gca,'TickDir','out')

% plotting the "dot size" legend (which is actually a plot, but small)
ax2 = axes('Position',[.55 .78 .1 .125]);

% I know it's hacky it's very hacky but I'm proud of it okay
scatter([1,1,1,1,1],[1,2,3,4,5],[.01,.25,.5,.75,1]*100,'k','filled')
text([1,1,1,1,1]+.1,[1,2,3,4,5],cellstr({'1%' '25%' '50%' '75%' '100%'}),'HorizontalAlignment', 'Left','FontSize',8)
text(1, 0.25,'Percent of Available Electrodes','HorizontalAlignment','Center','FontSize',8)
text(1, -.25,'By Marker Size','HorizontalAlignment','Center','FontSize',8)
xlim([.75 1.25])
set(gca, 'visible', 'off')
hold off


%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\summary_heatmap.png');
else
    saveas(gcf,'summary_heatmap.png');
end

close(gcf);


end