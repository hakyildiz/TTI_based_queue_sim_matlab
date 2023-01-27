function queue_timeslot(user,MU_bit,step)
    
    TTI = Constants.TTI;
    Packet_Size = Constants.Packet_Size;
    
    MU_bit_current = MU_bit + user.rem_bits;
    MU_packet = floor( MU_bit_current / Packet_Size );
    
    arr_times = user.packet_arrival_times;
    rem_index_list = user.waiting_packet_index_list;
    processed_packet_number = MU_packet;
    
    delay_avg = 0;
    delay_predict = 0;
    
    ts = step * TTI; %time-slot_time
    pts = ts - TTI; %pre_time-slot_time
    % find indexes between pts and ts
    % those packets will be delivered according to MU_packet
    index_list = find( arr_times > pts & arr_times <= ts );
    index_list = [ rem_index_list , index_list] ;
    waiting_packet_number = length(index_list);
    
    % if MU_packet < packet-number
    % remaiming packet will be issued at next-time slots
    % FIFO
    if waiting_packet_number > MU_packet
        rem_index_list = index_list(MU_packet+1:end);
        index_list = index_list(1:MU_packet);    
        user.rem_bits = MU_bit_current - (processed_packet_number * Packet_Size);
        user.mu_bit = MU_bit;
    else
        rem_index_list = [];
        processed_packet_number = waiting_packet_number;
        user.mu_bit = abs(processed_packet_number * Packet_Size - user.rem_bits);
        user.rem_bits = 0;
    end
    % decrease operation : to find waiting times
    arr_times(index_list) = arr_times(index_list) - (ts);

    % keep avarage waiting time for each TS
    if ~isempty(index_list)
        delay_avg = -1.*mean(arr_times(index_list));
    end
    
    nts = ts + TTI;
    % prediction for current delay
    arr_times_ts = arr_times;
    arr_times_ts(rem_index_list) = arr_times_ts(rem_index_list) - (nts);
    if ~isempty(index_list) || ~isempty(rem_index_list)
        delay_predict = -1.*mean(arr_times_ts([index_list rem_index_list]));
    end
    
    user.packet_arrival_times = arr_times;
    user.waiting_packet_index_list = rem_index_list;
    user.last_delay = delay_predict;
    user.delay_avg_list(1,step) = delay_avg;
    user.total_packet_count = user.total_packet_count + processed_packet_number;
    user.mu_packet = processed_packet_number;
    % calculate new queue len for the NEXT time slot
    
    next_ts_packet_indexes = find( arr_times > ts & arr_times <= nts );
    next_ts_packet_number = length(next_ts_packet_indexes) + length (rem_index_list);
    user.queue_len = next_ts_packet_number;
    user.queue_len_list(1,step) = next_ts_packet_number;
end