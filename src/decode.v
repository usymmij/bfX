module decode (
    input clk,
    input [7:0] ix,
    output reg dataCounter,
    data,
    io,
    branch,
    stop,
    mode
);
  assign dataCounter = ~(ix[3] | ix[2] | ix[1]);
  assign data = ~(ix[3] | ix[2]) & ix[1];
  assign io = ~(ix[3] | ix[1]) & ix[2];
  assign branch = ~ix[3] & ix[2] & ix[1];
  assign stop = &ix;
  assign mode = ix[0];
  initial begin
    dataCounter = 0;
    data = 0;
    io = 0;
    branch = 0;
    stop = 0;
    mode = 0;
  end

endmodule

module tb_decode ();

  reg clk;
  reg [7:0] ix;
  wire dataCounter, data, io, branch, stop, mode;

  decode test (
      clk,
      ix,
      dataCounter,
      data,
      io,
      branch,
      stop,
      mode
  );

  always #5 clk = ~clk;

  initial begin
    clk = 1'b0;
    #4 ix = 8'h0;
    #10 ix = 8'h1;
    #10 ix = 8'h2;
    #10 ix = 8'h3;
    #10 ix = 8'h4;
    #10 ix = 8'h5;
    #10 ix = 8'h6;
    #10 ix = 8'h7;
    #10 ix = 8'h8;
  end

endmodule
