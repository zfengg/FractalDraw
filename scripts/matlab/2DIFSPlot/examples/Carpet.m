%% To plot the iterations of polygons under AFFINE IFS
clc, clf, clear
tic

%% Setting up

% % Bedford-Mcmullen
% BMcarpet_p = 2; % the horizontal partition size
% BMcarpet_q = 3; % the vertical partition size
% BM_select = [0 1; 1 0; 0 1]; % position of selected rectangles
%
% BM_mat = flipud(BM_select);
% [one_row, one_col] = find(BM_mat>0);
% BM_size = length(one_row);
% BM_linear = [1/BMcarpet_p 0; 0 1/BMcarpet_q];
% Linearpart = cell(1, BM_size);
% Transpart = cell(1, BM_size);
% for i = 1:BM_size
%     Linearpart{i} = BM_linear;
%     Transpart{i} = [(one_col(i)-1)*(1/BMcarpet_p); (one_row(i)-1)*(1/BMcarpet_q)];
% end

% Baranski
Bar_p = [0.1 0.3 0.4 0.2];
Bar_q = [0.1 0.2 0.4 0.3];
Bar_select = [1 0 1 0; 0 1 0 1; 0 0 0 0; 0 0 1 0];

Bar_mat = flipud(Bar_select);
[one_row, one_col] = find(Bar_mat > 0);
Bar_size = length(one_row);
Linearpart = cell(1, Bar_size);
Transpart = cell(1, Bar_size);

for i = 1:Bar_size
    Linearpart{i} = [Bar_p(one_col(i)) 0; 0 Bar_q(one_row(i))];
    Transpart{i} = [sum(Bar_p(1:one_col(i))) - Bar_p(one_col(i)); sum(Bar_q(1:one_row(i))) - Bar_q(one_row(i))];
end

% General Carpet
% Linearpart = {[1/3 0; 0 1/3], [1/3 0; 0 1/3], [1/3 0; 0 1/3], [1/3 0; 0 1/3], [1/3 0; 0 1/3], [1/3 0; 0 1/3], [1/3 0; 0 1/3], [1/3 0; 0 1/3]};
% Transpart = {[0;0], [1/3;0], [2/3;0], [0;1/3], [2/3;1/3], [0;2/3], [1/3;2/3], [2/3;2/3]};

Initialshape = [0 1 1 0; 0 0 1 1];
Iterationlevel = 8; % the level of iteration

%% Check the compactibility of the settings
CompactibilityFlag = false;

if length(Linearpart) == length(Transpart)
    CompactibilityFlag = true;
end

if ~CompactibilityFlag
    error('Illegal settings. The dimensions of the parameter vectors should match!')
end

Num = length(Linearpart); % the number of fuctions in IFS if the settings are legal
[~, Shapesize] = size(Initialshape); % the dimension of the IFS the number of vertice of the initial shape

%% Generate the vertice under iterations
Initialpoints = Initialshape; % the inital points for iteration
Currentpoints = Initialpoints; % the store the points at current level
Currentsize = Shapesize; % the size of the set of current points

Totalpoints = cell(Iterationlevel + 1, 1); % to store the points after each iteration
Totalpoints{1} = Initialpoints;

for Currentlevel = 1:Iterationlevel

    % Since we can not use the kronecker product directly due to the failure of
    % complex representing of the linear part, we have to do the
    % sub-iterations

    Temptpoints = zeros(2, Currentsize * Num); % To store the temperate generated points after each subiteration

    for subiteration = 1:Num
        % Store the generated points
        Temptpoints(:, (subiteration - 1) * Currentsize + 1:subiteration * Currentsize) = ...
            Linearpart{subiteration} * Currentpoints + Transpart{subiteration};
    end

    % Renew the Currentpoints and Currentsize
    Currentpoints = Temptpoints;
    [~, Currentsize] = size(Currentpoints);

    Totalpoints{Currentlevel + 1} = Currentpoints;
end

%% Plot the iterated graph
Xplotpts = reshape(Currentpoints(1, :), Shapesize, []); % reshape the x-coord for plotting
Yplotpts = reshape(Currentpoints(2, :), Shapesize, []); % reshape the y-coord for plotting

figure(1)
patch(Xplotpts, Yplotpts, 'black')
xlim([0 1]) % fix the range of plotting canvas
ylim([0 1])
set(gca, 'XColor', 'none', 'YColor', 'none')
title(['Iteration Level=', num2str(Iterationlevel)], 'Interpreter', 'latex');

% figure(2)
% for plotposition = 1:3
%
%     subplot(1,3,plotposition)
%     Xsubplotpts = reshape(Totalpoints{plotposition}(1,:), Shapesize, []); % reshape the x-coord for plotting
%     Ysubplotpts = reshape(Totalpoints{plotposition}(2,:), Shapesize, []); % reshape the y-coord for plotting
%     patch(Xsubplotpts,Ysubplotpts,'black')
%     set(gca,'XColor', 'none','YColor','none')
%     % title(['Iteration Level=',num2str(plotposition-1)], 'Interpreter', 'latex');
%
% end

%% Output the other parameters
Num_Current_Points = Currentsize;
[~, Num_Current_Shapes] = size(Xplotpts);
tableResults = table(Num_Current_Points, Num_Current_Shapes);
disp(tableResults)
