%% Script Intention: Turn Array Stability Excel File into Matlab Matfile struct.

% This script reads the massive excel file where most of the hard data entry
% work was done, and converts it to a much nicer-to-handle matlab struct,
% from which all of our figures are generated. Takes a minute to run, so
% get a coffee or something while you do it.


%%
dataDirServer = '\\prfs.cri.uchicago.edu\nicho-lab\';
xls2read = [dataDirServer 'Leda Pentousi\all_files2_CS.xlsx'];
sheets_to_read = xl_xlsfinfo(xls2read);

file_count = 0;
array_data = [];

subject_array_info = readtable('.\data\subject_info_data.csv');

% only two nested for-loops! lol
for iSheet = 1:length(sheets_to_read)
    if contains(sheets_to_read(iSheet),'_') % this is a very brittle way to ignore the bad sheets in the excel workbook.
        uncropped_sheet_temp = ...
            table2cell(readtable(xls2read,'FileType','spreadsheet','Sheet',sheets_to_read{iSheet},'ReadVariableNames',false));
        sheet_implantation_date = dateNum2days(cell2mat(uncropped_sheet_temp(1,4)));
        cropped_sheet_temp = uncropped_sheet_temp(2:end,2:12);
        for iFile = 1:size(cropped_sheet_temp,1)
            if ~isnan(cell2mat(cropped_sheet_temp(iFile,1)))
                
                % === Duplicate File Detection ===========================
                if (iFile > 1) && ...
                        (array_data(iFile+file_count-1).absolute_days == dateNum2days(cropped_sheet_temp{iFile,3})) && ...
                        (array_data(iFile+file_count-1).num_good_channels == cropped_sheet_temp{iFile,4}) && ...
                        (array_data(iFile+file_count-1).SNR_all_channels == cropped_sheet_temp{iFile,6})
                    
                    % If this is true, then SKIP.
                    fprintf('%s is a duplicate! removing from final list. \n',cropped_sheet_temp{iFile,2});
                    
                    file_count = file_count - 1;
                % ========================================================
                else
                    
                    array_data(iFile+file_count).array_name = sheets_to_read{iSheet};
                    array_data(iFile+file_count).array_name_abbrev = subject_array_info.Abbrev(contains(subject_array_info.Array_Name,array_data(iFile+file_count).array_name));
                    array_data(iFile+file_count).implantation_date = sheet_implantation_date;
                    array_data(iFile+file_count).folder = cropped_sheet_temp{iFile,1};
                    array_data(iFile+file_count).filename = cropped_sheet_temp{iFile,2};
                    array_data(iFile+file_count).absolute_days = dateNum2days(cropped_sheet_temp{iFile,3});
                    array_data(iFile+file_count).relative_days = dateNum2days(cropped_sheet_temp{iFile,3}) ...
                        - sheet_implantation_date;
                    array_data(iFile+file_count).num_good_channels = cropped_sheet_temp{iFile,4};
                    array_data(iFile+file_count).num_good_channels_corrected = cropped_sheet_temp{iFile,5};
                    if ischar(cropped_sheet_temp{iFile,6})
                        array_data(iFile+file_count).SNR_all_channels = str2double(cropped_sheet_temp{iFile,6});
                    else
                        array_data(iFile+file_count).SNR_all_channels = cropped_sheet_temp{iFile,6};
                    end
                    if ischar(cropped_sheet_temp{iFile,7})
                        array_data(iFile+file_count).SNR_good_channels = str2double(cropped_sheet_temp{iFile,7});
                    else
                        array_data(iFile+file_count).SNR_good_channels = cropped_sheet_temp{iFile,7};
                    end
                    array_data(iFile+file_count).brain_area = cropped_sheet_temp{iFile,8};
                    array_data(iFile+file_count).electrode_length = subject_array_info.Electrode_Length(contains(subject_array_info.Array_Name,array_data(iFile+file_count).array_name));
                    array_data(iFile+file_count).metallization = subject_array_info.Metallization(contains(subject_array_info.Array_Name,array_data(iFile+file_count).array_name));
                    
                    
                    % THIS code (currently commented out) is meant to get
                    % the ACTUAL number of electrodes from each .nev file
                    % and put it into the mat struct, since we didn't have
                    % that information in the excel file. IT TAKES FOREVER
                    % because it requires you to load 4000+ .nev files.
                    % We've since figures out some workarounds, but it's
                    % here if you need it:
                    
%                     nev2read = [array_data(iFile+file_count).folder array_data(iFile+file_count).filename];
%                     data = openNEV(nev2read,'noread','nosave','nomat');
%                     elec_with_spikes = numel(unique(double(data.Data.Spikes.Electrode)));
%                     
%                     array_data(iFile+file_count).total_num_of_channels = elec_with_spikes;
%                     fprintf('processed %s file number %i\n',sheets_to_read{iSheet},iFile)
                    
                    
                    if ~isnan(cropped_sheet_temp{iFile,11})
                        array_data(iFile+file_count).total_num_of_channels = cropped_sheet_temp{iFile,11};
                    elseif cropped_sheet_temp{iFile,10} == 0
                        array_data(iFile+file_count).total_num_of_channels = 96;
                    elseif cropped_sheet_temp{iFile,10} == 1
                        array_data(iFile+file_count).total_num_of_channels = 128;
                    elseif isempty(cropped_sheet_temp{iFile,10})
                        array_data(iFile+file_count).total_num_of_channels = 96;
                    end
                end
            end
        end
        % Adding "number of recordings"  and "size" back into table
        
        subject_array_info.Number_of_Recordings(contains(subject_array_info.Array_Name,array_data(iFile+file_count).array_name))...
            = sum(contains({array_data.array_name},array_data(iFile+file_count).array_name));
        subject_array_info.Size(contains(subject_array_info.Array_Name,array_data(iFile+file_count).array_name)) ...
            = mode([array_data((contains({array_data.array_name},array_data(iFile+file_count).array_name))).total_num_of_channels]);

        %
        
        file_count = size(array_data,2);
        
    else
    end
    
    disp(['completed ' sheets_to_read{iSheet}])
end

%% Save

save([dataDirServer '\Leda Pentousi\array_data'],'array_data')
save('.\data\array_data','array_data')
writetable(subject_array_info,'.\data\subject_info_data.csv','Delimiter',',')