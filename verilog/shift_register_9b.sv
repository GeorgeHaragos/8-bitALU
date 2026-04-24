module d_ff(
  input clk,
  input d,
  input r,
  output reg q,//reg pt ca intra in always
  output q_barat
  );
  assign q_barat = ~q;
  
  always @(posedge clk or negedge r)begin
    if(r==0)begin
      q <= 1'b0;
    end
    else begin
      q <= d;
    end
  end
endmodule

module shift_register_8b(
  input [7:0]A,
  input LD_SH,
  input DIR,
  input LSER,
  input RSER,
  input clk,
  input rst,
  output [7:0]Q
  );
  wire [7:0]d_in;
  //firele interne care intra in pinii D
  
  //generez for, pentru ca nu folosesc always
  //nu folosesc always, pentru ca sa folosesc d_ff
  //daca faceam always, nu mai trebuia sa ma folosesc de d_ff
  genvar i;
  generate
    for(i=0;i<8;i=i+1)begin : gen_ff
      if(i==0)begin
        assign d_in[i] = LD_SH ? A[i] : (DIR ? RSER : Q[1]);
      end
      else if(i==7)begin
        assign d_in[i] = LD_SH ? A[i] : (DIR ? Q[6] : LSER);
      end
      else begin
        assign d_in[i] = LD_SH ? A[i] : (DIR ? Q[i-1] : Q[i+1]);
      end
      
      d_ff instantiat(.clk(clk),.d(d_in[i]),.r(rst),.q(Q[i]),.q_barat());
    end
  endgenerate
endmodule

module shift_register_9b(
  input [8:0]A,
  input LD_SH,
  input DIR,
  input LSER,
  input RSER,
  input clk,
  input rst,
  output [8:0]Q
  );
  wire [8:0]d_in;
  genvar i;
  generate
    for(i=0;i<9;i=i+1)begin : gen_ff
      if(i==0)begin
        assign d_in[i] = LD_SH ? A[i] : (DIR ? RSER : Q[1]);
      end
      else if(i==8)begin
        assign d_in[i] = LD_SH ? A[i] : (DIR ? Q[7] : LSER);
      end
      else begin
        assign d_in[i] = LD_SH ? A[i] : (DIR ? Q[i-1] : Q[i+1]);
      end
      
      d_ff instantiat(.clk(clk),.d(d_in[i]),.r(rst),.q(Q[i]),.q_barat());
    end
  endgenerate
endmodule