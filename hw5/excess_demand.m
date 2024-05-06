function [excess]=excess_demand(r)

% create structure with structural parameters
call_parameters;
% create structure with numerical parameters
numerical_parameters ;
% create structure with grids and initial guesses for v
grid = create_grid(param,num) ;

w=(1-param.alpha)*(param.alpha/(r+param.delta))^(param.alpha/(1-param.alpha));

[c,savings,lsupply,ksupply]=hh_problem(r,w,param,num,grid);
[k_demand] = firm_problem(lsupply,r,w,param,num,grid);
excess=(k_demand-ksupply)^2;
end