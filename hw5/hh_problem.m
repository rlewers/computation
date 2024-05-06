function [c,savings,lsupply,ksupply]=hh_problem(r,w,param,num,grid)

% create structure with structural parameters
call_parameters;
% create structure with numerical parameters
numerical_parameters ;
% create structure with grids and initial guesses for v
grid = create_grid(param,num) ;

v_old = grid.v0 ;

dist = 1 ;
while dist > num.tol 
    [v_new,~,~,~] = vfi_iteration(v_old,param,num,grid,w,r) ;
    dist = max(abs((v_new(:) - v_old(:)))) ;
    v_old = v_new ;
   % disp(dist)
end
[v_new,c,savings,A] = vfi_iteration(v_new,param,num,grid,w,r) ;


[gg] = kf_equation(A,grid,num) ;
g = [gg(1:num.a_n),gg(num.a_n+1:2*num.a_n)];
lsupply=sum(sum(param.e.*g.*grid.da));
ksupply=sum(sum(grid.a.*g.*grid.da));

end
