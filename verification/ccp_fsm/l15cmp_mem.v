/// Cache Coherence Protocol
/// Huaixi Lu (huaixil@princeton.edu)

`include "ccp_define.h" 

module L15cmp_mem ( 
  input wire clk, 
  input wire rst, 
  // Channel 2 only needs to know where to go 
  input wire [`MSG_WIDTH - 1 : 0] msg2_type,
  input wire [`DATA_WIDTH - 1 : 0] msg2_data,
  input wire [`TAG_WIDTH - 1 : 0] msg2_tag,

  input wire [`MESI_WIDTH - 1 : 0] mesi_send,
 
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

reg [`MSG_WIDTH - 1 : 0]   msg2_type_core [1 : 0];
reg [`DATA_WIDTH - 1 : 0]  msg2_data_core [1 : 0];
reg [`TAG_WIDTH - 1 : 0]   msg2_tag_core [1 : 0];
reg [`MESI_WIDTH - 1 : 0]  mesi_send_core [1 : 0];

reg [`DATA_WIDTH - 1 : 0]  mem_data [`TAG_ARRAY - 1 : 0];
reg [`MSG_WIDTH - 1 : 0]   msg3_type_mem;
reg [`DATA_WIDTH - 1 : 0]  msg3_data_mem;
reg [`TAG_WIDTH - 1 : 0]   msg3_tag_mem;

wire [`MSG_WIDTH - 1 : 0]  msg1_type_core [1 : 0];
wire [`DATA_WIDTH - 1 : 0] msg1_data_core [1 : 0];
wire [`TAG_WIDTH - 1 : 0]  msg1_tag_core  [1 : 0];
wire [`MSG_WIDTH - 1 : 0]  msg3_type_core [1 : 0];
wire [`DATA_WIDTH - 1 : 0] msg3_data_core [1 : 0];
wire [`TAG_WIDTH - 1 : 0]  msg3_tag_core  [1 : 0];
 
l15 l15_0 (
  .clk (clk),
  .rst (rst),
  .msg2_type (msg2_type_core[0]),
  .msg2_data (msg2_data_core[0]),
  .msg2_tag  (msg2_tag_core[0]),
  .mesi_send (mesi_send_core[0]),
  .core_req (),
  .core_tag (),
  .core_data (),
  .msg1_type (msg1_type_core[0]),
  .msg1_data (msg1_data_core[0]),
  .msg1_tag  (msg1_tag_core[0]), 
  .msg3_type (msg3_type_core[0]),
  .msg3_data (msg3_data_core[0]),
  .msg3_tag  (msg3_tag_core[0])  
);
l15 l15_1 (
  .clk (clk),
  .rst (rst),
  .msg2_type (msg2_type_core[1]),
  .msg2_data (msg2_data_core[1]),
  .msg2_tag  (msg2_tag_core[1]),
  .mesi_send (mesi_send_core[1]),
  .core_req (),
  .core_tag (),
  .core_data (),
  .msg1_type (msg1_type_core[1]),
  .msg1_data (msg1_data_core[1]),
  .msg1_tag  (msg1_tag_core[1]), 
  .msg3_type (msg3_type_core[1]),
  .msg3_data (msg3_data_core[1]),
  .msg3_tag  (msg3_tag_core[1])  
);

// choose core to receive req from L2

reg [`MSG_WIDTH - 1 : 0]  msg2_type_pre;
reg [`OWNER_BITS - 1 : 0] cache_owner_pre;

always @(posedge clk) begin
  if (rst) begin
    msg2_type_pre <= 0;
    cache_owner_pre <= 0;
  end
  else begin
    msg2_type_pre <= msg2_type;
    cache_owner_pre <= cache_owner;
  end
end

always @ * begin
  msg2_type_core[0] = `MSG_TYPE_EMPTY; 
  msg2_type_core[1] = `MSG_TYPE_EMPTY; 
  if (msg2_type == `MSG_TYPE_INV_FWD) begin
     if (share_list[0]) msg2_type_core[0] = `MSG_TYPE_INV_FWD;
     if (share_list[1]) msg2_type_core[1] = `MSG_TYPE_INV_FWD;
  end
  else if (msg2_type == `MSG_TYPE_DATA_ACK && (msg2_type_pre != msg2_type || cache_owner_pre != cache_owner)) begin
      msg2_type_core[0] = `MSG_TYPE_NODATA_ACK; 
      msg2_type_core[1] = `MSG_TYPE_NODATA_ACK; 
      msg2_type_core[cache_owner] = `MSG_TYPE_DATA_ACK; 
      msg2_data_core[cache_owner] = msg2_data;
      msg2_tag_core[cache_owner] = msg2_tag;
      mesi_send_core[cache_owner] = mesi_send;
  end
  else if (!(msg2_type == `MSG_TYPE_STORE_MEM | msg2_type == `MSG_TYPE_LOAD_MEM | msg2_type == `MSG_TYPE_DATA_ACK)) begin
    msg2_type_core[cache_owner] = msg2_type;
    msg2_data_core[cache_owner] = msg2_data;
    msg2_tag_core[cache_owner] = msg2_tag;
    mesi_send_core[cache_owner] = mesi_send;
  end
end

always @(posedge clk) begin
  if (rst) begin
    mem_data[0] <= 0;
    mem_data[1] <= 0;
    mem_data[2] <= 0;
    mem_data[3] <= 0;
    mem_data[4] <= 0;
    mem_data[5] <= 0;
    mem_data[6] <= 0;
    mem_data[7] <= 0;
    msg3_type_mem <= `MSG_TYPE_EMPTY; 
  end
  else if (msg2_type == `MSG_TYPE_LOAD_MEM) begin
    msg3_type_mem <= `MSG_TYPE_LOAD_MEM_ACK;
    msg3_data_mem <= mem_data[msg2_tag];
    msg3_tag_mem <= msg2_tag;
    end
  else if (msg2_type == `MSG_TYPE_STORE_MEM) begin
  mem_data[msg2_tag] <= msg2_data;
 msg3_type_mem <= `MSG_TYPE_STORE_MEM_ACK;
    end
  else
    msg3_type_mem <= `MSG_TYPE_EMPTY;
end

// choose core to send to L2 (msg1)
reg [1 - 1 : 0] pointer1;
reg [1 - 1 : 0] pointer1_next;
always @(posedge clk) begin
  if (rst) pointer1 <= 0;
  else
    pointer1 <= pointer1_next;
end

always @ * begin
case (pointer1)
   1'd0:    begin
    if(msg1_type_core[0] != `MSG_TYPE_EMPTY) begin
      msg1_type = msg1_type_core[0];
      pointer1_next = 1;
      msg1_source = 0;
      msg1_tag = msg1_tag_core[0];
      msg1_data = msg1_data_core[0];
      end
    else begin
      msg1_type = msg1_type_core[1];
      pointer1_next = 0;
      msg1_source = 1;
      msg1_tag = msg1_tag_core[1];
      msg1_data = msg1_data_core[1];
      end
    end
   1'd1:    begin
    if(msg1_type_core[1] != `MSG_TYPE_EMPTY) begin
      msg1_type = msg1_type_core[1];
      pointer1_next = 0;
      msg1_source = 1;
      msg1_tag = msg1_tag_core[1];
      msg1_data = msg1_data_core[1];
      end
    else begin
      msg1_type = msg1_type_core[0];
      pointer1_next = 1;
      msg1_source = 0;
      msg1_tag = msg1_tag_core[0];
      msg1_data = msg1_data_core[0];
      end
    end
endcase
end
 
// choose core to send to L2 (msg3)
reg [1 - 1 : 0] pointer3;
reg [1 - 1 : 0] pointer3_next;
always @(posedge clk) begin
  if (rst) pointer3 <= 0;
  else
    pointer3 <= pointer3_next;
end

always @ * begin
if (msg3_type_mem != `MSG_TYPE_EMPTY) begin
  msg3_type = msg3_type_mem;
  msg3_data = msg3_data_mem;
  msg3_tag  = msg3_tag_mem;
end
else
case (pointer3)
   1'd0:   begin
    if(msg3_type_core[0] != `MSG_TYPE_EMPTY) begin
      msg3_type = msg3_type_core[0];
      pointer3_next = 1;
      msg3_source = 0;
      msg3_tag = msg3_tag_core[0];
      msg3_data = msg3_data_core[0];
      end
    else begin
      msg3_type = msg3_type_core[1];
      pointer3_next = 0;
      msg3_source = 1;
      msg3_tag = msg3_tag_core[1];
      msg3_data = msg3_data_core[1];
      end
    end
   1'd1:   begin
    if(msg3_type_core[1] != `MSG_TYPE_EMPTY) begin
      msg3_type = msg3_type_core[1];
      pointer3_next = 0;
      msg3_source = 1;
      msg3_tag = msg3_tag_core[1];
      msg3_data = msg3_data_core[1];
      end
    else begin
      msg3_type = msg3_type_core[0];
      pointer3_next = 1;
      msg3_source = 0;
      msg3_tag = msg3_tag_core[0];
      msg3_data = msg3_data_core[0];
      end
    end
endcase
end
endmodule
