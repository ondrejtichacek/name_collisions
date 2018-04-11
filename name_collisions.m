function [duplicate_names, duplicates] = name_collisions(top_directory, filename_extension, exclude_directories, silent)
%NAME_COLLISIONS
% Finds name collisions of files in Matlab path.
%
%   INPUT:
%     top_directory       ... top directory (default = current directory)
%     filemane_extension  ... filename extension to look for (default = {'.m', '.mat'})
%     exclude_directories ... pattern for genpath_exclude
%     silent              ... suppress stdout (default = false)
%
%   OUTPUT:
%     duplicate_names     ... cell with duplicate names (unique)
%     duplicates          ... structure with duplicate files as if output by the dir() function
%
%   EXAMPLE:
%     [duplicate_names, duplicates] = name_collisions();
%     [duplicate_names, duplicates] = name_collisions(pwd, {'.m', '.mat'}, {'\.git'}, false);
%
%
%   AUTHOR: Ondrej Tichacek


if nargin < 1
    top_directory = pwd;
end
if nargin < 2
    filename_extension =  {'.m', '.mat'};
end
if nargin < 3
    exclude_directories = {'\.git'};
end
if nargin < 4
    silent = false;
end

%%

pathCell = regexp(path, pathsep, 'split');

if exist('genpath_exclude', 'file')
    p = genpath_exclude(top_directory, exclude_directories);
else
    warning('genpath_exclude.m not found. The parameter exclude_directories will not be considered. You can download genpath_exclude at https://www.mathworks.com/matlabcentral/fileexchange/22209-genpath-exclude');
    p = genpath(top_directory);
end

p = regexp(p, pathsep, 'split');

is_on_path = cellfun(@(x) isonpath(x, pathCell), p, 'UniformOutput', true);

p = p(is_on_path);

f = cellfun(@dir, p, 'UniformOutput', false);
f = cat(1, f{:});

f = f([f.isdir] == false);

ind_like_expr = zeros(size(f), 'logical');
for i = 1:numel(filename_extension)
    expr = ['.*\', filename_extension{i}, '$'];

    start_index = regexp({f.name}, expr)';
    ind_like_expr = ind_like_expr | not(cellfun(@isempty, start_index, 'UniformOutput', true));
end

% restrict to pattern
f = f(ind_like_expr);

% sort
[~,ind] = sort({f.name});
f = f(ind);

% init duplicate field
duplicate = zeros(size(f), 'logical');

% find duplicates
for i = 1:numel(f)-1
    if strcmp(f(i).name, f(i+1).name)
        [duplicate(i), duplicate(i+1)] = deal(true);
    end
end

duplicates = f(duplicate);

[duplicate_names, ~, ic] = unique({duplicates.name});


% print to stdout
if silent == false
    fprintf('Found the following duplicate names:\n\n');
    for i = 1:numel(duplicate_names)
        fprintf('% 3d x    %s\n', sum(ic==i), duplicate_names{i});
    end
end

%%

    function onPath = isonpath(Folder, pathCell)
        if ispc  % Windows is not case-sensitive
            onPath = any(strcmpi(Folder, pathCell));
        else
            onPath = any(strcmp(Folder, pathCell));
        end
    end
end
