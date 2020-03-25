/// Cache Coherence Protocol
///  Huaixi Lu (huaixil@princeton.edu)

`include "ccp_define.h"

<%
import pyhplib
from pyhplib import *

CORE_NUMBER = 2
%>

module L15_cmp (
  input wire clk,
  input wire rst,
  // Channel 2 only needs to know where to go 
  input wire [`MSG_WIDTH - 1 : 0] msg2_type,
  input wire [`OWNER_BITS - 1 : 0] cache_owner,
  input wire [`DIR_WIDTH - 1 : 0] share_list,

  output reg [`MSG_WIDTH - 1 : 0]  msg1_type,
  output reg [`DATA_WIDTH - 1 : 0] msg1_data,
  output reg [`TAG_WIDTH - 1 : 0]  msg1_tag,
  output reg [`OWNER_BITS - 1 : 0] msg1_source,

  output reg [`MSG_WIDTH - 1 : 0]  msg3_type,
  output reg [`DATA_WIDTH - 1 : 0] msg3_data,
  output reg [`TAG_WIDTH - 1 : 0]  msg3_tag,
  output reg [`OWNER_BITS - 1 : 0] msg3_source
);

reg [MSG_WIDTH - 1 : 0]  msg2_type_core [CORE_NUMBER - 1 : 0];

reg [MSG_WIDTH - 1 : 0]  msg1_type_core [CORE_NUMBER - 1 : 0];
reg [DATA_WIDTH - 1 : 0] msg1_data_core [CORE_NUMBER - 1 : 0];
reg [TAG_WIDTH - 1 : 0]  msg1_tag_core  [CORE_NUMBER - 1 : 0];

reg [MSG_WIDTH - 1 : 0]  msg3_type_core [CORE_NUMBER - 1 : 0];
reg [DATA_WIDTH - 1 : 0] msg3_data_core [CORE_NUMBER - 1 : 0];
reg [TAG_WIDTH - 1 : 0]  msg3_tag_core  [CORE_NUMBER - 1 : 0];

<%
for i in range(CORE_NUMBER):
  print "  l15 l15_%d (" % (i)
  print "  .clk (clk),"
  print "  .rst (rst),"
  print "  .msg2_type (msg2_type_core[%d])," % (i)
  print "  .core_req (),"
  print "  .core_tag (),"
  print "  .core_data (),"

  print "  .msg1_type (msg1_type_core[%d])," % (i)
  print "  .msg1_data (msg1_data_core[%d])," % (i)
  print "  .msg1_tag  (msg1_tag_core[%d]), " % (i)

  print "  .msg3_type (msg3_type_core[%d])," % (i)
  print "  .msg3_data (msg3_data_core[%d])," % (i)
  print "  .msg3_tag  (msg3_tag_core[%d])  " % (i)
);
%>

// choose core to receive req from L2

always @ * begin
  if (msg2_type == MSG_TYPE_INV_FWD) begin
    <%
      for i in range(CORE_NUMBER):
        print " if (share_list[%d]) msg2_type_core[%d] = MSG_TYPE_INV_FWD;" %(i,i)
    %>
  end
  else begin
    msg2_type_core[cache_owner] = msg2_type;
  end
end

// choose core to send to L2 (msg1)

reg [CORE_NUMBER_WIDTH - 1 : 0] pointer1;
reg [CORE_NUMBER_WIDTH - 1 : 0] pointer1_next;

always @(posedge clk) begin
  if (rst) pointer1 <= 0;
  else
    pointer1 <= pointer1_next;
end

always @ * begin
case (pointer1)
<% 
for i in range(CORE_NUMBER):
  print "   %d\'d%d:" %(CORE_NUMBNER, i)
  print "   begin"
  for j in range(CORE_NUMBER):
    if j == 0:
      print "    if(msg1_type_core[%d] != MSG_TYPE_EMPTY)" %((j+i) % CORE_NUMBER)
    elif j == CORE_NUMBER-1:
      print "     else"
    else:
        print "   else if (msg1_type_core[%d] != MSG_TYPE_EMPTY)" % ((j+i) % CORE_NUMBER)
        print "   begin"
        print "       msg1_type = msg1_type_core[%d];" % ((j+i) % CORE_NUMBER)
        print "       pointer1_next = %d;" % ((j+i+1) % CORE_NUMBER)
        print "       msg1_source = %d;" % ((j+i) % CORE_NUMBER)
        print "       msg1_tag = msg1_tag_core[%d];" % ((j+i) % CORE_NUMBER)
        print "       msg1_data = msg1_data_core[%d];" % ((j+i) % CORE_NUMBER)
        print "   end"
  print "    end"
%>
end

// choose core to send to L2 (msg3)
reg [CORE_NUMBER_WIDTH - 1 : 0] pointer3;
reg [CORE_NUMBER_WIDTH - 1 : 0] pointer3_next;

always @(posedge clk) begin
  if (rst) pointer3 <= 0;
  else
    pointer3 <= pointer3_next;
end

always @ * begin
case (pointer3)
<% 
for i in range(CORE_NUMBER):
  print "   %d\'d%d:" %(CORE_NUMBNER, i)
  print "   begin"
  for j in range(CORE_NUMBER):
    if j == 0:
      print "    if(msg3_type_core[%d] != MSG_TYPE_EMPTY)" %((j+i) % CORE_NUMBER)
    elif j == CORE_NUMBER-1:
      print "     else"
    else:
        print "   else if (msg3_type_core[%d] != MSG_TYPE_EMPTY)" % ((j+i) % CORE_NUMBER)
        print "   begin"
        print "       msg3_type = msg3_type_core[%d];" % ((j+i) % CORE_NUMBER)
        print "       pointer3_next = %d;" % ((j+i+1) % CORE_NUMBER)
        print "       msg3_source = %d;" % ((j+i) % CORE_NUMBER)
        print "       msg3_tag = msg3_tag_core[%d];" % ((j+i) % CORE_NUMBER)
        print "       msg3_data = msg3_data_core[%d];" % ((j+i) % CORE_NUMBER)
        print "   end"
  print "    end"
%>
end

endmodule