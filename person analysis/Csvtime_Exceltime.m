%%batch process vmark to log

clc;clear;

log_path = 'D:\07-Script\person analysis\'; % path of EEG data
log_file = dir([log_path '*.csv']); % name of vhdr file
for k = 1:length(log_file)
    tmpfile = log_file(k).name;
    tmppath = [log_path tmpfile];
    
    % load csv file
    
    [RAW, delim] = importdata(tmppath);
    for m = 1:length(RAW)-1
        data(m,:) = strsplit(RAW{m+1}, delim);
    end
    
    %%   Eye Tracking for  tobii
    log_time=data(:,2);
    log_event=data(:,4);
    %%   Eye Tracking for  SMI
    %     log_time=RAW2(:,4);
    %     log_event=RAW2(:,8);
    
    %% processing
    
    log_position=[];
    for i=1:length(log_time)
        % ceil：朝正无穷方向取整  round：四舍五入到最近的整数
        log_position(i)=ceil(str2num(cell2mat(log_time(i)))/400)+1;
    end
    
    
    %% 结果可视化
    currDir=pwd;
    sheet=tmpfile;
    log_tmp_file=strrep(tmpfile,'.csv','-update.xlsx');
    t = fullfile (currDir,log_tmp_file);
    
    for j=1:length(log_time)
        xlswrite(t, log_time(j),sheet,['B',num2str(log_position(j))]);
        xlswrite(t, log_event(j),sheet,['A',num2str(log_position(j))]);
    end
    
    data_name=char('time');log_name=char('log');
    xlswrite(t,{data_name},sheet,'B1');
    xlswrite(t,{log_name},sheet,'A1');
end
clc;clear;