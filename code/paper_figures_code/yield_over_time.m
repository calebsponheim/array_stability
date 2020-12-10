function yield_over_time(array_data)
% Figure 4. percent of arrays with yield >20% over different time points:
% The goal of this graph is to see how the yield more systematically
% decreases, communicating kind of a set of "expectations" you might have
% about your given array's performance over time.

% three different channel yield thresholds.

%% Calculating everything

time_points_in_days = [0,((365/12)*1),((365/12)*3):((365/12)*3):(365*3)];
one_month = 365/12;
array_names = unique({array_data.array_name});
yield_threshold(:,1) = round([array_data.total_num_of_channels]*.1);
yield_threshold(:,2) = round([array_data.total_num_of_channels]*.2);
yield_threshold(:,3) = round([array_data.total_num_of_channels]*.4);

all_array_names_temp = {array_data.array_name};
all_days_temp = [array_data.relative_days];
all_good_channels_temp = [array_data.num_good_channels_corrected];

for iThresh = 1:size(yield_threshold,2)
    num_arrays_above_threshold = zeros(numel(time_points_in_days),1);
    num_arrays_in_window = zeros(numel(time_points_in_days),1);
    for iArray = 1:length(array_names)
        
        array_files_index = cellfun(@(x) strcmp(x,array_names{iArray}),all_array_names_temp);
        array_relative_days = all_days_temp(array_files_index);
        array_yield_thresh = yield_threshold(array_files_index,iThresh)';
        array_num_good_channels = all_good_channels_temp(array_files_index);
        
        for iTimePoint = 1:length(time_points_in_days)
            file_above_thresh = 0;
            count_array_in_proportion = 0;
            for iFile = 1:length(array_relative_days)
                % we take a window of time around each three month point in
                % order to capture enough data points to make an average.
                % We have no guarantee that enough data was recorded at
                % exact three-month intervals, so we have to average across
                % a rough time window.
                
                if max(array_relative_days) > (time_points_in_days(iTimePoint)- one_month)
                    if (((time_points_in_days(iTimePoint)- one_month) < array_relative_days(iFile)) && ...
                            (array_relative_days(iFile) < (time_points_in_days(iTimePoint)+ one_month))) && ...
                            (array_num_good_channels(iFile) > array_yield_thresh(iFile))
                        file_above_thresh = 1;
                        count_array_in_proportion = 1;
                    elseif (((time_points_in_days(iTimePoint)- one_month) < array_relative_days(iFile)) && ...
                            (array_relative_days(iFile) < (time_points_in_days(iTimePoint)+ one_month)))
                        count_array_in_proportion = 1;
                    end
                elseif  max(array_relative_days) < (time_points_in_days(iTimePoint)- one_month)
                    count_array_in_proportion = 1;
                end
            end
            num_arrays_above_threshold(iTimePoint) = num_arrays_above_threshold(iTimePoint) + file_above_thresh;
            num_arrays_in_window(iTimePoint) = num_arrays_in_window(iTimePoint) + count_array_in_proportion;
        end
    end
    
    for iTimePoint = 1:length(time_points_in_days)
        percent_arrays_above_threshold(iTimePoint,iThresh) = num_arrays_above_threshold(iTimePoint) / num_arrays_in_window(iTimePoint);
    end
    clear num_arrays_above_threshold
    clear num_arrays_in_window
end

%% plotting everything
colors = winter(3); % the only color scale, with three colors, that doesn't include bright yellow (yuck)
figure('name','Long-term, chronic array recordings','visible','off','color','w'); hold on
plot(time_points_in_days/one_month,percent_arrays_above_threshold(:,1)...
    ,'o-','linewidth',2,'color',colors(1,:),'Displayname','10% Yield')
plot(time_points_in_days/one_month,percent_arrays_above_threshold(:,2)...
    ,'o-','linewidth',2,'color',colors(2,:),'Displayname','20% Yield')
plot(time_points_in_days/one_month,percent_arrays_above_threshold(:,3)...
    ,'o-','linewidth',2,'color',colors(3,:),'Displayname','40% Yield')
xlabel('Months Post Implantation')
legend()
xticks(time_points_in_days/one_month);
ylabel('Proportion of Arrays with Certain Yields')
set(gcf,'pos',[1150,400,700,500])
box off

clear num_arrays_above_threshold
%% Saving

if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\yield_over_time.png');
else
    saveas(gcf,'yield_over_time.png');
end

close(gcf);


end