function plot_all_data(array_data)
% This script plots each array, and plots its linear regression. Adapted
% from Vassilis Papadourakis.
%% read data in
%read data from xls
array_names = unique({array_data.array_name});


%% plot
figure('color','w','visible','off'); hold on
for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            good_channels_temp(file_count) = array_data(iFile).num_good_channels_corrected;
            relative_days_temp(file_count) = array_data(iFile).relative_days;
            file_count = file_count + 1;
        end
    end
    color = [rand rand rand];
    
    plot(relative_days_temp,good_channels_temp,'.','linewidth',1,'color',color);
    
    quad_fit_to_good_channels = polyfit(relative_days_temp,good_channels_temp,1);
    quad_fit_to_good_channels = polyval(quad_fit_to_good_channels,min(relative_days_temp):.1:max(relative_days_temp));
    
    if max(quad_fit_to_good_channels)>128
        disp('stop, who are you even')
    else
        plot(min(relative_days_temp):.1:max(relative_days_temp),quad_fit_to_good_channels,'-','color',color,'linewidth',2)
    end
    
    clear good_channels_temp
    clear relative_days_temp
end
ylabel('number of good channels');
ylim([0 max([array_data.num_good_channels_corrected])]);
xlim([0 max([array_data.relative_days])]);

ax = gca; ax.FontSize = 14; ax.LineWidth = 1.5;  ax.XColor = 'k'; ax.YColor = 'k';
box off
grid on
xlabel('days post implantation');
title('all arrays channel count over time','FontSize',18);

set(gcf,'position',[161,223,1369,538]);

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\all_data_summary.png');
else
    saveas(gcf,[array_names{iArray} '_summary.png']);
end
close(gcf);

end