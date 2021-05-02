%% To plot the iterations of polygons under AFFINE IFS
clc, clf, clear
tic

%% Setting up

% discontinuity of dim self-affine
% ex1_lambda = 0;
% Linearpart = {[0.5 0; 0 1/3], [0.5 0; 0 1/3]};
% Transpart = {[0; 2/3], [ex1_lambda; 0]};
% Initialshape = [0 1 1 0; 0 0 1 1];

% Affine Sierpinski triangles for different a and b
affST_a = 0.25;
affST_b = 0.7;
Linearpart = {[affST_a 0; 0 affST_b], [1 - affST_a 1 - affST_a - affST_b; 0 affST_b], [1 - affST_b 0; 0 1 - affST_b]};
Transpart = {[0; 0], [affST_a; 0], [0; affST_b]};
Initialshape = [0 1 0; 0 0 1];

% Bedford-Mcmullen Carpets
% BMcarpet_p = 3; % the horizontal partition size
% BMcarpet_q = 4; % the vertical partition size
% BM_select = [1 0 1; 0 1 0; 1 0 0; 1 0 1]; % position of selected rectangles
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
% Initialshape = [0 1 1 0; 0 0 1 1];

Iterationlevel = 6; % the level of iteration

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
