function [sim]=simulate(c,param,num,grid)
% not complete/doesn't run, ran out of time

% update transition matrix based on param.lambda
% first element of param.lambda is intensity of transitioning from low
% state to high state 
% second element of param.lambda is intensity of transitioning from high
% state to low state
P = zeros(2,2);

% fill in elements 
P(1,2)=param.lambda(1)*num.delta;
P(1,1)=1-P(1,2);
P(2,1)=param.lambda(2)*num.delta;
P(2,2)=1-P(2,1);

sim.a_fine=linspace(num.a_min,num.a_max,num.a_n_fine);

sim.c_interp=interp1(grid.a,c,sim.a_fine);

% initialize asset and state matrices 
sim.a=nan(num.T,num.N); % column is assets of person, rows are time period
sim.state = nan(num.T,num.N); % column is time period, rows are the states of the agents
sim.a_index=nan(num.T,num.N);
sim.s_index=nan(num.T,num.N);

sim.a_index(1,:)=randi(num.a_n_fine,[1 num.N]); % initial position (index)
sim.a(1,:)=sim.a_fine(sim.a_index(1,:)); % initial asset holdings

sim.s(1,:) = randi([0.1, 0.2], [1, num.N]); % initial employment state
% initial employment index
for i=1:num.N 
    if sim.s(1:i)==.1
        sim.s_index(1:i)=1;
    else
        sim.s_index(1:i)=2;
    end
end

for tt = 2:num.T
    % determine income based on state 
    income = param.y(1) .* (sim.state(tt-1,:) == 0.1) + param.y(2) .* (sim.state(tt-1,:) == 0.2);

    %sim.a(tt,:) = sim.a_fine(sim.a_index(tt-1,:)) + num.delta*(param.r*sim.a_fine(sim.a_index(tt-1,:)) + param.y - sim.c_interp(sim.a_index(tt-1,:))) ;
    
    % Update asset holdings
    sim.a(tt,:) = sim.a_fine(sim.a_index(tt-1,:)) + num.delta * (param.r * sim.a_fine(sim.a_index(tt-1,:)) + income - sim.c_interp(sim.a_index(tt-1,:)));
    
    % Update asset index
    sim.a_index(tt,:) = knnsearch(sim.a_fine',sim.a(tt,:)') ;

    % Update employment state
    for i=1:num.N
        curr_state=sim.s(i);
        trans_probs=P(curr_state,:);
        random_number=rand();

        cum_prob = 0;
        for state=1:length(param.lambda)
            cum_prob=cum_prob+trans_probs(state);
            if random_number <= cum_prob
                sim.s(tt,i)=param.lambda(state);
                sim.s_index(tt,i)=state;
                break;
            end
        end 
    end

    sim.a_index(tt,:) = knnsearch(sim.a_fine',sim.a(tt,:)') ;

    % Record consumption for the previous period
    sim.c(tt-1,:) = sim.c_interp(sim.a_index(tt-1,:)) ;

    temp = regress(sim.c_interp(sim.a_index(tt-1,:))',[ones(num.N,1) sim.a_fine(sim.a_index(tt-1,:))']) ;
    sim.beta_0(tt) = temp(1) ;
    sim.beta_1(tt) = temp(2) ;

    
end

sim.beta_0(1) = nan ;
sim.beta_1(1) = nan ;

   

end