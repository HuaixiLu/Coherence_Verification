analyze -sva  \
  l15_ila.v \
  l15.v \
  wrapper.v

elaborate -top wrapper
clock clk
reset rst

assert -name chan1 {(msg1_type_fsm == msg1_type_ila)}