clc;clear all;close all;

eeg_clearned_path = 'G:\GU第三次\02-data_analysis\emoi&scl\'; % path of EEG data
eeg_cleaned_file = dir([eeg_clearned_path '*_EEG_cleaned.mat']);
%将所有文件的name都变成小写
for i = 1:length(eeg_cleaned_file)
    eeg_cleaned_file(i,1).name=lower(eeg_cleaned_file(i,1).name);   
end
[~,index] = sortrows({eeg_cleaned_file.name}.'); eeg_cleaned_file = eeg_cleaned_file(index); clear index;

for k = 1:length(eeg_cleaned_file)
    tmpfile = eeg_cleaned_file(k).name;
    tmppath = [eeg_clearned_path tmpfile];

    try
        load(tmppath);
    catch
        error('\n!!Error @ %s: Failed to load cleaned EEG data\n', datestr(now));
    end
%% CacEmoi_base 
    [FA_base] = DAPfunc_EEG_calcEmoi (movieEEG, conf);
%% Transposition for Visualization
    FA_base_average = mean(FA_base);
        xlswrite('emoi_base_average.xlsx', FA_base_average, 'emoi_base_average',strcat('B',num2str(k+1)));
        emoi=char('emoi');
        xlswrite('emoi_base_average.xlsx', {emoi}, 'emoi_base_average','B1');
        xlswrite('emoi_base_average.xlsx', {strrep(eeg_cleaned_file(k,1).name,'_eeg_cleaned.mat','')}, 'emoi_base_average',strcat('A',num2str(k+1)));
        subject=char('subject_name');
        xlswrite('emoi_base_average.xlsx', {subject}, 'emoi_base_average','A1');
end
