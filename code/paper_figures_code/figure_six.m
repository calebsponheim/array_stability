function figure_six(array_data)
%% Figure 6: Mean SNR at 3 month intervals.

% We broke out the results by brain area over time to see if there were
% meaningful differences in SNR between the areas from which we recorded.
% There are weaknesses to this data, namely the ENORMOUS std err bars,
% which increase over time with lower amts of data available.

% note: SNR stays stable because our analysis counts SNR from channels that
% are still responding :)

time_points_in_days = ((365/12)*3):((365/12)*3):(365*3);
one_month = 365/12;
array_names = unique({array_data.array_name});
all_array_names_temp = {array_data.array_name};
all_days_temp = [array_data.relative_days];
all_SNR_temp = [array_data.SNR_all_channels];
array_SNR = nan(numel(time_points_in_days),numel(array_names));
areas = {'PMd','PMv','M1'};
colors = hsv(numel(areas));

% I count four nested for statements! Wow! So efficient!
for iArea = 1:numel(areas)
    array_SNR = nan(length(time_points_in_days),length(array_names));
    for iArray = 1:length(array_names)
        if strfind(array_names{iArray},areas{iArea})
            array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
            array_relative_days = all_days_temp(array_files_index);
            array_SNR_per_file = all_SNR_temp(array_files_index);
            for iTimePoint = 1:length(time_points_in_days)
                ind_array_SNR = nan(numel(array_relative_days),1);
                for iFile = 1:length(array_relative_days)
                    % This takes a window around each three-month time
                    % point and averages all the data available within that
                    % window. If we took all the dates just at that time
                    % point, it would be very few, because this is
                    % discontinuous data:
                    if ((time_points_in_days(iTimePoint)- one_month) < array_relative_days(iFile)) && ...
                            (array_relative_days(iFile) < (time_points_in_days(iTimePoint)+ one_month))
                        ind_array_SNR(iFile) = array_SNR_per_file(iFile);
                    end
                end
                array_SNR(iTimePoint,iArray) = nanmean(ind_array_SNR);
                clear ind_array_SNR
            end
        end
    end
    
    for iRow = 1:size(array_SNR,1)
        SNR_count(iRow) = sum(~isnan(array_SNR(iRow,:)));
    end
    
    mean_array_SNR{iArea} = nanmean(array_SNR,2);
    mean_array_SNR{iArea}(isnan(mean_array_SNR{iArea})) = 0;
    std_array_SNR{iArea} = nanmean(array_SNR,2);
    std_err_SNR{iArea} = std_array_SNR{iArea} ./ sqrt(SNR_count');
    std_err_SNR{iArea}(isnan(std_err_SNR{iArea})) = 0;

end
%% plotting

figure('name','Long-term, chronic array recordings','visible','off','color','w'); hold on
for iArea = 1:numel(areas)

% desaturating the color for the error bars
HSV_color = rgb2hsv(colors(iArea,:));
HSV_color(2) = HSV_color(2) * 1;
patch_color = hsv2rgb(HSV_color);

% draw the patch first so it doesn't cover the line. patch() is very useful
patch([time_points_in_days/one_month fliplr(time_points_in_days/one_month)],[(mean_array_SNR{iArea}+std_err_SNR{iArea})'...
    fliplr((mean_array_SNR{iArea}-std_err_SNR{iArea})')],patch_color,'edgecolor','none')
alpha(0.4)

end
for iArea = 1:numel(areas)
plots{iArea} = plot(time_points_in_days/one_month,mean_array_SNR{iArea},'o-','linewidth',2,'color',colors(iArea,:));
end
xlabel('Months Post Implantation')
xticks(time_points_in_days/one_month);
legend([plots{:}],areas) %legend only for the lines, not the patches
ylabel('Signal to Noise Ratio')
box off

%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_six.png');
else
    saveas(gcf,'figure_six.png');
end

close(gcf);


end