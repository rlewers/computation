function [sf,sb,Va_Upwind] = vp_upwind(v0,param,num,grid,kappa)

% unpack the initial guess for v0 and call it V
V=v0 ;


%initialize forward and backwards differences with zeros: Vaf Vab

Vaf = zeros(num.a_n,1) ;
Vab = zeros(num.a_n,1) ;


% use V to compute backward and forward differences

Vaf(1:end-1) = (V(2:end) - V(1:end-1))/grid.da;
Vab(2:end) = (V(2:end) - V(1:end-1))/grid.da;

% impose the following boundary conditions. We will talk about them.
Vaf(end) = 0; 

% solve for optimal (unconstrained) capital and production using the bad technology
kstar_b=(param.r/(num.fb_prod_b*num.fb_alpha))^(1/(num.fb_alpha-1));
y_value_b=num.fb_prod_b*kstar_b^num.fb_alpha-param.r*kstar_b;

% solve for optimal (unconstrained) capital and production using the good technology 
kstar_g=(param.r/(num.fb_prod_g*num.fb_alpha))^(1/(num.fb_alpha-1))+kappa;
y_value_g=num.fb_prod_g*kstar_g^num.fb_alpha-param.r*kstar_g;

% for each asset level in the grid, pick whichever technology gives higher profits 
y_value=zeros(length(grid),1);
for i=1:length(grid)

% calculate constrained optimum for good and bad technology
y_value_b_const=num.fb_prod_b*grid(i)^num.fb_alpha-param.r*grid(i);
y_value_g_const=num.fb_prod_g*(grid(i)-kappa)^num.fb_alpha-param.r*kstar_g_const;

% case where unconstrained optimum is the bad technology
if y_value_b>y_value_g
    y_value(i)=y_value_b;
% case where unconstrained optimum is the good technology 
% and agent is unconstrained
elseif y_value_g>y_value_b && grid(i)>kstar_g
    y_value(i)=y_value_g;
% case where unconstrained optimum is the good technology 
% and agent is constrained
elseif y_value_g>y_value_b && grid(i)<kstar_g && grid(i)>kstar_b
    if y_value_g_const>y_value_b
        y_value(i)=y_value_g_const;
    else 
        y_value(i)=y_value_b;
    end
else 
    if y_value_g_const>y_value_b_cont
        y_value(i)=y_value_g_const;
    else 
        y_value(i)=y_value_b_const;
    end
end
end


Vab(1) = (param.r*grid.a(1) + y_value).^(-1); %state constraint boundary condition    

%consumption and savings with forward difference
cf = max(Vaf,1e-08).^(-1);
sf = y_value + param.r.*grid.a - cf;


%consumption and savings with backward difference
cb = max(Vab,1e-08).^(-1);
sb = y_value + param.r.*grid.a - cb;
%consumption and derivative of value function at steady state
c0 = y_value+param.r.*grid.a;
Va0 = c0.^(-1);


% compute indicator functions that capture the upwind scheme.
If = sf > 0; % positive drift --> forward difference
Ib = sb < 0; % negative drift --> backward difference
I0 = 1-If-Ib; % at steady state


% Compute the upwind scheme
Va_Upwind = Vaf.*If + Vab.*Ib + Va0.*I0;

end