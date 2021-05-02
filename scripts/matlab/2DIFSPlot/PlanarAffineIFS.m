%% To plot the iterations of polygons under AFFINE IFS
clc, clf, clear
tic

%% Setting up
Linearpart = {[0.25 0; 0 0.25], ...
            [0.25 0; 0 0.25], ...
            [0.25 0; 0 0.25], ...
            [0.25 0; 0 0.25], ...
            [0.5 0; 0 0.5]}; % the linar parts of the Affine IFS
Transpart = {[0; 0], ...
            [0.75; 0], ...
            [0.75; 0.75], ...
            [0; 0.75], ...
            [0.25; 0.25]}; % the translation parts of the Affine IFS
Initialshape = [0 1 1 0; 0 0 1 1]; % the vertices of the initial polygon
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
[~, Shapesize] = size(Initialshape);

%% Generate the vertice under iterations
Initialpoints = Initialshape;
Currentpoints = Initialpoints;
Currentsize = Shapesize;
Totalpoints = cell(Iterationlevel + 1, 1);
Totalpoints{1} = Initialpoints;

for Currentlevel = 1:Iterationlevel

    Temptpoints = zeros(2, Currentsize * Num);
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
