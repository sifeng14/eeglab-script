function [Trial,Subject,Stimulus,TimeTrialms,TimeRunms,Type,Event,Content,Content2] = importfile(filename, startRow, endRow)
%IMPORTFILE ���ı��ļ��е���ֵ������Ϊ��ʸ�����롣
%   [TRIAL,SUBJECT,STIMULUS,TIMETRIALMS,TIMERUNMS,TYPE,EVENT,CONTENT,CONTENT2]
%   = IMPORTFILE(FILENAME) ��ȡ�ı��ļ� FILENAME ��Ĭ��ѡ����Χ�����ݡ�
%
%   [TRIAL,SUBJECT,STIMULUS,TIMETRIALMS,TIMERUNMS,TYPE,EVENT,CONTENT,CONTENT2]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) ��ȡ�ı��ļ� FILENAME �� STARTROW �е�
%   ENDROW ���е����ݡ�
%
% Example:
%   [Trial,Subject,Stimulus,TimeTrialms,TimeRunms,Type,Event,Content,Content2] = importfile('p01-log.txt',2, 98);
%
%    ������� TEXTSCAN��

% �� MATLAB �Զ������� 2016/08/08 14:52:17

%% ��ʼ��������
delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% ����������Ϊ�ַ�����ȡ:
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%s%s%s%s%s%s%s%s%s%[^\n\r]';

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

for col=[1,4,5,9]
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
rawNumericColumns = raw(:, [1,4,5,9]);
rawCellColumns = raw(:, [2,3,6,7,8]);


%% ������ֵԪ���滻Ϊ NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % ���ҷ���ֵԪ��
rawNumericColumns(R) = {NaN}; % �滻����ֵԪ��

%% ����������������б�������
Trial = cell2mat(rawNumericColumns(:, 1));
Subject = rawCellColumns(:, 1);
Stimulus = rawCellColumns(:, 2);
TimeTrialms = cell2mat(rawNumericColumns(:, 2));
TimeRunms = cell2mat(rawNumericColumns(:, 3));
Type = rawCellColumns(:, 3);
Event = rawCellColumns(:, 4);
Content = rawCellColumns(:, 5);
Content2 = cell2mat(rawNumericColumns(:, 4));


