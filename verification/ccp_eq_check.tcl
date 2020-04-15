analyze -sva ./ccp_ila/l2_ila.v ./ccp_fsm/l2.v ./ccp_fsm/l15.v ./ccp_fsm/l15cmp_mem.v ./ccp_ila/ccp_ila.v ./ccp_fsm/ccp_fsm.v ccp_eq_wrapper.v
elaborate -top ccp_eq_wrapper 
clock clk 
reset rst 
reset -expression {rst} {:global_formal_reset} -non_resettable_regs {0} 

assume -name same_input_core_req {(ccp_fsm.pcache_mem.l15_0.core_req == ccp_ila.pcache_mem.l15_0.core_req) && (ccp_fsm.pcache_mem.l15_1.core_req == ccp_ila.pcache_mem.l15_1.core_req) && (ccp_fsm.pcache_mem.l15_2.core_req == ccp_ila.pcache_mem.l15_2.core_req) && (ccp_fsm.pcache_mem.l15_3.core_req == ccp_ila.pcache_mem.l15_3.core_req)}
assume -name same_input_core_data {(ccp_fsm.pcache_mem.l15_0.core_data == ccp_ila.pcache_mem.l15_0.core_data) && (ccp_fsm.pcache_mem.l15_1.core_data == ccp_ila.pcache_mem.l15_1.core_data) && (ccp_fsm.pcache_mem.l15_2.core_data == ccp_ila.pcache_mem.l15_2.core_data) && (ccp_fsm.pcache_mem.l15_3.core_data == ccp_ila.pcache_mem.l15_3.core_data)}
assume -name same_input_core_tag {(ccp_fsm.pcache_mem.l15_0.core_tag == ccp_ila.pcache_mem.l15_0.core_tag) && (ccp_fsm.pcache_mem.l15_1.core_tag == ccp_ila.pcache_mem.l15_1.core_tag) && (ccp_fsm.pcache_mem.l15_2.core_tag == ccp_ila.pcache_mem.l15_2.core_tag) && (ccp_fsm.pcache_mem.l15_3.core_tag == ccp_ila.pcache_mem.l15_3.core_tag)}
assert -name same_msg {ccp_fsm.msg1_type == ccp_ila.msg1_type}
