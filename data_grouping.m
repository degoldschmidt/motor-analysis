function [analysis] = data_grouping( task_version )
% data_grouping groups data from same task and formats it to a proper shape
%  task_version= 'v1'; 

%Path to a folder with all data split in folders called "v1","v2","v3"...
path_folder = 'C:\Users\Rodrigo\Documents\INDP2015\Motor Week\Data';
path_data = [path_folder filesep task_version];
% Gets data files to analyze
d = dir(path_data);
str = {d.name};
str = sortrows({d.name}');
[s,v] = listdlg('PromptString','Select files to group up:', 'OKString', 'OK',...
    'SelectionMode','multiple',...
    'ListString', str, 'Name', 'Select a File');
names = str(s);
numFiles = size(names, 1);

block={'Train','Test','After'};

cd(path_data)
for i=1:numFiles
    subject{i}=open(names{i});
end

for i=1:numFiles
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


end

