classdef User < matlab.mixin.Copyable
    % user class to keep user attribues
    % such as RB_number, delay values etc...
    properties
        rb_number = 0
        lambda = 0 
        mu_packet = 0
        mu_bit = 0
        queue_len = 0
        rem_bits = 0
        mcs = 0
        packet_size = 0
        total_packet_count = 0
        packet_arrival_times = []
        waiting_packet_index_list = []
        delay_avg_list = []
        last_delay = 0
        queue_len_list = []
    end
end