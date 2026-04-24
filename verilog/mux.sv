module mux2_1(
  input A,
  input B,
  input sel,
  output X
  );
  assign X = (sel == 1) ? A : B;
endmodule

module mux(
  input [8:0]A,
  input [8:0]B,
  input sel,
  output [8:0]X
  );
  mux2_1 multiplexor0 (.A(A[0]),.B(B[0]),.sel(sel),.X(X[0]));
  mux2_1 multiplexor1 (.A(A[1]),.B(B[1]),.sel(sel),.X(X[1]));
  mux2_1 multiplexor2 (.A(A[2]),.B(B[2]),.sel(sel),.X(X[2]));
  mux2_1 multiplexor3 (.A(A[3]),.B(B[3]),.sel(sel),.X(X[3]));
  mux2_1 multiplexor4 (.A(A[4]),.B(B[4]),.sel(sel),.X(X[4]));
  mux2_1 multiplexor5 (.A(A[5]),.B(B[5]),.sel(sel),.X(X[5]));
  mux2_1 multiplexor6 (.A(A[6]),.B(B[6]),.sel(sel),.X(X[6]));
  mux2_1 multiplexor7 (.A(A[7]),.B(B[7]),.sel(sel),.X(X[7]));
  mux2_1 multiplexor8 (.A(A[8]),.B(B[8]),.sel(sel),.X(X[8]));
endmodule