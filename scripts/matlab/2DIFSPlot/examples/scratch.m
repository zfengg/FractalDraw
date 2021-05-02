clc,clear

BMcarpet_p = 3; % the horizontal partition size
BMcarpet_q = 4; % the vertical partition size
BM_select = [1 0 1; 0 1 0; 1 0 0; 1 0 1]; % position of selected rectangles

BM_mat = flipud(BM_select);
[one_row, one_col] = find(BM_mat>0);
BM_size = length(one_row);

BM_linear = [1/BMcarpet_p 0; 0 1/BMcarpet_q];
Linearpart = cell(1, BM_size);
Transpart = cell(1, BM_size);
for i = 1:BM_size
    Linearpart{i} = BM_linear;
    Transpart{i} = [one_col(i)-1; one_row(i)-1];
end

%%

aa = randi(3, 2, 3)
bb = (1:2)'


