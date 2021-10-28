%% Plotting IMplant lifetime by implant date
figure('visible','on'); hold on
array_names = unique({array_data.array_name});

for iArray = 1:length(array_names)
    file_count = 1;
    for iFile = 1:size(array_data,2)
        if strcmp(array_data(iFile).array_name,array_names{iArray})
            relative_days_temp(file_count) = array_data(iFile).relative_days;
            implant_date_temp(file_count) = array_data(iFile).implantation_date;
            file_count = file_count + 1;
        end
    end
    implant_date(iArray) = implant_date_temp(end)/365;
    relative_days(iArray) = max(relative_days_temp)/365;
    plot(implant_date_temp(end)/365 + 2000,max(relative_days_temp)/365,'.','markersize',10,'color','b');
    clear implant_date_temp
    clear relative_days_temp
end

regression = fitlm(implant_date,relative_days);
rsquared = regression.Rsquared.Ordinary;

[r_corr,p_corr] = corrcoef(implant_date,relative_days);
box off
set(gcf,'color','w')
xlabel('implant date (year)')
ylabel('array longevity (years)')

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\longevity_by_implant_date.png');
else
    saveas(gcf,'longevity_by_implant_date.png');
end

close(gcf);

