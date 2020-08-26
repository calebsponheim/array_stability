% Goals of Script:
%
% With a list of  filepaths and the filenames, correctly process and save the results for new .nev entries.
%
% Should I write them out to a csv, or to a mat file? I mean, I definitely shouldn't use diary().
%
% Include NPMK in the mix.
%
% How do I deal with the regex challenges of splitting the files?
% I mean, for each file, there are going to be multiple arrays inside each
% file; did they vary much?

%% User-defined Variables

subjects = ["P1", "P1", "P2", "P2"];
pedestals = ["A", "P", "A", "P"];

for iArray = 1:length(subject)
    
    
    subject = subjects(iArray); %'P1'; % replace with your subject name (ex: 'P1')
    pedestal = pedestals(iArray); %'A'; % A (anterior) or P (posterior)
    filenames = sprintf('input_list_%s_%s.csv', subject, pedestal);
    
    minimum_spike_trough = -68;
    maximum_spike_trough = -1200;
    SNR_threshold = 1.5;
    
    %% add relevant code to path
    
    addpath(genpath('.\third_party_tools'))
    
    %% Process each file
    
    % read in the csv
    [raw] = readmatrix(filenames,'FileType','text','OutputType','string','delimiter',',');
    
    nFiles = size(raw,1);
    
    % Set Up Output Table
    signal_quality = cell(nFiles,6);
    signal_quality = cell2table(signal_quality,'VariableNames',...
        {'FilePath' 'FileName' 'NEVdate' 'NumGoodChannels' 'SNRallchannels' 'SNRgoodchannels'});
    
    for iFile = 1:nFiles % not sure parfor saves any time since disk IO is likely the bottleneck.
        
        iFolder = {char(raw(iFile,1))}; % get folder name
        iName = {char(raw(iFile,2))}; % get filename
        
        nev2read = [char(raw(iFile,1)) char(raw(iFile,2))]; % establish exact file to read
        
        
        nChannelsWithSpikes = 0;
        
        try
            data = openNEV(nev2read,'read','nosave','nomat'); % Use NPMK to load .nev data struct
        catch 
            disp('error reading NEV, trying again')
            try
                data = openNEV(nev2read,'read','nosave','nomat');
            catch
                 disp([nev2read ' could not be read.'])
                 signal_quality{iFile,:} = [{iFolder},{iName},NaN,0,NaN,NaN];
                 continue
            end
            
        end
            
            electrode = double(data.Data.Spikes.Electrode);
            waveforms = double(data.Data.Spikes.Waveform);
            spikesT = double(data.Data.Spikes.TimeStamp)./30;
            
            % this will fail if the file doesn't have any spikes (which sometimes happens)
            if ~isempty(electrode) || ~isempty(waveforms)
                
                % find spikes that are in more than one channels simultaneously
                [~,idxu,idxc] = unique(spikesT);
                % count unique values
                [count, ~, idxcount] = histcounts(idxc,numel(idxu));
                % keep spikes that don't occur at many channels at the same time
                idxkeep = count(idxcount)==1;
                
                electrode = electrode(idxkeep);
                waveforms = waveforms(:,idxkeep);
                
                % Date Parsing:
                
                nevdate = data.MetaTags.DateTime;
                if strcmp(nevdate(2),'/')
                    month = ['0' nevdate(1)];
                    if strcmp(nevdate(4),'/'), day = ['0' nevdate(3)]; year = nevdate(7:8);
                    else, day = nevdate(3:4); year = nevdate(8:9);
                    end
                elseif strcmp(nevdate(3),'/')
                    month = nevdate(1:2);
                    if strcmp(nevdate(5),'/'), day = ['0' nevdate(4)]; year = nevdate(8:9);
                    else, day = nevdate(4:5); year = nevdate(9:10);
                    end
                else
                    %month = nevdate(4:6); month = month2num(month);
                    %day = nevdate(1:2); year = nevdate(10:11);
                    [year, month, day] = ymd(datetime(nevdate)); % I was missing month2num function but this works for me
                    year = num2str(year); month = num2str(month); day = num2str(day);
                end
                nevdateNum = str2double([year month day]);

                
                
                %% find which electrodes had threshold crossings
                elec_with_spikes = unique(electrode);
                elec_with_spikes_for_export = elec_with_spikes;
                nChannels = max(elec_with_spikes);
                allsnr = nan(256,1);
                nSamples = size(waveforms,1);
                for iChannel = 1:nChannels
                    chSpikes = find(electrode==iChannel);
                    if ~isempty(chSpikes)
                        wfs = waveforms(:,chSpikes);
                        
                        %get rid of too small or too big wfs
                        troughV = min(wfs);
                        firstPartMin = min(wfs(1:5,:));
                        firstPartMax = max(wfs(1:5,:));
                        lastPartMin = min(wfs(40:end,:));
                        lastPartMax = max(wfs(40:end,:));
                        %
                        keepWFs = troughV<minimum_spike_trough & troughV>maximum_spike_trough & ...
                            firstPartMin>-180 & firstPartMax<180 & ... %there shouldnt be fluctuations at this part
                            lastPartMin>-180 & lastPartMax<180; %there shouldnt be fluctuations at this part
                        
                        if sum(keepWFs)>20 % at least 20 spikes
                            wfs = wfs(:,keepWFs);
                            
                            %get SNR
                            meanWF = mean(wfs,2);
                            sig = max(meanWF(10:40)) - min(meanWF(10:40));
                            rms = mean(std(wfs,[],2));
                            snr = sig / (2*rms);
                            allsnr(iChannel) = snr;
                            if snr>SNR_threshold
                                nChannelsWithSpikes = nChannelsWithSpikes+1;
                            end
                            
                        end
                    end
                end % iChannel
                
                %% Write to output cell array
                
                if strcmp(subject,'P1')
                    % (P1) had two standard 96-channel arrays.
                    % So each array used banks A-C and not bank D.
                    % The .NEV files are separate for each array (one array per NSP and instance of Central).
                    
                    disp([nev2read ' worked! writing to table.'])
                    %signal_quality(iFile,:) = ...
                    %    [{iFolder} {iName} nevdateNum sum(allsnr(1:96)>SNR_threshold) ...
                    %    nanmean(allsnr(1:96)) nanmean(allsnr(allsnr(1:96)>SNR_threshold))];
                    % was getting an error above
                    signal_quality{iFile,:} = ...
                        [iFolder iName nevdateNum sum(allsnr(1:96)>SNR_threshold) ...
                        nanmean(allsnr(1:96)) nanmean(allsnr(allsnr(1:96)>SNR_threshold))];
                    
                elseif strcmp(subject,'P2')
                    
                    % (P2)’s arrays contain 1 motor array and 1 sensory array on each pedestal.
                    % The sensory arrays are bank C (32-wired channels),
                    % and the motor arrays are on banks A, B, and D (88-wired channels).
                    % Not all 128 channels are used, 8 channels in bank D are unused (these are the last 8 even channels, 114:2:128).
                    % Like P1, each .NEV file is associated with one pedestal.
                    % So 1 motor array and 1 sensory array per .NEV file.
                    
                    P2_range = [1:64 97:112 113:2:127];
                    denominator = numel(P2_range);
                    
                    disp([nev2read ' worked! writing to table.'])
                    signal_quality{iFile,:} = ...
                        [{iFolder} {iName} nevdateNum ...
                        sum(allsnr(P2_range)>SNR_threshold) ...
                        (nansum(allsnr(P2_range))/denominator) ...
                        (nansum(allsnr(allsnr(P2_range)>SNR_threshold))/denominator)];
                    
                else
                    disp([nev2read ' worked! writing to table.'])
                    signal_quality{iFile,:} = ...
                        [{iFolder} {iName} nevdateNum sum(allsnr>SNR_threshold) ...
                        nanmean(allsnr) nanmean(allsnr(allsnr>SNR_threshold))];
                end
            else
                disp([nev2read ' is empty'])
                signal_quality{iFile,:} = [{iFolder},{iName},NaN,0,NaN,NaN];
                
            end
        %catch
        %    disp([nev2read ' could not be read.'])
        %    signal_quality{iFile,:} = [{iFolder},{iName},NaN,0,NaN,NaN];
        %end
    end %iFile
    
    %% Write Table out to csv
    outfile = sprintf("%s_%s_processed.csv", subject, pedestal);
    writetable(signal_quality,outfile)
end
