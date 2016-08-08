% This script for personal analysis(Pt+(0.2-Nt))
clc;clear;
File_path1 = 'D:\07-Script\person analysis\';
Index_Files= dir([File_path1,'*_personal analysis.xlsx']);

for i = 1:length(Index_Files)
    Index_xls=xlsread([File_path1,Index_Files(i).name],'personal analysis');
    %% for emoi calc pt and nt
    raw_emoi_data= Index_xls(:,1);
    positive_emoi_index=raw_emoi_data>0;
    positive_emoi=raw_emoi_data(positive_emoi_index);
    positive_emoi_mean=mean(positive_emoi);
    positive_emoi_sd=std(positive_emoi);
    positive_emoi_sd1=positive_emoi_mean+positive_emoi_sd;
    positive_emoi_sd2=positive_emoi_mean+positive_emoi_sd*2;
    positive_emoi_index2=((positive_emoi>positive_emoi_sd1)&(positive_emoi<positive_emoi_sd2));
    pt_emoi_percentange=sum(positive_emoi_index2)/length(raw_emoi_data);
    
    negative_emoi_index=raw_emoi_data<0;
    negative_emoi=raw_emoi_data(negative_emoi_index);
    negative_emoi_mean=mean(negative_emoi);
    negative_emoi_sd=std(negative_emoi);
    negative_emoi_sd1=negative_emoi_mean-negative_emoi_sd;
    negative_emoi_sd2=negative_emoi_mean-negative_emoi_sd*2;
    negative_emoi_index2=((negative_emoi<negative_emoi_sd1)&(negative_emoi>negative_emoi_sd2));
    nt_emoi_percentange=sum(negative_emoi_index2)/length(raw_emoi_data);
    
    % calc pt+(0.2-nt)/0.3
    emoi_mid_result=pt_emoi_percentange+(0.2-nt_emoi_percentange);
    if (emoi_mid_result/0.3)>0.95
        emoi_result=emoi_mid_result/0.4;
    else
        emoi_result=emoi_mid_result/0.3;
    end
    
    %% for scl calc pt and nt
    raw_scl_data= Index_xls(:,2);
    positive_scl_index=raw_scl_data>0;
    positive_scl=raw_scl_data(positive_scl_index);
    positive_scl_mean=mean(positive_scl);
    positive_scl_sd=std(positive_scl);
    positive_scl_sd1=positive_scl_mean+positive_scl_sd;
    positive_scl_sd2=positive_scl_mean+positive_scl_sd*2;
    positive_scl_index2=((positive_scl>positive_scl_sd1)&(positive_scl<positive_scl_sd2));
    pt_scl_percentange=sum(positive_scl_index2)/length(raw_scl_data);
    
    negative_scl_index=raw_scl_data<0;
    negative_scl=raw_scl_data(negative_scl_index);
    negative_scl_mean=mean(negative_scl);
    negative_scl_sd=std(negative_scl);
    negative_scl_sd1=negative_scl_mean-negative_scl_sd;
    negative_scl_sd2=negative_scl_mean-negative_scl_sd*2;
    negative_scl_index2=((negative_scl<negative_scl_sd1)&(negative_scl>negative_scl_sd2));
    nt_scl_percentange=sum(negative_scl_index2)/length(raw_scl_data);
    
    % calc scl index:pt+(0.2-nt)/0.3 or pt+(0.2-nt)/0.4
    scl_mid_result=pt_scl_percentange+(0.2-nt_scl_percentange);
    if (scl_mid_result/0.3)>0.95
        scl_result=scl_mid_result/0.4;
    else
        scl_result=scl_mid_result/0.3;
    end
    %% for high alpha calc pt and nt
    raw_high_data= Index_xls(:,3);
    positive_high_index=raw_high_data>0;
    positive_high=raw_high_data(positive_high_index);
    positive_high_mean=mean(positive_high);
    positive_high_sd=std(positive_high);
    positive_high_sd1=positive_high_mean+positive_high_sd;
    positive_high_sd2=positive_high_mean+positive_high_sd*2;
    positive_high_index2=((positive_high>positive_high_sd1)&(positive_high<positive_high_sd2));
    pt_high_percentange=sum(positive_high_index2)/length(raw_high_data);
    
    negative_high_index=raw_high_data<0;
    negative_high=raw_high_data(negative_high_index);
    negative_high_mean=mean(negative_high);
    negative_high_sd=std(negative_high);
    negative_high_sd1=negative_high_mean-negative_high_sd;
    negative_high_sd2=negative_high_mean-negative_high_sd*2;
    negative_high_index2=((negative_high<negative_high_sd1)&(negative_high>negative_high_sd2));
    nt_high_percentange=sum(negative_high_index2)/length(raw_high_data);
    
    % calc high index:pt+(0.2-nt)/0.3 or pt+(0.2-nt)/0.4
    high_mid_result=pt_high_percentange+(0.2-nt_high_percentange);
    if (high_mid_result/0.3)>0.95
        high_result=high_mid_result/0.4;
    else
        high_result=high_mid_result/0.3;
    end
    %% for gamma calc pt and nt
    raw_gamma_data= Index_xls(:,4);
    positive_gamma_index=raw_gamma_data>0;
    positive_gamma=raw_gamma_data(positive_gamma_index);
    positive_gamma_mean=mean(positive_gamma);
    positive_gamma_sd=std(positive_gamma);
    positive_gamma_sd1=positive_gamma_mean+positive_gamma_sd;
    positive_gamma_sd2=positive_gamma_mean+positive_gamma_sd*2;
    positive_gamma_index2=((positive_gamma>positive_gamma_sd1)&(positive_gamma<positive_gamma_sd2));
    pt_gamma_percentange=sum(positive_gamma_index2)/length(raw_gamma_data);
    
    negative_gamma_index=raw_gamma_data<0;
    negative_gamma=raw_gamma_data(negative_gamma_index);
    negative_gamma_mean=mean(negative_gamma);
    negative_gamma_sd=std(negative_gamma);
    negative_gamma_sd1=negative_gamma_mean-negative_gamma_sd;
    negative_gamma_sd2=negative_gamma_mean-negative_gamma_sd*2;
    negative_gamma_index2=((negative_gamma<negative_gamma_sd1)&(negative_gamma>negative_gamma_sd2));
    nt_gamma_percentange=sum(negative_gamma_index2)/length(raw_gamma_data);
    % calc gamma index:pt+(0.2-nt)/0.3 or pt+(0.2-nt)/0.4
    gamma_mid_result=pt_gamma_percentange+(0.2-nt_gamma_percentange);
    if (gamma_mid_result/0.3)>0.95
        gamma_result=gamma_mid_result/0.4;
    else
        gamma_result=gamma_mid_result/0.3;
    end
    
    %% Transposition for Visualization
    File_name=strrep(Index_Files(i).name,'_for_personal analysis.xlsx','_for_pt&nt.xlsx');
    sheet='pt&nt result';
    xlswrite(File_name,emoi_result,sheet,'A2');
    xlswrite(File_name,scl_result,sheet,'B2');
    xlswrite(File_name,high_result,sheet,'C2');
    xlswrite(File_name,gamma_result,sheet,'D2');
    emoi=char('emoi');scl=char('scl');high=char('high alpha');gamma=char('gamma');
    xlswrite(File_name,{emoi},sheet,'A1');
    xlswrite(File_name,{scl},sheet,'B1');
    xlswrite(File_name,{high},sheet,'C1');
    xlswrite(File_name,{gamma},sheet,'D1');
    
end
clc;clear;

