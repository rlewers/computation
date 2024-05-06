function [k_demand] = firm_problem(lsupply,r,w,param,num,grid)

% k demand
k_demand=(param.alpha/(r+param.delta))^(1/(1-param.alpha))*lsupply;

end
