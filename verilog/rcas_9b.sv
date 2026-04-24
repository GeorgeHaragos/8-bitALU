module fac(
  input x,
  input y,
  input cin,
  output z,
  output cout
  );
  assign z = x ^ y ^ cin;
  assign cout = (x&y)|(x&cin)|(y&cin);
endmodule

module rcas_9b(
  input [8:0]X,
  input [8:0]Y,
  input Op,
  output [8:0]Z,
  output Cout
  );
  wire [8:0] y_xor;
  //fir pt iesirile portilor XOR
  wire [9:0]C;
  //lant de carry pe 10 biti
  assign C[0] = Op;
  assign Cout = C[9];
  //am sa generez i, pt for pt instantiere
  genvar i;
  generate
    for(i=0;i<9;i=i+1)begin : gen_adders
      assign y_xor[i] = Y[i] ^ Op;
      fac celula_adder(.x(X[i]),.y(y_xor[i]),.cin(C[i]),.z(Z[i]),.cout(C[i+1]));
    end
  endgenerate
endmodule