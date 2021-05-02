%% Scratch Paper
clc,clear

%% complex number
a = [1212+232i, 2232+2232i]
b = [121+232i]
a * b
plot(b,'*')

%% Kronecker product
r = [1/2; 1/3; 1/4]
x = [1;2;3]
kron(r,x)
t = kron([1;2;3],ones(3,1))
kron(r,x)+t

%% 
c = exp(i*[1 2])
d = [0.5 0.2].* c

%% plot multiple polygons
figure(1)
subplot(1,3,1);
x2 = [2 5; 2 5; 8 8];
y2 = [4 0; 8 2; 4 0];
patch(x2,y2,'black')
set(gca,'XColor', 'none','YColor','none')

subplot(1,3,2);
x = [2 7 8 0]';
y = [1 2 8 3]';
patch(x,y,'magenta')
set(gca,'XColor', 'none','YColor','none')

figure(2)
x = [0 1 1 0]';
y = [0 0 1 1]';
patch(x,y,'cyan')
set(gca,'XColor', 'none','YColor','none')

%% Test of reshape
A = [1 1 1 1 2 2 2 2 3 3 3 3];
AA = reshape(A,4,[])


%% Review of cell structure
Linearpart = {[0.25 0; 0 0.25],[0.25 0; 0 0.25],[0.25 0; 0 0.25]} 
Linearpart{1}

%%
C = [0.25; 0.5];
CC = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
kron(C, CC)
