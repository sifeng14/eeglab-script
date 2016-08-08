function [Trial,Subject,Stimulus,TimeTrialms,TimeRunms,Type,Event,Content,Content2] = importfile(filename, startRow, endRow)
%IMPORTFILE 将文本文件中的数值数据作为列矢量导入。
%   [TRIAL,SUBJECT,STIMULUS,TIMETRIALMS,TIMERUNMS,TYPE,EVENT,CONTENT,CONTENT2]
%   = IMPORTFILE(FILENAME) 读取文本文件 FILENAME 中默认选定范围的数据。
%
%   [TRIAL,SUBJECT,STIMULUS,TIMETRIALMS,TIMERUNMS,TYPE,EVENT,CONTENT,CONTENT2]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) 读取文本文件 FILENAME 的 STARTROW 行到
%   ENDROW 行中的数据。
%
% Example:
%   [Trial,Subject,Stimulus,TimeTrialms,TimeRunms,Type,Event,Content,Content2] = importfile('p01-log.txt',2, 98);
%
%    另请参阅 TEXTSCAN。

% 由 MATLAB 自动生成于 2016/08/08 14:52:17

%% 初始化变量。
delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% 将数据列作为字符串读取:
% 有关详细信息，请参阅 TEXTSCAN 文档。
formatSpec = '%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% 打开文本文件。
fileID = fopen(filename,'r');

%% 根据格式字符串读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% 关闭文本文件。
fclose(fileID);

%% 将包含数值字符串的列内容转换为数值。
% 将非数值字符串替换为 NaN。
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,4,5,9]
    % 将输入元胞数组中的字符串转换为数值。已将非数值字符串替换为 NaN。
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % 创建正则表达式以检测并删除非数值前缀和后缀。
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % 在非千位位置中检测到逗号。
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % 将数值字符串转换为数值。
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% 将数据分割为数值列和元胞列。
rawNumericColumns = raw(:, [1,4,5,9]);
rawCellColumns = raw(:, [2,3,6,7,8]);


%% 将非数值元胞替换为 NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % 查找非数值元胞
rawNumericColumns(R) = {NaN}; % 替换非数值元胞

%% 将导入的数组分配给列变量名称
Trial = cell2mat(rawNumericColumns(:, 1));
Subject = rawCellColumns(:, 1);
Stimulus = rawCellColumns(:, 2);
TimeTrialms = cell2mat(rawNumericColumns(:, 2));
TimeRunms = cell2mat(rawNumericColumns(:, 3));
Type = rawCellColumns(:, 3);
Event = rawCellColumns(:, 4);
Content = rawCellColumns(:, 5);
Content2 = cell2mat(rawNumericColumns(:, 4));


