CORE_NUMBER = 4
CORE_NUMBER_WIDTH = 2
MEM_SIZE = 32

f1 = open('./verification/ccp_eq_check.tcl', 'w+')

f1.write("analyze -sva")
f1.write(" l2_ila.v")
f1.write(" l2.v")
f1.write(" l15.v")
f1.write(" l15cmp_mem.v")
f1.write(" ccp_ila.v")
f1.write(" ccp_fsm.v")
f1.write(" ccp_eq_wrapper.v")

f1.write("\nelaborate -top ccp_eq_wrapper \n")
f1.write("clock clk \n")
f1.write("reset rst \n")
f1.write("reset -expression {rst} {:global_formal_reset} -non_resettable_regs {0} \n\n")

f1.write("assume -name same_input_core_req {")
for i in range (CORE_NUMBER):
    if i == CORE_NUMBER - 1 :
        f1.write("(ccp_fsm.pcache_mem.l15_%d.core_req == ccp_ila.pcache_mem.l15_%d.core_req)}\n" %(i,i))
    else:
        f1.write("(ccp_fsm.pcache_mem.l15_%d.core_req == ccp_ila.pcache_mem.l15_%d.core_req) && " %(i,i))

f1.write("assume -name same_input_core_data {")
for i in range (CORE_NUMBER):
    if i == CORE_NUMBER - 1 :
        f1.write("(ccp_fsm.pcache_mem.l15_%d.core_data == ccp_ila.pcache_mem.l15_%d.core_data)}\n" %(i,i))
    else:
        f1.write("(ccp_fsm.pcache_mem.l15_%d.core_data == ccp_ila.pcache_mem.l15_%d.core_data) && " %(i,i))

f1.write("assume -name same_input_core_tag {")
for i in range (CORE_NUMBER):
    if i == CORE_NUMBER - 1 :
        f1.write("(ccp_fsm.pcache_mem.l15_%d.core_tag == ccp_ila.pcache_mem.l15_%d.core_tag)}\n" %(i,i))
    else:
        f1.write("(ccp_fsm.pcache_mem.l15_%d.core_tag == ccp_ila.pcache_mem.l15_%d.core_tag) && " %(i,i))

f1.write("assert -name same_msg {ccp_fsm.msg1_type == ccp_ila.msg1_type}\n")
