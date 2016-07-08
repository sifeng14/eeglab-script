clc;clear;

% ѡ����Ҫ�������ĵ缫 gamma('P4') high(CP4 P4)
Chan = {'P4'};
Freq_band = {'gamma'};
% Chan = {'P4' 'CP4'};
% Freq_band = {'high'};
% Freq_band = {'alpha' 'beta' 'theta' 'gamma' 'high' 'low'};

% ��ȡ��ǰ����·������_EEG_FA_final.mat��β���ļ���������MatFiles�ṹ����
All_final_path = 'G:\GU������\02-data_analysis\gamma&high alpha\';
MatFiles = dir([All_final_path,'*_EEG_FA_final_All.mat']);
%�������ļ���name�����Сд
for k = 1:length(MatFiles)
    MatFiles(k,1).name=lower(MatFiles(k,1).name);   
end
[~,index] = sortrows({MatFiles.name}.'); MatFiles = MatFiles(index); clear index;

for i = 1:length(MatFiles)
    % ��ȡ�ļ�����
    load([All_final_path,MatFiles(i).name]);
    
    % ���ҵ�ǰ�ļ�����Chan��Ӧ�ĵ缫��ţ�������ia������
    [c, ia, ib] = intersect(conf.eeg_all_in_one_chan, Chan);
    
    % ����ÿ����������Щ�缫��ƽ��ֵ
    average_gamma = mean(FA_final_gamma(ia,:),1);
    average_high = mean(FA_final_high(ia,:),1);
    
    average_gamma_base = mean(FA_final_gamma_base(ia,:),1);
    average_high_base = mean(FA_final_high_base(ia,:),1);
    
    %% high
    if ismember('high', Freq_band)
        FA_base = mean(average_high_base);
        xlswrite('high&gamma_base_average.xlsx', FA_base', 'high&gamma_base_average',strcat('B',num2str(i+1)));
        high=char('high');
        xlswrite('high&gamma_base_average.xlsx', {high}, 'high&gamma_base_average','B1');
    end
    %% gamma
    if ismember('gamma', Freq_band)
        FA_base = mean(average_gamma_base);
        xlswrite('high&gamma_base_average.xlsx', FA_base', 'high&gamma_base_average',strcat('C',num2str(i+1)));
        gamma=char('gamma');
        xlswrite('high&gamma_base_average.xlsx', {gamma}, 'high&gamma_base_average','C1');
        xlswrite('high&gamma_base_average.xlsx', {strrep(MatFiles(i).name,'_EEG_FA_final_All.mat','')}, 'high&gamma_base_average',strcat('A',num2str(i+1)));
        subject=char('subject_name');
        xlswrite('high&gamma_base_average.xlsx', {subject}, 'high&gamma_base_average','A1');
    end
end