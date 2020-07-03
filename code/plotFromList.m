
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

sheet2read = 'Roxie_PMd';
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

for iFile = runTheseFiles
    iRow = iFile+1;
    
    params.iDate = raw{iRow,1};
    params.iFolder = raw{iRow,2};
    params.iName = raw{iRow,3};
    if ismac
        params.iFolder = strrep(params.iFolder,'\','/');
        params.iFolder = strrep(params.iFolder,'//prfs.cri.uchicago.edu','/Volumes');
    end
    [hadMoreThan128Channels, isDualRecording, allsnr, nChannelsWithSpikes, nevDate] = ...
        nev2plotForAll(params,plotDir1);
    
    disp(['processed '  params.iFolder params.iName]); 
    
    %save output to allFiles.mat
    varName = params.iName(1:end-4);
    eval([varName '.fileDate = params.iDate;']);
    eval([varName '.folder = params.iFolder;']);
    eval([varName '.name = params.iName;']);
    eval([varName '.nChannelsWithSpikes = nChannelsWithSpikes;']);
    eval([varName '.allsnr = allsnr;']);
    eval([varName '.params = params;']);
    eval([varName '.hadMoreThan128Channels = hadMoreThan128Channels;']);
    eval([varName '.isDualRecording = isDualRecording;']);
    eval([varName '.nevDate = nevDate;']);
    eval([varName '.avgSNR = nanmean(allsnr);']);
    eval([varName '.avgSNR_goodChans = nanmean(allsnr(allsnr>params.SNRthreshold));']);
    
%     if exist(allDataMat,'file'), save(allDataMat,varName,'-append');
%     else, save(allDataMat,varName);
%     end
    
    %save output to end of processed xls sheet
    xlsoutput = cell(1,8);
    xlsoutput{1} = params.iDate; xlsoutput{2} = params.iFolder;
    xlsoutput{3} = params.iName; xlsoutput{4} = nevDate;
    xlsoutput{5} = nChannelsWithSpikes;
    xlsoutput{7} = nanmean(allsnr); xlsoutput{8} = nanmean(allsnr(allsnr>params.SNRthreshold));
    xlsoutput{10} = hadMoreThan128Channels; xlsoutput{11} = isDualRecording;
    
    xlswrite(allxls,xlsoutput,sheet2read,['A' num2str(iRow)]);
    clear((varName))
end


