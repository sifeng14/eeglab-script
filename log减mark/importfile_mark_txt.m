function [Trial_mark,Subject_mark,Color_mark,Name_mark,Stimulus_mark,StartTimems,EndTimems,TriggerLineStartms,TriggerLineDurationms,TriggerLineEndms,Number,PortStatus] = importfile(filename, startRow, endRow)
%IMPORTFILE ���ı��ļ��е���ֵ������Ϊ��ʸ�����롣
%   [TRIAL,SUBJECT,COLOR,NAME,STIMULUS,STARTTIMEMS,ENDTIMEMS,TRIGGERLINESTARTMS,TRIGGERLINEDURATIONMS,TRIGGERLINEENDMS,NUMBER,PORTSTATUS]
%   = IMPORTFILE(FILENAME) ��ȡ�ı��ļ� FILENAME ��Ĭ��ѡ����Χ�����ݡ�
%
%   [TRIAL,SUBJECT,COLOR,NAME,STIMULUS,STARTTIMEMS,ENDTIMEMS,TRIGGERLINESTARTMS,TRIGGERLINEDURATIONMS,TRIGGERLINEENDMS,NUMBER,PORTSTATUS]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) ��ȡ�ı��ļ� FILENAME �� STARTROW �е�
%   ENDROW ���е����ݡ�
%
% Example:
%   [Trial,Subject,Color,Name,Stimulus,StartTimems,EndTimems,TriggerLineStartms,TriggerLineDurationms,TriggerLineEndms,Number,PortStatus] = importfile('p01-mark.txt',2, 3);
%
%    ������� TEXTSCAN��

% �� MATLAB �Զ������� 2016/08/08 15:20:08

%% ��ʼ��������
delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% ����������Ϊ�ַ�����ȡ:
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% ���ı��ļ���
fileID = fopen(filename,'r');

%% ���ݸ�ʽ�ַ�����ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% �ر��ı��ļ���
fclose(fileID);

%% ��������ֵ�ַ�����������ת��Ϊ��ֵ��
% ������ֵ�ַ����滻Ϊ NaN��
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,6,7,8,9,10,11,12]
    % ������Ԫ�������е��ַ���ת��Ϊ��ֵ���ѽ�����ֵ�ַ����滻Ϊ NaN��
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % ����������ʽ�Լ�Ⲣɾ������ֵǰ׺�ͺ�׺��
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % �ڷ�ǧλλ���м�⵽���š�
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % ����ֵ�ַ���ת��Ϊ��ֵ��
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% �����ݷָ�Ϊ��ֵ�к�Ԫ���С�
rawNumericColumns = raw(:, [1,6,7,8,9,10,11,12]);
rawCellColumns = raw(:, [2,3,4,5]);


%% ����������������б�������
Trial_mark = cell2mat(rawNumericColumns(:, 1));
Subject_mark = rawCellColumns(:, 1);
Color_mark = rawCellColumns(:, 2);
Name_mark = rawCellColumns(:, 3);
Stimulus_mark = rawCellColumns(:, 4);
StartTimems = cell2mat(rawNumericColumns(:, 2));
EndTimems = cell2mat(rawNumericColumns(:, 3));
TriggerLineStartms = cell2mat(rawNumericColumns(:, 4));
TriggerLineDurationms = cell2mat(rawNumericColumns(:, 5));
TriggerLineEndms = cell2mat(rawNumericColumns(:, 6));
Number = cell2mat(rawNumericColumns(:, 7));
PortStatus = cell2mat(rawNumericColumns(:, 8));


