clc;clear all;
% read log files
log_path = 'D:\06-Project\04-安杰\06-sandigma_second\05-log\原始\'; % path of log files
log_file = dir([log_path '*-log.txt']);
% read mark files
mark_path = 'D:\06-Project\04-安杰\06-sandigma_second\05-log\原始\'; % path of mark files
mark_file = dir([mark_path '*-mark.txt']);
% 将所有log文件的name都变成小写
for i = 1:length(log_file)
    log_file(i,1).name=lower(log_file(i,1).name);
end
[~,index] = sortrows({log_file.name}.'); log_file = log_file(index); clear index;
% 将所mark有文件的name都变成小写
for j = 1:length(mark_file)
    mark_file(j,1).name=lower(mark_file(j,1).name);
end
[~,index] = sortrows({mark_file.name}.'); mark_file = mark_file(index); clear index;
%% data processing
if length(log_file)==length(mark_file)
    for k =1:length(log_file)
        
        % read mark_file
        [Trial_mark,Subject_mark,Color_mark,Name_mark,Stimulus_mark,StartTimems,EndTimems,TriggerLineStartms,TriggerLineDurationms,TriggerLineEndms,Number,PortStatus]=importfile_mark_txt([mark_path,mark_file(k).name]);
        % read log_file
        [Trial,Subject,Stimulus,TimeTrialms,TimeRunms,Type,Event,Content,Content2]=importfile_log_txt([log_path,log_file(k).name]);
        
        % Check baseline time and Calc newlogtime
        if TriggerLineStartms(1,1)<60000
            error('\n!!Error : the length of baseline time<60s,please check %s file.',mark_file(k).name);
        else
            TimeTrialms=TimeTrialms-TriggerLineStartms(1,1);
            TimeRunms=TimeRunms-TriggerLineStartms(1,1);
            
            %Transposition for Visualization
            NewLogDataNames={'Trial','Subject','Stimulus','TimeTrialms','TimeRunms','Type','Event','Content'};
            newlogdata=table(Trial,Subject,Stimulus,TimeTrialms,TimeRunms,Type,Event,Content,'VariableNames',NewLogDataNames);
            writetable(newlogdata, strrep(log_file(k,1).name,'.txt','_new.csv'))
        end
    end
else
    error('\n!!Error : the length of log_Files and mark_Files is not equal,please check\n');
end
