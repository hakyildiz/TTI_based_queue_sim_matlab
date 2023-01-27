function [user_list] = initialize_users_for_sim(sim_time)

    for i = 1:Constants.user_number
        user = User;
        user.lambda = Constants.User_LAMBDA;

        % generate packet times in advanced 
        % poisson distribution
        len = user.lambda * sim_time;
        arr_times = cumsum(exprnd(1/user.lambda,1,len));
        arr_times = arr_times(arr_times<sim_time);
        
        % calculate queue len for the first timeslot
        user.packet_arrival_times = arr_times;
        index_list = find( arr_times >= 0 & arr_times <= Constants.TTI );
        user.queue_len = length(index_list); 

        user.total_packet_count = 0;
        user.delay_avg_list = [];
        user.queue_len_list = [];
        user.queue_len_list(1,1) = user.queue_len;
        user.waiting_packet_index_list = [];
    
        user_list(1,i) = user; 
    end
end