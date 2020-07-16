function figure_three(array_data)
%% Figure 3. Summary heat map with array number and Days Post Implant on y and x axes and \
    % color denoting number of units or mean SNR. 
array_names = unique({array_data.array_name});    
for iArray = 1:length(unique({array_data.array_name}))
for iFile = 1:length(array_data)
    if strcmp(array_data(iFile).array_name,array_names{iArray})
        implant_order(iFile) = iArray;
    end
end
end
    
figure('name','Long-term, chronic array recordings','visible','off','color','w'); hold on  
scatter([array_data.relative_days],implant_order,...
    (([array_data.num_good_channels_corrected] ./ [array_data.total_num_of_channels])+.01)*75,...
    round([array_data.SNR_all_channels],0),'filled')
box off
xlabel('days post implant (days)');
ylabel('Implant Number');
title('Summary heat map: array order/DPI/num channels(size)/SNR(color)');
xlim([0 max([array_data.relative_days])])
xticks(0:250:3250)
ylim([0 max(implant_order)+1])
colormap(jet);
colorbar;
set(gcf,'pos',[0,0,750,500])
set(gca,'TickDir','out')

%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_three.png');
else
    saveas(gcf,'figure_three.png');
end

close(gcf);


end