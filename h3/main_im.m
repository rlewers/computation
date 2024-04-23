clear all ; close all ; clc ;
tic ;
% create structure with structural parameters
call_parameters_im;
% create structure with numerical parameters
numerical_parameters_im;
% create structure with grids and initial guesses for v
grid = create_grid_im(param,num) ;

% create a function vfi_iteration that takes as input the structures
% previously created and produces a guess for v and c.

%addpath '/Users/rileylewers/Desktop/281-Computational-main/Topic3/codes/exercise_0/prompt'
%v_old = grid.v0 ;
%[v_guess,c_guess] = vfi_iteration_lab(v_old,param,num,grid) ;


% Problem 1, endowment economy

v_old = grid.v0 ;
dist = 1 ;
while dist > num.tol 
    [v_new,~] = vfi_iteration_im(v_old,param,num,grid,'endowment') ;
    dist = max(abs((v_new - v_old))) ;
    v_old = v_new ;
end

[v_new,c] = vfi_iteration_im(v_old,param,num,grid,'endowment') ;

figure()
plot(c,'o')
hold
plot(param.y + param.r*grid.a,'r')  

% Problem 2, equivalence between discrete and continuous time happens when 
% we set beta=e^-rho and delta=1

% Problem 3, production economy

v_old = grid.v0 ;
dist = 1 ;
while dist > num.tol 
    [v_new,~] = vfi_iteration_im(v_old,param,num,grid,'production') ;
    dist = max(abs((v_new - v_old))) ;
    v_old = v_new ;
end

[v_new,c] = vfi_iteration_im(v_old,param,num,grid,'production') ;

figure()
plot(c,'o')
hold
%plot(y_value + param.r*grid.a,'r')


% Problem 4, technology choice
% Doesn't run :(

v_old = grid.v0 ;
dist = 1 ;
while dist > num.tol 
    [v_new,~] = vfi_iteration_4(v_old,param,num,grid,0) ;
    dist = max(abs((v_new - v_old))) ;
    v_old = v_new ;
end

[v_new,c1] = vfi_iteration_4(v_old,param,num,grid,0) ;
toc ;

figure()
plot(c,'o')
hold
%plot(y_value + param.r*grid.a,'r')
