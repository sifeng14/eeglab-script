%% This script for personal analysis(merge emoi&scl and high&gamma data)
clc;clear;
File_path1 = 'D:\07-Script\DAP_3.0.2.1\'; 
File_path2 = 'D:\07-Script\All in One\'; 
emoiscl_Files = dir([File_path1,'*_for_visualization.xlsx']);
highgamma_Files= dir([File_path2,'*_gamma&high alpha.xlsx']);
if length(emoiscl_Files) == length(highgamma_Files)
    for i = 1:length(emoiscl_Files)
        if strrep(emoiscl_Files(i).name,'_for_visualization.xlsx','')==strrep(highgamma_Files(i).name,'_gamma&high alpha.xlsx','')
       %% read emoi&scl Files
        emoiscl_sheet=strrep(emoiscl_Files(i).name,'_for_visualization.xlsx','');
        emoiscl_xls=xlsread([File_path1,emoiscl_Files(i).name],emoiscl_sheet);
        
       %% read high&gamma Files
        highgamma_sheet='gamma&high alpha';
        highgamma_xls=xlsread([File_path2,highgamma_Files(i).name],highgamma_sheet);
        
        %% second to hour:min:second
        second_data= highgamma_xls(:,9);
        second_data_new=cell(length(second_data),1);
        for j=1:length(second_data)
            sec=mod(round(second_data(j)),60);
            min=mod(floor(round(second_data(j))/60),60);
            hour=floor(round(second_data(j))/3600);
            second_data_new(j)=cellstr([num2str(hour),':',num2str(min),':',num2str(sec)]);
        end
        
       %% write emoi&scl&high&gamma index to file
        File_name=strrep(emoiscl_Files(i).name,'_for_visualization.xlsx','_for_personal analysis.xlsx');
        sheet='personal analysis';
        xlswrite(File_name,emoiscl_xls(:,1),sheet,'A2');
        xlswrite(File_name,emoiscl_xls(:,4),sheet,'B2');
        xlswrite(File_name,highgamma_xls(:,1),sheet,'C2');
        xlswrite(File_name,highgamma_xls(:,4),sheet,'D2');
        xlswrite(File_name,highgamma_xls(:,7:9),sheet,'E2');
        xlswrite(File_name,second_data_new,sheet,'H2');
       
        
        emoi=char('emoi');scl=char('scl');high=char('high alpha');gamma=char('gamma');time=char('t');marktime=char('mark');TaddMark=char('t+mark');TaddMarkNew=char('h:m:s');
        xlswrite(File_name,{emoi},sheet,'A1');
        xlswrite(File_name,{scl},sheet,'B1');
        xlswrite(File_name,{high},sheet,'C1');
        xlswrite(File_name,{gamma},sheet,'D1');
        xlswrite(File_name,{time},sheet,'E1');
        xlswrite(File_name,{marktime},sheet,'F1');
        xlswrite(File_name,{TaddMark},sheet,'G1');
        xlswrite(File_name,{TaddMarkNew},sheet,'H1');
        
        else
            error('\n!!Error : the name of emoiscl_Files and highgamma_Files is not equal\n');
        end
    end
else
    error('\n!!Error : the length of emoiscl_Files and highgamma_Files is not equal\n');
end
clc;clear;
        