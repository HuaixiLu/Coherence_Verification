/// Cache Coherence Protocol
///  Huaixi Lu (huaixil@princeton.edu)

`define CORE_NUMBER 2
`define CORE_NUMBER_WIDTH 1
`define OWNER_BITS  6
`define DATA_WIDTH  64
`define TAG_WIDTH   26
`define MSG_WIDTH   8
`define DIR_WIDTH   2
`define MESI_WIDTH  2

// MESI states

`define MESI_I 2'd0
`define MESI_S 2'd1
`define MESI_E 2'd2
`define MESI_M 2'd3

// Requests from L15 to L2
// Should always make #0 an error
`define MSG_TYPE_EMPTY              8'd0

`define MSG_TYPE_LOAD_REQ           8'd31
`define MSG_TYPE_STORE_REQ          8'd2
`define MSG_TYPE_WB_REQ             8'd12

//Forward requests from L2 to L15
`define MSG_TYPE_LOAD_FWD           8'd16
`define MSG_TYPE_STORE_FWD          8'd17
`define MSG_TYPE_INV_FWD            8'd18

//Memory requests from L2 to DRAM
`define MSG_TYPE_LOAD_MEM           8'd19
`define MSG_TYPE_STORE_MEM          8'd20

//Forward acks from L15 to L2
`define MSG_TYPE_LOAD_FWDACK        8'd21
`define MSG_TYPE_STORE_FWDACK       8'd22
`define MSG_TYPE_INV_FWDACK         8'd23

//Memory acks from memory to L2
`define MSG_TYPE_LOAD_MEM_ACK       8'd24
`define MSG_TYPE_STORE_MEM_ACK      8'd25

//Acks from L2 to L15
`define MSG_TYPE_DATA_ACK           8'd29
