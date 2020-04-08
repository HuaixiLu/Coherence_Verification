
CORE_NUMBER = 2

f1 = open('./ccp.v', 'w+')

print >> f1, " module L15_cmp ( "
print >> f1, "  input wire clk, "
print >> f1, "  input wire rst, "
print >> f1, "  // Channel 2 only needs to know where to go "
print >> f1, "  input wire [`MSG_WIDTH - 1 : 0] msg2_type,"
print >> f1, "  input wire [`OWNER_BITS - 1 : 0] cache_owner,"
print >> f1, "  input wire [`DIR_WIDTH - 1 : 0] share_list,"

print >> f1, "  output reg [`MSG_WIDTH - 1 : 0]  msg1_type,"
print >> f1, "  output reg [`DATA_WIDTH - 1 : 0] msg1_data,"
print >> f1, "  output reg [`TAG_WIDTH - 1 : 0]  msg1_tag,"
print >> f1, "  output reg [`OWNER_BITS - 1 : 0] msg1_source,"

print >> f1, "  output reg [`MSG_WIDTH - 1 : 0]  msg3_type,"
print >> f1, "  output reg [`DATA_WIDTH - 1 : 0] msg3_data,"
print >> f1, "  output reg [`TAG_WIDTH - 1 : 0]  msg3_tag,"
print >> f1, "  output reg [`OWNER_BITS - 1 : 0] msg3_source"
print >> f1, ");"

print >> f1, "reg [MSG_WIDTH - 1 : 0]  msg2_type_core [%d - 1 : 0];" % (CORE_NUMBER)

print >> f1, "reg [MSG_WIDTH - 1 : 0]  msg1_type_core [%d - 1 : 0];" % (CORE_NUMBER)
print >> f1, "reg [DATA_WIDTH - 1 : 0] msg1_data_core [%d - 1 : 0];" % (CORE_NUMBER)
print >> f1, "reg [TAG_WIDTH - 1 : 0]  msg1_tag_core  [%d - 1 : 0];" % (CORE_NUMBER)

print >> f1, "reg [MSG_WIDTH - 1 : 0]  msg3_type_core [%d - 1 : 0];" % (CORE_NUMBER)
print >> f1, "reg [DATA_WIDTH - 1 : 0] msg3_data_core [%d - 1 : 0];" % (CORE_NUMBER)
print >> f1, "reg [TAG_WIDTH - 1 : 0]  msg3_tag_core  [%d - 1 : 0];" % (CORE_NUMBER)

for i in range(CORE_NUMBER):
  print >> f1, "  l15 l15_%d (" % (i)
  print >> f1, "  .clk (clk),"
  print >> f1, "  .rst (rst),"
  print >> f1, "  .msg2_type (msg2_type_core[%d])," % (i)
  print >> f1, "  .core_req (),"
  print >> f1, "  .core_tag (),"
  print >> f1, "  .core_data (),"

  print >> f1, "  .msg1_type (msg1_type_core[%d])," % (i)
  print >> f1, "  .msg1_data (msg1_data_core[%d])," % (i)
  print >> f1, "  .msg1_tag  (msg1_tag_core[%d]), " % (i)

  print >> f1, "  .msg3_type (msg3_type_core[%d])," % (i)
  print >> f1, "  .msg3_data (msg3_data_core[%d])," % (i)
  print >> f1, "  .msg3_tag  (msg3_tag_core[%d])  " % (i)
print >> f1, ");"

print >> f1, "// choose core to receive req from L2"

print >> f1, "always @ * begin"
print >> f1, "  if (msg2_type == MSG_TYPE_INV_FWD) begin"
for i in range(CORE_NUMBER):
  print >> f1, "     if (share_list[%d]) msg2_type_core[%d] = MSG_TYPE_INV_FWD;" %(i,i)
print >> f1, "  end"
print >> f1, "  else begin"
print >> f1, "    msg2_type_core[cache_owner] = msg2_type;"
print >> f1, "  end"
print >> f1, "end"

print >> f1, "// choose core to send to L2 (msg1)"
print >> f1, "reg [CORE_NUMBER_WIDTH - 1 : 0] pointer1;"
print >> f1, "reg [CORE_NUMBER_WIDTH - 1 : 0] pointer1_next;"

print >> f1, "always @(posedge clk) begin"
print >> f1, "  if (rst) pointer1 <= 0;"
print >> f1, "  else"
print >> f1, "    pointer1 <= pointer1_next;"
print >> f1, "end"

print >> f1, "always @ * begin"
print >> f1, "case (pointer1)"

for i in range(CORE_NUMBER):
  print >> f1, "   %d\'d%d:" %(CORE_NUMBER, i)
  print >> f1, "   begin"
  for j in range(CORE_NUMBER):
    if j == 0:
      print >> f1, "    if(msg1_type_core[%d] != MSG_TYPE_EMPTY)" %((j+i) % CORE_NUMBER)
    elif j == CORE_NUMBER-1:
      print >> f1, "     else"
    else:
        print >> f1, "   else if (msg1_type_core[%d] != MSG_TYPE_EMPTY)" % ((j+i) % CORE_NUMBER)
        print >> f1, "   begin"
        print >> f1, "       msg1_type = msg1_type_core[%d];" % ((j+i) % CORE_NUMBER)
        print >> f1, "       pointer1_next = %d;" % ((j+i+1) % CORE_NUMBER)
        print >> f1, "       msg1_source = %d;" % ((j+i) % CORE_NUMBER)
        print >> f1, "       msg1_tag = msg1_tag_core[%d];" % ((j+i) % CORE_NUMBER)
        print >> f1, "       msg1_data = msg1_data_core[%d];" % ((j+i) % CORE_NUMBER)
        print >> f1, "   end"
  print >> f1, "    end"
print >> f1, "end"

print >> f1, "// choose core to send to L2 (msg3)"
print >> f1, "reg [CORE_NUMBER_WIDTH - 1 : 0] pointer3;"
print >> f1, "reg [CORE_NUMBER_WIDTH - 1 : 0] pointer3_next;"

print >> f1, "always @(posedge clk) begin"
print >> f1, "  if (rst) pointer3 <= 0;"
print >> f1, "  else"
print >> f1, "    pointer3 <= pointer3_next;"
print >> f1, "end"

print >> f1, "always @ * begin"
print >> f1, "case (pointer3)"
for i in range(CORE_NUMBER):
  print >> f1, "   %d\'d%d:" %(CORE_NUMBER, i)
  print >> f1, "   begin"
  for j in range(CORE_NUMBER):
    if j == 0:
      print >> f1, "    if(msg3_type_core[%d] != MSG_TYPE_EMPTY)" %((j+i) % CORE_NUMBER)
    elif j == CORE_NUMBER-1:
      print >> f1, "     else"
    else:
        print >> f1, "   else if (msg3_type_core[%d] != MSG_TYPE_EMPTY)" % ((j+i) % CORE_NUMBER)
        print >> f1, "   begin"
        print >> f1, "       msg3_type = msg3_type_core[%d];" % ((j+i) % CORE_NUMBER)
        print >> f1, "       pointer3_next = %d;" % ((j+i+1) % CORE_NUMBER)
        print >> f1, "       msg3_source = %d;" % ((j+i) % CORE_NUMBER)
        print >> f1, "       msg3_tag = msg3_tag_core[%d];" % ((j+i) % CORE_NUMBER)
        print >> f1, "       msg3_data = msg3_data_core[%d];" % ((j+i) % CORE_NUMBER)
        print >> f1, "   end"
  print >> f1, "    end"
print >> f1, "end"

print >> f1, "endmodule"
f1.close()