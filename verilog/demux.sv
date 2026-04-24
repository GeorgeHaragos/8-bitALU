module demux1_2(
  input in,
  input sel,
  output X,
  output Y
  );
  assign X = in & ~sel;
  assign Y = in & sel;
endmodule

module demux(
  input [8:0]A,
  input sel,
  output [8:0]X,
  output [8:0]Y
  );
  demux1_2 demultiplexor0 (.in(A[0]),.sel(sel),.X(X[0]),.Y(Y[0]));
  demux1_2 demultiplexor1 (.in(A[1]),.sel(sel),.X(X[1]),.Y(Y[1]));
  demux1_2 demultiplexor2 (.in(A[2]),.sel(sel),.X(X[2]),.Y(Y[2]));
  demux1_2 demultiplexor3 (.in(A[3]),.sel(sel),.X(X[3]),.Y(Y[3]));
  demux1_2 demultiplexor4 (.in(A[4]),.sel(sel),.X(X[4]),.Y(Y[4]));
  demux1_2 demultiplexor5 (.in(A[5]),.sel(sel),.X(X[5]),.Y(Y[5]));
  demux1_2 demultiplexor6 (.in(A[6]),.sel(sel),.X(X[6]),.Y(Y[6]));
  demux1_2 demultiplexor7 (.in(A[7]),.sel(sel),.X(X[7]),.Y(Y[7]));
  demux1_2 demultiplexor8 (.in(A[8]),.sel(sel),.X(X[8]),.Y(Y[8]));
endmodule