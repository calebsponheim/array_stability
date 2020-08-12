function figure_seven(array_data)
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



plat_count = 1;
irid_count = 1;
short_count = 1;
long_count = 1;

for iArray = 1:numel(array_names)
    
    array_files_indices_temp = find(contains({array_data.array_name},array_names(iArray)));
    snr_array_temp = snr_all_channels(array_files_indices_temp);
    num_good_channels_array_temp = num_good_channels_corrected(array_files_indices_temp);
    relative_days_array_temp = relative_days(array_files_indices_temp);
    array_tot_num_channels = tot_num_channels(array_files_indices_temp(1));
    
    % Metallization
    
    if contains(array_data(array_files_indices_temp(1)).metallization,'Platinum')
        for iWindow = 1:size(date_range,1)
            array_files_indices_temp_window = relative_days_array_temp >= date_range(iWindow,1) & relative_days_array_temp <= date_range(iWindow,2);
            if sum(array_files_indices_temp_window) > 0
                [platinum_snr_distribution{iWindow}(plat_count,:),idx] = datasample(snr_array_temp(array_files_indices_temp_window),number_of_samples);
%                 platinum_relative_days{iWindow}(plat_count,:) = relative_days_array_temp(idx);
                platinum_percent_distribution{iWindow}(plat_count,:) = num_good_channels_array_temp(idx) / array_tot_num_channels;
            end
        end
        plat_count = plat_count + 1;
    elseif contains(array_data(array_files_indices_temp(1)).metallization,'Iridium Oxide')
        for iWindow = 1:size(date_range,1)
            array_files_indices_temp_window = relative_days_array_temp >= date_range(iWindow,1) & relative_days_array_temp <= date_range(iWindow,2);
            if sum(array_files_indices_temp_window) > 0
                [irid_snr_distribution{iWindow}(irid_count,:),idx] = datasample(snr_array_temp(array_files_indices_temp_window),number_of_samples);
%                 irid_relative_days{iWindow}(irid_count,:) = relative_days_array_temp(idx);
                irid_percent_distribution{iWindow}(irid_count,:) = num_good_channels_array_temp(idx) / array_tot_num_channels;
            end
        end
        irid_count = irid_count + 1;
    end %if
    
    % Electrode Length
    
    if array_data(array_files_indices_temp(1)).electrode_length == 1
        for iWindow = 1:size(date_range,1)
            array_files_indices_temp_window = relative_days_array_temp >= date_range(iWindow,1) & relative_days_array_temp <= date_range(iWindow,2);
            if sum(array_files_indices_temp_window) > 0
                [short_snr_distribution{iWindow}(short_count,:),idx] = datasample(snr_array_temp(array_files_indices_temp_window),number_of_samples);
%                 short_relative_days{iWindow}(short_count,:) = relative_days_array_temp(idx);
                short_percent_distribution{iWindow}(short_count,:) = num_good_channels_array_temp(idx) / array_tot_num_channels;
            end
        end
        short_count = short_count + 1;
    elseif array_data(array_files_indices_temp(1)).electrode_length == 1.5
        for iWindow = 1:size(date_range,1)
            array_files_indices_temp_window = relative_days_array_temp >= date_range(iWindow,1) & relative_days_array_temp <= date_range(iWindow,2);
            if sum(array_files_indices_temp_window) > 0
                [long_snr_distribution{iWindow}(long_count,:),idx] = datasample(snr_array_temp(array_files_indices_temp_window),number_of_samples);
%                 long_relative_days{iWindow}(long_count,:) = relative_days_array_temp(idx);
                long_percent_distribution{iWindow}(long_count,:) = num_good_channels_array_temp(idx) / array_tot_num_channels;
            end
        end
        long_count = long_count + 1;
    end %if
    
end %iArray

clear long_count short_count irid_count plat_count array_files_indices_temp array_files_indices_temp_window array_tot_num_channels
% Removing Zeros
for iWindow = 1:size(date_range,1)    
    platinum_snr_distribution{iWindow}(platinum_snr_distribution{iWindow} == 0) = [];
    platinum_snr_distribution{iWindow}(isnan(platinum_snr_distribution{iWindow})) = [];
    irid_snr_distribution{iWindow}(irid_snr_distribution{iWindow} == 0) = [];
    irid_snr_distribution{iWindow}(isnan(irid_snr_distribution{iWindow})) = [];
    short_snr_distribution{iWindow}(short_snr_distribution{iWindow} == 0) = [];
    long_snr_distribution{iWindow}(isnan(long_snr_distribution{iWindow})) = [];
    long_snr_distribution{iWindow}(long_snr_distribution{iWindow} == 0) = [];
    short_snr_distribution{iWindow}(isnan(short_snr_distribution{iWindow})) = [];
    
    platinum_percent_distribution{iWindow}(platinum_percent_distribution{iWindow} == 0) = [];
    platinum_percent_distribution{iWindow}(isnan(platinum_percent_distribution{iWindow})) = [];
    irid_percent_distribution{iWindow}(irid_percent_distribution{iWindow} == 0) = [];
    irid_percent_distribution{iWindow}(isnan(irid_percent_distribution{iWindow})) = [];
    short_percent_distribution{iWindow}(short_percent_distribution{iWindow} == 0) = [];
    long_percent_distribution{iWindow}(isnan(long_percent_distribution{iWindow})) = [];
    long_percent_distribution{iWindow}(long_percent_distribution{iWindow} == 0) = [];
    short_percent_distribution{iWindow}(isnan(short_percent_distribution{iWindow})) = [];
end
%% Calculating Statistics

for iWindow = 1:size(date_range,1)
    % Metallization
        mean_platinum_snr(iWindow) = mean(platinum_snr_distribution{iWindow});
        std_err_platinum_snr(iWindow) = std(platinum_snr_distribution{iWindow}) / sqrt(numel(platinum_snr_distribution{iWindow}));
        mean_irid_snr(iWindow) = mean(irid_snr_distribution{iWindow});
        std_err_irid_snr(iWindow) = std(irid_snr_distribution{iWindow}) / sqrt(numel(irid_snr_distribution{iWindow}));       

        mean_platinum_percent(iWindow) = mean(platinum_percent_distribution{iWindow});
        std_err_platinum_percent(iWindow) = std(platinum_percent_distribution{iWindow}) / sqrt(numel(platinum_percent_distribution{iWindow}));
        mean_irid_percent(iWindow) = mean(irid_percent_distribution{iWindow});
        std_err_irid_percent(iWindow) = std(irid_percent_distribution{iWindow}) / sqrt(numel(irid_percent_distribution{iWindow}));       

        
        metal_test_snr(iWindow) = ttest2(platinum_snr_distribution{iWindow},irid_snr_distribution{iWindow});
        metal_test_percent(iWindow) = ttest2(platinum_percent_distribution{iWindow},irid_percent_distribution{iWindow});
    % Electrode Length
        mean_short_snr(iWindow) = mean(reshape(short_snr_distribution{iWindow},1,[]));
        std_err_short_snr(iWindow) = std(reshape(short_snr_distribution{iWindow},1,[])) / sqrt(numel(reshape(short_snr_distribution{iWindow},1,[])));
        mean_long_snr(iWindow) = mean(reshape(long_snr_distribution{iWindow},1,[]));
        std_err_long_snr(iWindow) = std(reshape(long_snr_distribution{iWindow},1,[])) / sqrt(numel(reshape(long_snr_distribution{iWindow},1,[])));

        mean_short_percent(iWindow) = mean(reshape(short_percent_distribution{iWindow},1,[]));
        std_err_short_percent(iWindow) = std(reshape(short_percent_distribution{iWindow},1,[])) / sqrt(numel(reshape(short_percent_distribution{iWindow},1,[])));
        mean_long_percent(iWindow) = mean(reshape(long_percent_distribution{iWindow},1,[]));
        std_err_long_percent(iWindow) = std(reshape(long_percent_distribution{iWindow},1,[])) / sqrt(numel(reshape(long_percent_distribution{iWindow},1,[])));

        length_test_snr(iWindow) = ttest2(reshape(short_snr_distribution{iWindow},1,[]),reshape(long_snr_distribution{iWindow},1,[]));
        length_test_percent(iWindow) = ttest2(reshape(short_percent_distribution{iWindow},1,[]),reshape(long_percent_distribution{iWindow},1,[]));
end

%% Plotting
figure('visible','on','color','w','pos',[100 100 500 700]); hold on

colors = winter(2);
% subplot one: Metal Channel Percent
subplot(2,2,1); hold on;
% plot std err patches
patch([date_range_for_plotting' fliplr(date_range_for_plotting')],[(mean_platinum_percent+std_err_platinum_percent)...
    fliplr((mean_platinum_percent-std_err_platinum_percent))],colors(1,:),'edgecolor','none')
alpha(.4)

patch([date_range_for_plotting' fliplr(date_range_for_plotting')],[(mean_irid_percent+std_err_irid_percent)...
    fliplr((mean_irid_percent-std_err_irid_percent))],colors(2,:),'edgecolor','none')
alpha(.4)
% plot mean lines w/ dots
plot(date_range_for_plotting, mean_platinum_percent,'o-','Color',colors(1,:));
plot(date_range_for_plotting, mean_irid_percent,    'o-','Color',colors(2,:));
% plot significance stars
plot(date_range_for_plotting(find(metal_test_percent)), metal_test_percent(find(metal_test_percent))*.75,'*k')

legend({'Platinum','Iridium Oxide'},'Location','SouthEast')
xlabel('Months Post Implantation')
xticks([0 6 12 18 24])
ylabel('Percent Good Channels');
ylim([0 1]);

yticks(0:.25:1)
yticklabels({'0%' '25%' '50%' '75%' '100%'})
title('A','units','normalized', 'Position', [-0.1,1.05,1]);

% subplot two: Metal SNR
subplot(2,2,2); hold on;
% plot std err patches
patch([date_range_for_plotting' fliplr(date_range_for_plotting')],[(mean_platinum_snr+std_err_platinum_snr)...
    fliplr((mean_platinum_snr-std_err_platinum_snr))],colors(1,:),'edgecolor','none')
alpha(.4)

patch([date_range_for_plotting' fliplr(date_range_for_plotting')],[(mean_irid_snr+std_err_irid_snr)...
    fliplr((mean_irid_snr-std_err_irid_snr))],colors(2,:),'edgecolor','none')
alpha(.4)
% plot mean lines w/ dots
plot(date_range_for_plotting, mean_platinum_snr,'o-','Color',colors(1,:));
plot(date_range_for_plotting, mean_irid_snr,    'o-','Color',colors(2,:));
% plot significance stars
plot(date_range_for_plotting(find(metal_test_snr)), metal_test_snr(find(metal_test_snr))*3.2,'*k')

legend({'Platinum','Iridium Oxide'},'Location','SouthEast')
xlabel('Months Post Implantation')
xticks([0 6 12 18 24])
ylim([0 3.25])
ylabel('Signal to Noise Ratio (SNR)');
title('B','units','normalized', 'Position', [-0.1,1.05,1]);


% subplot three: Length Channel Percent

colors = hsv(2);

subplot(2,2,3); hold on;

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
xticks([0 6 12 18 24])
ylabel('Percent Good Channels');
ylim([0 1]);
yticks(0:.25:1)
yticklabels({'0%' '25%' '50%' '75%' '100%'})
title('C','units','normalized', 'Position', [-0.1,1.05,1]);

% subplot four: Length SNR
subplot(2,2,4); hold on;

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
xticks([0 6 12 18 24])
ylabel('Signal to Noise Ratio (SNR)');
ylim([0 3.25])
title('D','units','normalized', 'Position', [-0.1,1.05,1]);

%% Saving
if startsWith(matlab.desktop.editor.getActiveFilename,'C:\Users\calebsponheim\Documents\')
    saveas(gcf,'C:\Users\calebsponheim\Documents\git\array_stability\figures\paper_figures\figure_seven.png');
else
    saveas(gcf,'figure_seven.png');
end

% close(gcf);

end % End of Function