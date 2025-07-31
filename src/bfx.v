`include "adder.v"
`include "decode.v"
`include "memory.v"
`include "mux.v"
`include "io.v"

module bfX (
    input clk,
    output [7:0] currIX,
    output [15:0] dcout,
    output [15:0] dtout,
    output [15:0] pcout
);

  reg [15:0] pc;
  assign pcout = pc;

  wire writeEnable;
  reg [15:0] dtaddr;
  wire [15:0] ixaddr;
  wire [7:0] dtWrite;
  wire [7:0] dtFetch;
  wire [7:0] ixFetch;

  assign ixaddr = pc;

  reg [15:0] dc;
  reg [15:0] nextdc;
  reg [ 7:0] dt;

  always @(posedge clk) begin
    pc <= pc + 1;
    dc <= nextdc;
  end

  assign dtaddr = nextdc;

  mem memory (
      clk,
      writeEnable,
      dtaddr,
      ixaddr,
      dc,
      dtWrite,
      dtFetch,
      ixFetch
  );

  always @(*) begin
    dt <= dtFetch;
  end

  wire modifyDC, modifyData, io, branch, stop, mode;

  decode ix_decode (
      clk,
      ixFetch,
      modifyDC,
      modifyData,
      io,
      branch,
      stop,
      mode
  );

  wire [15:0] addsubin;

  mux_4_1_16bit addsubsel (
      .a  (16'h0),
      .b  (dc),
      .c  ({8'h0, dt}),
      .d  (16'h0),
      .sel({modifyData, modifyDC}),
      .o  (addsubin)
  );

  wire [15:0] addsubout;

  addersub_16 addsub (
      addsubin,
      16'h1,
      mode,
      addsubout
  );

  // debug wires
  assign dcout = dc;
  assign dtout = dt;

  assign writeEnable = modifyData | (io & mode);
  assign dtWrite = addsubout;

  reg mDCFlag;
  assign mDCFlag = modifyDC;

  always @(*) begin
    if (mDCFlag) nextdc = addsubout;
    else nextdc = dc;
  end

  wire [7:0] inbyte;

  inputbus inbus (
      io & mode,
      inbyte
  );
  outputbus outbus (
      io & ~mode,
      dtFetch
  );

  assign currIX = {8'h0, ixFetch};

  initial begin
    pc = 16'h0;
    dc = 16'h100;
    dt = 16'h100;
    mDCFlag = 1'b0;
  end

endmodule

module tb_bfx ();

  reg clk;
  wire [7:0] currInstruction;
  wire [15:0] dataPointer;
  wire [15:0] data;
  wire [15:0] pc;

  bfX bfx (
      clk,
      currInstruction,
      dataPointer,
      data,
      pc
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
  end

endmodule
