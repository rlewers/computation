clear all ; close all ; clc ;
tic ;
% create structure with structural parameters
call_parameters;
% create structure with numerical parameters
numerical_parameters ;
% create structure with grids and initial guesses for v
grid = create_grid(param,num) ;

%error = @(r) excess_demand(r,param,num,grid);

r_initial=0.01;

r_star=fminsearch(@excess_demand,r_initial);

w=(1-param.alpha)*(param.alpha/(r_star+param.delta))^(param.alpha/(1-param.alpha));


toc ;


