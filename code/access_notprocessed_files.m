
%make a pic from a list of files (I used this to rerun some Athena files
%that had channels from more than one arrays).

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

sheet2read = 'not processed';

if strcmp(sheet2read,'Boo-split')
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
        name = {};
        split = [];
        num_channels = [];
        
        iRow = iFile+1;
        
        params.iDate = raw{iRow,1};
        params.iFolder = raw{iRow,2};
        params.iName = raw{iRow,3};
        
        if strcmp(params.iName,'c100111_PMv_MIa_SRThold001.nev')
        else
            if ismac
                params.iFolder = strrep(params.iFolder,'\','/');
                params.iFolder = strrep(params.iFolder,'//prfs.cri.uchicago.edu','/Volumes');
            end
            [hadMoreThan128Channels, isDualRecording, allsnr, nChannelsWithSpikes, nevDate] = ...
                nev2plotForAll(params,plotDir1);
            
            
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
                % Boo
            elseif contains(lower(params.iName),lower('_M1c_PMdabc')) || contains(lower(params.iName),lower('_M1a_PMdabc'))
                name = {'M1','PMd'} ; split = 1; num_channels = [32,96];
                % Coco
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
                % Roxie (NOT DOING HER RIGHT NOW BECAUSE SHE HAS THREE-PART FILES
            end
            
            if ~isempty(split) && ~isempty(allsnr)
                fprintf('%s, %s, %s, %i, %f, %f , %i\n',...
                    sheet2read, params.iName,name{1},...
                    sum(allsnr(1:(split*32))>params.SNRthreshold),nanmean(allsnr(1:(split*32))),...
                    nanmean(allsnr(allsnr(1:(split*32))>params.SNRthreshold)),num_channels(1))
                fprintf('%s, %s, %s, %i, %f, %f, %i \n',...
                    sheet2read, params.iName, name{2},...
                    sum(allsnr(((split*32)+1):(4*32))>params.SNRthreshold),nanmean(allsnr(((split*32)+1):(4*32))),...
                    nanmean(allsnr(allsnr(((split*32)+1):(4*32))>params.SNRthreshold)),num_channels(2))
            else
                fprintf('%s, %s, %i, %f, %f\n',...
                    sheet2read, params.iName,...
                    sum(allsnr>params.SNRthreshold),nanmean(allsnr),...
                    nanmean(allsnr(allsnr>params.SNRthreshold)))
            end
            clear name split num_channels
        end
    end % for iFile
end
diary off

