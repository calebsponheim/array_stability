function figure_three(array_data)
%% Figure 3. Summary heat map with array number and Days Post Implant on y and x axes and \
    % color denoting number of units or mean SNR. 

implant_date_to_order = 1:length(unique([array_data.implantation_date]));
unique_implant_dates = unique([array_data.implantation_date]);
for iDate = 1:length(implant_date_to_order)
    implant_order([array_data.implantation_date] == unique_implant_dates(iDate)) = implant_date_to_order(iDate);
end
figure('name','Long-term, chronic array recordings','visible','off','color','w'); hold on  
scatter([array_data.relative_days],implant_order,...
    ([array_data.num_good_channels_corrected]+.01)*3,...
    [array_data.SNR_all_channels],'filled')
box off
xlabel('days post implant (days)');
ylabel('Implant Number (chronological order)');
title('Summary heat map: array order/DPI/num channels(size)/SNR(color)');
xlim([0 max([array_data.relative_days])])
xticks(0:250:3250)
ylim([0 max(implant_date_to_order)+1])
colormap(jet);
colorbar;
set(gcf,'pos',[400,400,1500,500])
set(gca,'TickDir','out')

%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_three.png');
else
    saveas(gcf,'figure_three.png');
end

close(gcf);


end