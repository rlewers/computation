% script that takes vector of r values for which to run the agg_savings 
% function over and then plots the results 

r_vec=0:0.001:0.04;
save_vec=zeros(40,1);

for i=1:length(r_vec)
    % calculate savings for the given r value
    save_vec(i)=agg_savings(r_vec(i));
end

figure()
plot(r_vec,save_vec)