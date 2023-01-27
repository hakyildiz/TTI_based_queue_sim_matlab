clc;
clear all;
sim_number = 1;
sim_thrpt_list = [];
sim_avg_delay_list = [];
sim_time = 10000; %ms
sim_step = sim_time / Constants.TTI;
sim_avg_delay_list = [];

for sim = 1 : sim_number    
    user_list = initialize_users_for_sim(sim_time);
    for step = 1 : sim_step
        for u = 1 : length(user_list)
            user = user_list(1,u);
            % there should be algorithm for MU_bit calculation for each TTI
            % how many bits in each TTI
            MU_bit = calculate_mu_bit_algorithm();
            queue_timeslot(user, MU_bit, step)
        end
    end
    % result calculation
    [thrpt,avg_delay] = result_calculation(user_list,sim_time);
    sim_avg_delay_list(1,sim) = avg_delay;
end

sim_delay = mean(sim_avg_delay_list)



