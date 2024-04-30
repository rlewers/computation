function [savings]=agg_savings(r)

call_parameters; 
numerical_parameters; 
grid=create_grid(param,num)

% set the interest rate in the model to r 
param.r=r;

% guess initial value function 
v_old=grid.v0;

% iterate to reach the converged value function 
dist = 1;
while dist>num.tol
    [v_new,~,~]=vfi_iteration(v_old,param,num,grid);
    dist=max(abs(v_new(:)-v_old(:)));
    v_old=v_new;
end

[v_new,c,A]=vfi_iteration(v_new,param,num,grid);
[gg]=kf_equation(A,grid,num);
g=[gg(1:num.a_n),gg(num.a_n+1:2*num.a_n)];

% aggregate savings (overall wealth) 
savings=sum(sum(grid.a .* g .* grid.da));