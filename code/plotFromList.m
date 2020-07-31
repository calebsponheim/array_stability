
%make a pic from a list of files in an excel file.

% This script was originally written by Vassilis Papadourakis before he
% left and joined the Bezos Boys. The original intention of the script was
% to plot individual recordings and their SNR, and also read/write data
% from a massive excel spreadsheet. 

% THIS version of that script no longer plots anything. Instead, its sole
% purpose is to read in .nev blackrock files, measure the peak-to-trough
% amplitude of its spikes per channel, and report the SNR of those channels
% back. Right now I have them being written using diary() to a log file.
% It's not elegant.


% THIS SCRIPT IS CURRENTLY SET UP TO PROCESS SPLIT ARRAY FILES, NOTHING
% ELSE. you'll need to change the code (and presumably, this comment), if
% you want to process other tabs of the excel file.

%addpath(genpath(pwd));
clear; close all

params.minSpikeTrough = -68;
params.maxSpikeTrough = -1200;
params.ylims = [-275 275];
params.SNRthreshold = 1.5;

if ismac
    params.dataDirServer = '/Volumes/nicho-lab/';
    allxls = '/Volumes/nicho-lab/Leda Pentousi/all_files2_CS.xlsx';
    allDataMat = '/Volumes/nicho-lab/Leda Pentousi/allData.mat';
    plotDir1 ='/Volumes/nicho-lab/Leda Pentousi/plots/';
else
    params.dataDirServer = '\\prfs.cri.uchicago.edu\nicho-lab\';
    allxls = '\\prfs.cri.uchicago.edu\nicho-lab\Leda Pentousi\all_files2_CS.xlsx';
    allDataMat = '\\prfs.cri.uchicago.edu\nicho-lab\Leda Pentousi\allData.mat';
    plotDir1 ='\\prfs.cri.uchicago.edu\nicho-lab\Leda Pentousi\plots\';
end

% this is is a third-party tool that reads the excel file sheet names:
sheets_to_read = xl_xlsfinfo(allxls);
%


for iSheet = 1:length(sheets_to_read)
    if contains(sheets_to_read(iSheet),'split') % this is what makes it split only.
        
        sheet2read = sheets_to_read{iSheet};
        
        % skips already-processed split sheets
        if strcmp(sheet2read,'Boo-split')
        elseif strcmp(sheet2read,'Coco-split')
        elseif strcmp(sheet2read,'Lester-split')
        elseif strcmp(sheet2read,'Nikki-split')
        elseif strcmp(sheet2read,'Raju-split')
        elseif strcmp(sheet2read,'Rockstar-split')
        elseif strcmp(sheet2read,'Roxie-split')
        elseif strcmp(sheet2read,'Velma-split')
        elseif strcmp(sheet2read,'Velmasplitprocessed')
        %
        
        else
            params.keep96chans = false;
            params.rerun = true;
            
            % params.keep96chans = true;
            % sheet2read = 'Athena 2'; %'Mack 2';
            % plotDir1 ='\\prfs.cri.uchicago.edu\nicho-lab\Leda Pentousi\plots\Athena 2\M1\';
            
            
            [~,~,raw] = xlsread(allxls,sheet2read);
            
            nFiles = size(raw,1)-1;
            
            %nChannelsWithSpikes = nan(1,nFiles);
            %dates = cell(1,nFiles);
            
            runTheseFiles = 1:nFiles;
            diary([sheet2read '.csv'])
            
            for iFile = runTheseFiles
                iRow = iFile+1;
                
                params.iDate = raw{iRow,1};
                params.iFolder = raw{iRow,2};
                params.iName = raw{iRow,3};
                
                if strcmp(params.iName,'c100111_PMv_MIa_SRThold001.nev')
                elseif ~isnan(params.iFolder)
                    if ismac
                        params.iFolder = strrep(params.iFolder,'\','/');
                        params.iFolder = strrep(params.iFolder,'//prfs.cri.uchicago.edu','/Volumes');
                    end
                    [hadMoreThan128Channels, isDualRecording, allsnr, nChannelsWithSpikes, nevDate] = ...
                        nev2plotForAll(params,plotDir1);
                    
                    % REGEX MADNESS: this terrible set of if statements is
                    % to accomodate all of the different types of ways that
                    % people name files!!! it's terrible. god, it's
                    % terrible. Split .nev files have some portion
                    % dedicated to one array, while the rest is dedicated
                    % to a different array. the number of channels and the
                    % location of the split, and the identity of the two
                    % arrays (it's always two, unless it's not) depends on
                    % the file and subject.
                    
                    % Velma + Others
                    if contains(lower(params.iName),lower('_PMdaC_M1Ab'))
                        name = {'PMd','M1'} ; split = 2; num_channels = [64,64];
                    elseif contains(lower(params.iName),lower('_PMvaC_M1Ab')) || contains(lower(params.iName),lower('PMvAc_M1Ac'))
                        name = {'PMv','M1'} ; split = 2; num_channels = [64,64];
                    elseif contains(lower(params.iName),lower('_M1Ab_PMvaC')) || contains(lower(params.iName),lower('_M1_Ab_PMvaC')) || contains(lower(params.iName),lower('_MIab_PMvab_'))
                        name = {'M1','PMv'} ; split = 2; num_channels = [64,64];
                    elseif contains(lower(params.iName),lower('_PMdabC_PMvC')) || contains(lower(params.iName),lower('PMdall_PMv'))
                        name = {'PMd','PMv'} ; split = 3; num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('M1Abc_PMv')) || contains(lower(params.iName),lower('M1All_PMv')) || contains(lower(params.iName),lower('M1AbcPMv'))
                        name = {'M1','PMv'} ; split = 3; num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('PMvAc_PMdAc'))
                        name = {'PMv','PMd'} ; split = 2; num_channels = [64,64];
                    elseif contains(lower(params.iName),lower('PMdall_M1')) || contains(lower(params.iName),lower('PMdabc_M1')) || contains(lower(params.iName),lower('PMdallMI'))
                        name = {'PMd','M1'} ; split = 3;  num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('PMvall_M1'))
                        name = {'PMv','M1'} ; split = 3;  num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('M1all_PMd')) || contains(lower(params.iName),lower('M1allPMd')) || contains(lower(params.iName),lower('MIallPMd')) || contains(lower(params.iName),lower('M1abc_PMd')) || contains(lower(params.iName),lower('M1_PMd'))
                        name = {'M1','PMd'} ; split = 3;  num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('PMvabc_PMd')) ||  contains(lower(params.iName),lower('PMvall_PMd'))
                        name = {'PMv','PMd'} ; split = 3; num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('PMdc_PMvall'))
                        name = {'PMd','PMv'} ; split = 1; num_channels = [32,96];
                        % Boo-specific regex
                    elseif contains(lower(params.iName),lower('_M1c_PMdabc')) || contains(lower(params.iName),lower('_M1a_PMdabc'))
                        name = {'M1','PMd'} ; split = 1; num_channels = [32,96];
                        % Coco-specific regex
                    elseif contains(lower(params.iName),lower('_MIab_PMvab_'))
                        name = {'M1','PMv'} ; split = 2; num_channels = [64,64];
                    elseif contains(lower(params.iName),lower('_PMd_M1a_')) || contains(lower(params.iName),lower('_PMd_MIa_'))
                        name = {'PMd','M1'} ; split = 3; num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('_PMv_M1a_')) || contains(lower(params.iName),lower('_PMv_MIa_'))
                        name = {'PMv','M1'} ; split = 3; num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('_PMdab_MIab_'))
                        name = {'PMd','M1'} ; split = 2; num_channels = [64,64];
                    elseif contains(lower(params.iName),lower('_PMdABC_PMvA_'))
                        name = {'PMd','PMv'} ; split = 3; num_channels = [96,32];
                        % Lester
                    elseif contains(lower(params.iName),lower('M1PMdB'))
                        name = {'M1','PMd'} ; split = 3; num_channels = [96,32];
                    elseif contains(lower(params.iName),lower('M1PMdB')) || contains(lower(params.iName),lower('M1andPMdA'))
                        name = {'M1','PMd'} ; split = 3; num_channels = [96,32];
                        % Nikki (taken care of in first block)
                        % Raju
                    elseif contains(lower(params.iName),lower('PMdab_M1')) || contains(lower(params.iName),lower('PMdbc_M1'))  || contains(lower(params.iName),lower('PMdac_M1'))
                        name = {'PMd','M1d'} ; split = 2; num_channels = [64,64];
                    elseif contains(lower(params.iName),lower('PMdc_M1all')) || contains(lower(params.iName),lower('PMdb_M1all')) || contains(lower(params.iName),lower('PMdc_M1abc'))
                        name = {'PMd','M1'} ; split = 1; num_channels = [32,96];
                        % Rockstar
                    elseif contains(lower(params.iName),lower('M1bc_PMdab')) || contains(lower(params.iName),lower('M1ab_PMdbc'))
                        name = {'PMd','M1d'} ; split = 2; num_channels = [64,64];
                        % Roxie (NOT DOING HER RIGHT NOW BECAUSE SHE HAS THREE-PART FILES)
                    end
                    
                    
                    fprintf('%s, %s, %s, %i, %f, %f , %i\n',...
                        sheet2read, params.iName,name{1},...
                        sum(allsnr(1:(split*32))>params.SNRthreshold),nanmean(allsnr(1:(split*32))),...
                        nanmean(allsnr(allsnr(1:(split*32))>params.SNRthreshold)),num_channels(1))
                    fprintf('%s, %s, %s, %i, %f, %f, %i \n',...
                        sheet2read, params.iName, name{2},...
                        sum(allsnr(((split*32)+1):(4*32))>params.SNRthreshold),nanmean(allsnr(((split*32)+1):(4*32))),...
                        nanmean(allsnr(allsnr(((split*32)+1):(4*32))>params.SNRthreshold)),num_channels(2))
                end
            end % for iFile
        end
    end % if iSheet
    diary off % very important to turn off diary, since it will continue to log everything if you don't turn it off. 
end % for iSheet

