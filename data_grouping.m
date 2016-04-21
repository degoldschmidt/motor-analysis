function [analysis] = data_grouping( task_version, suffix)
% data_grouping groups data from same task and formats it to a proper shape
%  task_version= 'v1';
%  suffix= 'mycoolsuf'; adds optional suffix to saved file
if nargin < 2
    suffix='';
end

%Path to a folder with all data split in folders called "v1","v2","v3"...
%path_folder = 'C:\Users\Rodrigo\Documents\INDP2015\Motor Week\Data';
analysis_folder = pwd
path_folder = ['..' filesep 'motor-data'];
path_data = [path_folder filesep task_version, '_*.mat']
% Gets data files to analyze
d = dir(path_data)
str = {d.name};
str = sortrows({d.name}');
[s,v] = listdlg('PromptString','Select files to group up:', 'OKString', 'OK',...
    'SelectionMode','multiple',...
    'ListString', str, 'Name', 'Select a File');
names = str(s);
numFiles = size(names, 1);

block={'Train','Test','After'};

cd(path_folder)
counter=1;
for i=1:numFiles
    file = load(names{i});
    x = length(file.Train.TrialDataXYTrain);
    y = length(file.Test.TrialDataXYTest);
    z = length(file.After.TrialDataXYAfter);
    %[names(i) x y z]
    if (x==101 && y==151 && z==151)
        ['---> ' names(i) ' added.']
        subject{counter}=open(names{i});
        counter = counter + 1;
    else
        ['---> ' names(i) ' not added.']
    end
end

cd(analysis_folder)
for i=1:(counter-1)
    
    %Train - block1
    [analysis{i}.(block{1}).TrajsTang, analysis{i}.(block{1}).TargetAngle, analysis{i}.(block{1}).Teach, ...
        analysis{i}.(block{1}).Curl, analysis{i}.(block{1}).ErrAng, analysis{i}.(block{1}).NT, analysis{i}.(block{1}).CutInds,...
        analysis{i}.(block{1}).ErrAngss] = GetKineticParamsCursorMovementTrain( subject{i}.(block{1}) );
    
    %Test - block2
    [analysis{i}.(block{2}).TrajsTang, analysis{i}.(block{2}).TargetAngle, analysis{i}.(block{2}).Teach, ...
        analysis{i}.(block{2}).Curl, analysis{i}.(block{2}).ErrAng, analysis{i}.(block{2}).NT, analysis{i}.(block{2}).CutInds,...
        analysis{i}.(block{2}).ErrAngss] = GetKineticParamsCursorMovementTest( subject{i}.(block{2}) );
    
    %After - block3
    [analysis{i}.(block{3}).TrajsTang, analysis{i}.(block{3}).TargetAngle, analysis{i}.(block{3}).Teach, ...
        analysis{i}.(block{3}).Curl, analysis{i}.(block{3}).ErrAng, analysis{i}.(block{3}).NT, analysis{i}.(block{3}).CutInds,...
        analysis{i}.(block{3}).ErrAngss] = GetKineticParamsCursorMovementAfter( subject{i}.(block{3}) );
   
    analysis{i}.name = names{i};
    analysis{i}.task_version = task_version;
end

output_folder = [path_folder filesep 'processed-data'];
if exist(output_folder,'dir')==0
    mkdir(output_folder);
end
save([path_folder filesep 'processed-data' filesep 'analysis_', task_version, '_', suffix, '.mat'],'analysis')

end

