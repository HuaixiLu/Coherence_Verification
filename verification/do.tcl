analyze -sva  \
  l2.v \
  l15.v \
  l15cmp_mem.v \
  ccp.v

elaborate -top ccp
clock clk
reset rst
