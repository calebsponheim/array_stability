%% Script Intention: Turn Array Stability Excel File into Matlab Matfile struct.
dataDirServer = '\\prfs.cri.uchicago.edu\nicho-lab\';
xls2read = [dataDirServer 'Leda Pentousi\all_files2_CS.xlsx'];
sheets_to_read = xl_xlsfinfo(xls2read);

file_count = 0;
array_data = [];
for iSheet = 1:length(sheets_to_read)
    if contains(sheets_to_read(iSheet),'_')
        [~,~,uncropped_sheet_temp] = xlsread(xls2read,sheets_to_read{iSheet});
        sheet_implantation_date = dateNum2days(cell2mat(uncropped_sheet_temp(2,4)));
        cropped_sheet_temp = uncropped_sheet_temp(3:end,3:11);
        for iFile = 1:size(cropped_sheet_temp,1)
            if ~isnan(cell2mat(cropped_sheet_temp(iFile,1)))
                array_data(iFile+file_count).array_name = sheets_to_read{iSheet};
                array_data(iFile+file_count).implantation_date = sheet_implantation_date;
                array_data(iFile+file_count).filename = cropped_sheet_temp{iFile,1};
                array_data(iFile+file_count).absolute_days = dateNum2days(cropped_sheet_temp{iFile,2});
                array_data(iFile+file_count).relative_days = dateNum2days(cropped_sheet_temp{iFile,2}) - sheet_implantation_date;
                array_data(iFile+file_count).num_good_channels = cropped_sheet_temp{iFile,3};
                array_data(iFile+file_count).num_good_channels_corrected = cropped_sheet_temp{iFile,4};
                array_data(iFile+file_count).SNR_all_channels = cropped_sheet_temp{iFile,5};
                array_data(iFile+file_count).SNR_good_channels = cropped_sheet_temp{iFile,6};
                
                if cropped_sheet_temp{iFile,9} == 0
                    array_data(iFile+file_count).total_num_of_channels = 96;
                elseif cropped_sheet_temp{iFile,9} == 1
                    array_data(iFile+file_count).total_num_of_channels = 128;
                end
            end
        end
        file_count = size(array_data,2);
    else
    end
end

%% Save

save([dataDirServer '\Leda Pentousi\all_files_struct_CS'],'array_data')