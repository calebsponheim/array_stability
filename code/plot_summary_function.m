function [] = plot_summary_function(params)

%% read xls and cure data
%read data from xls
xls2read = params.xls2read; 
sheet2read =  params.sheet2read; % params.monkeyIN; 

[~,~,raw] = xlsread(xls2read,sheet2read);

dates = raw(2:end,4);    
nChannelsWithSpikes = [raw{2:end,6}];

%get rid of nans
remove = isnan(nChannelsWithSpikes);
remove(1) = 0;
dates(remove) = []; nChannelsWithSpikes(remove) = [];
%but first date is implantation date, so don't plot the zero
nChannelsWithSpikes(1) = nan;

%change dates back to string
for iCell = 1:numel(dates)
     dates{iCell} = dateNumeric2String(dates{iCell});
end

%get number of days after day one
days = dates2days(dates);
days = days - days(1);

%sort in case the list is not sorted
[~,ii] = sort(days);
days = days(ii);
nChannelsWithSpikes = nChannelsWithSpikes(ii);
dates = dates(ii);

%check if there are duplicate dates
% ddays = diff(days);
% if sum(ddays==0)
%     disp('found duplicate dates, will remove');
%     remove = ddays==0;
%     days(remove) = []; nChannelsWithSpikes(remove) = [];
%     dates(remove) = [];
% end

%create labels that state #days and date 
xlabels = cell(1,numel(days));
for i = 1:numel(days)
xlabels{i} = [num2str(days(i)) ' (' dates{i} ')'];
end

%% plot
figure('color','w'); hold on

% yieldPRC = round(100*nChannelsWithSpikes/96);
% plot(days,yieldPRC,'-o','linewidth',3);
% ylim([0 100]); ylabel('percent of channels with spikes');

plot(days,nChannelsWithSpikes,'o','linewidth',2);
ylabel('number of units');
ylim([0 100]);

ax = gca; ax.FontSize = 14; ax.LineWidth = 1.5;  ax.XColor = 'k'; ax.YColor = 'k';  
% ax.XTick = days; ax.XTickLabel = xlabels; ax.XTickLabelRotation = 90;
grid on
xlabel('days post implantation');
title([replace(sheet2read,'_',' ') ' Array yield across time (SNR>1.5)'],'FontSize',18);

tightfig; set(gcf,'position',[161,223,1369,538]);
% saveas(gcf,[params.dataDirServer 'Leda Pentousi\plots\summary plots\' params.monkeyIN ' ' params.arrayIN ' signal quality.png']);
export_fig([params.dataDirServer 'Leda Pentousi\plots\summary plots\' params.monkeyIN ' ' params.arrayIN ' signal quality_units_0-100.png']);
close(gcf);
end
