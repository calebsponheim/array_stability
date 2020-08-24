% generate input_csv
subject = ["P1", "P1", "P2", "P2"];
pedestal = ["A", "P", "A", "P"];
base_path = ["R:\data_raw\human\rp3_bmi\BMI01\BlackrockData\PedA", ...
            "R:\data_raw\human\rp3_bmi\BMI01\BlackrockData\PedP", ...
            "R:\data_raw\human\crs_array\CRS02b\BlackrockData\BaselineA", ...
            "R:\data_raw\human\crs_array\CRS02b\BlackrockData\BaselineP"];
        
exclude_strings = [".OLD" "ZTEST" "ZCABLES" "20120120"]; % strings found in folder names to exclude % first date is preimplant
for iArray = 1:length(subject)
    outfile = sprintf("input_list_%s_%s.csv", subject(iArray), pedestal(iArray));
    fid = fopen(outfile,'w+');
    
    
    D = dir(base_path(iArray) + '\*\*.NEV');
    for iFile = 1:length(D)
        folder = D(iFile).folder;
        nev = D(iFile).name;
        
        if contains(upper(folder), exclude_strings)
            continue
        end
        
        fprintf(fid,'%s\\,%s\n',folder,nev);
    end
    
    fclose(fid);
end
