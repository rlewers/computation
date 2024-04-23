function [v_new,c]=vfi_iteration_im(v0,param,num,grid,type)

v_old=v0; 

% upwind scheme 
[sf,sb,Va_Upwind]=vp_upwind_im(v_old,param,num,grid,type);

% Infer consumption from Va_Upwind
c = max(Va_Upwind,1e-08).^(-1);
u = utility(c) ;

% left middle and right pieces of the nonzero diagonal component of A
left=-min(sb,0)/grid.da; 
middle=min(sb,0)/grid.da-max(sf,0)/grid.da; 
right=max(sf,0)/grid.da;

% make A 
A=spdiags(middle,0,num.a_n,num.a_n)+... %place middle on the main diagonal
    spdiags(left(2:num.a_n),-1,num.a_n,num.a_n)+... % place left below main diagonal
    spdiags([0;right(1:num.a_n-1)],1,num.a_n,num.a_n); % place right above the main diagonal

% use matrix left division and the speye function for creating sparce
% identity matrix to calculate A 
v_new=((param.rho+(1/num.delta_im))*speye(num.a_n)-A)\(u+v_old/num.delta_im);

end
