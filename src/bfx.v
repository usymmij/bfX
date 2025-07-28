`include <memory.v>
`include <decode.v>

module bfX (
    input clk,
    input [7:0] in,
    output [7:0] out
);

  reg [15:0] pc;

  reg memoryActive;
  reg memoryRSel;
  wire [15:0] memoryAddr;
  wire [7:0] memoryWrite;
  wire [7:0] memoryRead;

  assign memoryAddr   = pc;
  assign memoryActive = 1;
  assign memoryRSel   = 1;

  mem memory (
      clk,
      memoryActive,
      memoryRSel,
      memoryAddr,
      memoryWrite,
      memoryRead
  );

  always @(posedge clk) begin
    pc = pc + 1;
  end

  wire dataCounter, data, io, branch, stop, mode;

  decode ix_decode (
      clk,
      memoryRead,
      dataCounter,
      data,
      io,
      branch,
      stop,
      mode
  );

  reg [15:0] dc;

  assign out = {2'h0, dataCounter, data, io, branch, stop, mode};

  initial begin
    pc = 16'h0;
    dc = 16'h256;
  end

endmodule

module tb_bfx_memory ();

  reg clk;
  reg [7:0] in;
  wire [7:0] out;
  bfX bfx (
      clk,
      in,
      out
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
  end

endmodule
