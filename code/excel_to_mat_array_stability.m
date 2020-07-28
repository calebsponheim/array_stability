%% Script Intention: Turn Array Stability Excel File into Matlab Matfile struct.
dataDirServer = '\\prfs.cri.uchicago.edu\nicho-lab\';
xls2read = [dataDirServer 'Leda Pentousi\all_files2_CS.xlsx'];
sheets_to_read = xl_xlsfinfo(xls2read);

file_count = 0;
array_data = [];
for iSheet = 1:length(sheets_to_read)
    if contains(sheets_to_read(iSheet),'_')
        uncropped_sheet_temp = ...
            table2cell(readtable(xls2read,'FileType','spreadsheet','Sheet',sheets_to_read{iSheet},'ReadVariableNames',false));
        sheet_implantation_date = dateNum2days(cell2mat(uncropped_sheet_temp(1,4)));
        cropped_sheet_temp = uncropped_sheet_temp(2:end,2:12);
        for iFile = 1:size(cropped_sheet_temp,1)
            if ~isnan(cell2mat(cropped_sheet_temp(iFile,1)))
                array_data(iFile+file_count).array_name = sheets_to_read{iSheet};
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
                
%                 nev2read = [array_data(iFile+file_count).folder array_data(iFile+file_count).filename];
%                 data = openNEV(nev2read,'noread','nosave','nomat');
%                 elec_with_spikes = numel(unique(double(data.Data.Spikes.Electrode)));
%                 
%                 array_data(iFile+file_count).total_num_of_channels = elec_with_spikes;
%                 fprintf('processed %s file number %i\n',sheets_to_read{iSheet},iFile)
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
        file_count = size(array_data,2);
    else
    end
    
    disp(['completed ' sheets_to_read{iSheet}])
end

%% Save

save([dataDirServer '\Leda Pentousi\array_data'],'array_data')
save('.\data\array_data','array_data')