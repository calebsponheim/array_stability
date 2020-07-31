function [] = plot_summary_function(array_data)
% this script plots an individual array's recording's Channel yield over
% time.


%% read data in
%read data from mat-file
array_names = unique({array_data.array_name});


%% plot

for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            good_channels_temp(file_count) = array_data(iFile).num_good_channels_corrected;
            relative_days_temp(file_count) = array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end
    figure('color','w','visible','off'); hold on
        
    plot(relative_days_temp,good_channels_temp,'o','linewidth',2);
    ylabel('number of good channels');
    ylim([0 100]);
    xlim([0 max(relative_days_temp)]);
    
    ax = gca; ax.FontSize = 14; ax.LineWidth = 1.5;  ax.XColor = 'k'; ax.YColor = 'k';
    box off
    grid on
    xlabel('days post implantation');
    title([strrep(array_names{iArray},'_',' ') ' Array yield across time (SNR>1.5)'],'FontSize',18);
    set(gcf,'position',[161,223,1369,538]);
    
    if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
        saveas(gcf,['C:\Users\calebsponheim\Documents\git\array_stability\figures\' array_names{iArray} '_summary.png']);
    else
        saveas(gcf,[array_names{iArray} '_summary.png']);
    end
    close(gcf);
    clear good_channels_temp
    clear relative_days_temp
end
end
