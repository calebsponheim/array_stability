function electrode_length_figure(array_data)
% this script is intended to test for differences in longevity and quality
% between different groups of arrays with different qualities: Things like
% metallization, electrode length, etc.
%% Sampling distributions with replacement
number_of_samples = 30;
date_range(:,1) = [0,365/2,365,365+(365/2),365*2];
date_range(:,2) = [365/2,365,365+(365/2),365*2,365*2+(365/2)];
one_month = 365/12;
date_range_for_plotting = mean(date_range,2) / one_month;
array_names = unique({array_data.array_name});
snr_all_channels = [array_data.SNR_all_channels];
num_good_channels_corrected = [array_data.num_good_channels_corrected];
relative_days = [array_data.relative_days];
tot_num_channels = [array_data.total_num_of_channels];



short_count = 1;
long_count = 1;

for iArray = 1:numel(array_names)
    
    array_files_indices_temp = find(contains({array_data.array_name},array_names(iArray)));
    snr_array_temp = snr_all_channels(array_files_indices_temp);
    num_good_channels_array_temp = num_good_channels_corrected(array_files_indices_temp);
    relative_days_array_temp = relative_days(array_files_indices_temp);
    array_tot_num_channels = tot_num_channels(array_files_indices_temp(1));
    
    % Electrode Length
    
    if array_data(array_files_indices_temp(1)).electrode_length == 1
        for iWindow = 1:size(date_range,1)
            array_files_indices_temp_window = relative_days_array_temp >= date_range(iWindow,1) & relative_days_array_temp <= date_range(iWindow,2);
            if sum(array_files_indices_temp_window) > 0
                short_snr_distribution{iWindow}(short_count) = mean(snr_array_temp(array_files_indices_temp_window));
                %                 short_relative_days{iWindow}(short_count,:) = relative_days_array_temp(idx);
                short_percent_distribution{iWindow}(short_count) = mean(num_good_channels_array_temp) / array_tot_num_channels;
            end
        end
        short_count = short_count + 1;
    elseif array_data(array_files_indices_temp(1)).electrode_length == 1.5
        for iWindow = 1:size(date_range,1)
            array_files_indices_temp_window = relative_days_array_temp >= date_range(iWindow,1) & relative_days_array_temp <= date_range(iWindow,2);
            if sum(array_files_indices_temp_window) > 0
                long_snr_distribution{iWindow}(long_count) = mean(snr_array_temp(array_files_indices_temp_window));
                %                 long_relative_days{iWindow}(long_count,:) = relative_days_array_temp(idx);
                long_percent_distribution{iWindow}(long_count) = mean(num_good_channels_array_temp) / array_tot_num_channels;
            end
        end
        long_count = long_count + 1;
    end %if
    
end %iArray

clear long_count short_count irid_count plat_count array_files_indices_temp array_files_indices_temp_window array_tot_num_channels
% Removing Zeros
for iWindow = 1:size(date_range,1)
    short_snr_distribution{iWindow}(short_snr_distribution{iWindow} == 0) = [];
    long_snr_distribution{iWindow}(isnan(long_snr_distribution{iWindow})) = [];
    long_snr_distribution{iWindow}(long_snr_distribution{iWindow} == 0) = [];
    short_snr_distribution{iWindow}(isnan(short_snr_distribution{iWindow})) = [];
    
    short_percent_distribution{iWindow}(short_percent_distribution{iWindow} == 0) = [];
    long_percent_distribution{iWindow}(isnan(long_percent_distribution{iWindow})) = [];
    long_percent_distribution{iWindow}(long_percent_distribution{iWindow} == 0) = [];
    short_percent_distribution{iWindow}(isnan(short_percent_distribution{iWindow})) = [];
end
%% Calculating Statistics

% bonferroni correction
p_thresh = (.05)/size(date_range,1);

for iWindow = 1:size(date_range,1)
    % Electrode Length
    mean_short_snr(iWindow) = mean(reshape(short_snr_distribution{iWindow},1,[]));
    std_err_short_snr(iWindow) = std(reshape(short_snr_distribution{iWindow},1,[])) / sqrt(numel(reshape(short_snr_distribution{iWindow},1,[])));
    mean_long_snr(iWindow) = mean(reshape(long_snr_distribution{iWindow},1,[]));
    std_err_long_snr(iWindow) = std(reshape(long_snr_distribution{iWindow},1,[])) / sqrt(numel(reshape(long_snr_distribution{iWindow},1,[])));
    
    mean_short_percent(iWindow) = mean(reshape(short_percent_distribution{iWindow},1,[]));
    std_err_short_percent(iWindow) = std(reshape(short_percent_distribution{iWindow},1,[])) / sqrt(numel(reshape(short_percent_distribution{iWindow},1,[])));
    mean_long_percent(iWindow) = mean(reshape(long_percent_distribution{iWindow},1,[]));
    std_err_long_percent(iWindow) = std(reshape(long_percent_distribution{iWindow},1,[])) / sqrt(numel(reshape(long_percent_distribution{iWindow},1,[])));
    
    [p_snr,~,~] = ranksum(reshape(short_snr_distribution{iWindow},1,[]),reshape(long_snr_distribution{iWindow},1,[]));
    [p_percent,~,~] = ranksum(reshape(short_percent_distribution{iWindow},1,[]),reshape(long_percent_distribution{iWindow},1,[]));
    
    if p_snr <= p_thresh
        length_test_snr(iWindow) = 1;
    else
        length_test_snr(iWindow) = 0;
    end
    if p_percent <= p_thresh
        length_test_percent(iWindow) = 1;
    else
        length_test_percent(iWindow) = 0;
    end
    
    
end

%% Plotting
figure('visible','off','color','w','pos',[100 100 500 400]); hold on

% subplot one: Length Channel Percent

colors = hsv(2);

subplot(1,2,1); hold on;

% plot std err patches
patch([date_range_for_plotting' fliplr(date_range_for_plotting')],[(mean_short_percent+std_err_short_percent)...
    fliplr((mean_short_percent-std_err_short_percent))],colors(1,:),'edgecolor','none')
alpha(.4)

patch([date_range_for_plotting' fliplr(date_range_for_plotting')],[(mean_long_percent+std_err_long_percent)...
    fliplr((mean_long_percent-std_err_long_percent))],colors(2,:),'edgecolor','none')
alpha(.4)
% plot mean lines w/ dots
plot(date_range_for_plotting, mean_short_percent,'o-','Color',colors(1,:));
plot(date_range_for_plotting, mean_long_percent,    'o-','Color',colors(2,:));
% plot significance stars
plot(date_range_for_plotting(find(length_test_percent)), length_test_percent(find(length_test_percent))*.75,'*k')

legend({'Short','Long'},'Location','SouthEast')
xlabel('Months Post Implantation')
xticks(date_range_for_plotting)
ylabel('Percent Good Channels');
ylim([0 1]);
yticks(0:.25:1)
yticklabels({'0%' '25%' '50%' '75%' '100%'})
title('a','units','normalized', 'Position', [-0.1,1.05,1]);

% subplot two: Length SNR
subplot(1,2,2); hold on;

% plot std err patches
patch([date_range_for_plotting' fliplr(date_range_for_plotting')],[(mean_short_snr+std_err_short_snr)...
    fliplr((mean_short_snr-std_err_short_snr))],colors(1,:),'edgecolor','none')
alpha(.4)

patch([date_range_for_plotting' fliplr(date_range_for_plotting')],[(mean_long_snr+std_err_long_snr)...
    fliplr((mean_long_snr-std_err_long_snr))],colors(2,:),'edgecolor','none')
alpha(.4)
% plot mean lines w/ dots
plot(date_range_for_plotting, mean_short_snr,'o-','Color',colors(1,:));
plot(date_range_for_plotting, mean_long_snr,    'o-','Color',colors(2,:));
% plot significance stars
plot(date_range_for_plotting(find(length_test_snr)), length_test_snr(find(length_test_snr))*3.2,'*k')

legend({'Short','Long'},'Location','SouthEast')
xlabel('Months Post Implantation')
xticks(date_range_for_plotting)
ylabel('Signal to Noise Ratio (SNR)');
ylim([0 3.25])
title('b','units','normalized', 'Position', [-0.1,1.05,1]);

%% Saving
if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\supplementary_figures\electrode_length_figure.png');
else
    saveas(gcf,'electrode_length_figure.png');
end

close(gcf);

end % End of Function