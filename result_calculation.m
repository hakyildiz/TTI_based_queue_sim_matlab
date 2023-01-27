function [thrpt,avg_delay] = result_calculation(user_list,sim_time)
    
    sim_step = ceil(sim_time / Constants.TTI);
    user_number = length(user_list);
    total_t = 0; % total throughput
    avg_delay = zeros(1,user_number);
        
    for u = 1:user_number
        user = user_list(u);
        user_t = user.total_packet_count;
        total_t = total_t + user_t;
        delay_value_list = -1 .* user.packet_arrival_times(user.packet_arrival_times<0);
        %delay_value_list = (nonzeros(user.delay_avg_list));
        avg_delay(1,u) = mean(delay_value_list);
    end
    
    thrpt = total_t * Constants.Packet_Size;
    avg_delay = mean(avg_delay);
end