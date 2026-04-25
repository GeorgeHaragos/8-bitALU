module t_ff(
  input clk,
  input t,
  input r,
  output reg q,
  output q_barat
  );
  assign q_barat = ~q;
  always @(posedge clk or negedge r)begin
    if(r==0)begin
      q <= 1'b0;
    end
    else if(t==1)begin
      q <= ~q;
    end
  end
endmodule

module up_down_counter(
  input clk,
  input rst,
  input M,
  input en,
  output [2:0]Q
  );
  wire M_bar = ~M;
  wire up_1, down_1;
  wire up_2, down_2;
  wire [2:0]T;
  
  assign T[0]=en;
  
  assign up_1 = M & Q[0];
  assign down_1 = M_bar & ~Q[0];
  assign T[1] = en & (up_1 | down_1);
  
  assign up_2 = up_1 & Q[1];
  assign down_2 = down_1 & ~Q[1];
  assign T[2] = en & (up_2 | down_2);
  
  t_ff FF1(.clk(clk),.r(rst),.t(T[0]),.q(Q[0]),.q_barat());
  t_ff FF2(.clk(clk),.r(rst),.t(T[1]),.q(Q[1]),.q_barat());
  t_ff FF3(.clk(clk),.r(rst),.t(T[2]),.q(Q[2]),.q_barat());
  
endmodule

