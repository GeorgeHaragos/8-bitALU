module top(input clk,input rst,input [7:0] INBUS, output [7:0] OUTBUS);

wire [20:0] w_stare;
wire [1:0] w_sel;
wire w_cnt7,w_cnt0;
wire [0:-1] w_q;
wire [2:0]w_a;
wire w_m7;
fsm_one_hot_20 uut1(.clk(clk),.rst_n(rst),.SEL(w_sel),.X2(w_q),.X1(w_a),.CNT7(w_cnt7),.CNT0(w_cnt0),.stare(w_stare),.M7(w_m7));
datapath uut2(.clk(clk),.INBUS(INBUS),.stare(w_stare),.OUTBUS(OUTBUS),.sel_out(w_sel),.q_out(w_q),.cnt1_7_out(w_cnt7),.cnt2_0_out(w_cnt0),.a_out(w_a),.M7(w_m7));

endmodule
