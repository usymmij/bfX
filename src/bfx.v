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
    output [15:0] pcout,
    output [7:0] nr,
    output [7:0] debug
);

  reg [15:0] lastpc;
  reg [15:0] pc;
  reg [7:0] nestreg;
  reg [7:0] nextnest;
  wire nrZero;
  wire nrOne;
  assign nrZero  = ~(|nestreg);
  assign nrOne   = &nestreg;
  assign pcout   = pc;
  assign nr[7:0] = nextnest;

  reg branchfw;
  reg branchbw;

  wire writeEnable;
  reg [15:0] dtaddr;
  reg [15:0] ixaddr;
  wire [7:0] dtWrite;
  wire [7:0] dtFetch;
  wire [7:0] ixFetch;

  reg [15:0] dc;
  reg [15:0] nextdc;
  reg [7:0] dt;

  always @(posedge clk) begin
    lastpc <= pc;
    if (branchbw & nrZero) pc <= lastpc - 2;
    else begin
      if (branchfw & nrOne) pc <= lastpc + 2;
      else begin
        if (nestreg[7]) pc <= pc - 1;
        else pc <= pc + 1;
      end
    end
    dc <= nextdc;
    nestreg <= nextnest;
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
  wire dtZero;
  assign dtZero = ~(|dtFetch);

  wire modifyDC_d, modifyData_d, io_d;
  wire modifyDC, modifyData, io, branch, stop, mode;

  decode ix_decode (
      clk,
      ixFetch,
      modifyDC_d,
      modifyData_d,
      io_d,
      branch,
      stop,
      mode
  );

  assign modifyDC   = modifyDC_d & nrZero;
  assign modifyData = modifyData_d & nrZero;
  assign io         = io_d & nrZero;

  assign branchfw   = branch & ~mode & (~nrZero | dtZero);
  assign branchbw   = branch & mode & (~nrZero | ~dtZero);

  wire [15:0] addsubin;

  mux_4_1_16bit addsubsel (
      .a  (16'h0),
      .b  (dc),
      .c  ({8'h0, dt}),
      .d  ({8'h0, nestreg}),
      .sel({modifyData, modifyDC} | {2{branchfw | branchbw}}),
      .o  (addsubin)
  );

  wire [15:0] addsubout;

  wire zero;
  addersub_16 addsub (
      addsubin,
      16'h1,
      mode,
      addsubout,
      zero
  );

  // status wires
  assign dcout = dc;
  assign dtout = dt;

  assign writeEnable = modifyData | (io & mode);

  reg mDCFlag;
  assign mDCFlag = modifyDC;

  always @(*) begin
    if (mDCFlag) nextdc = addsubout;
    else nextdc = dc;

    if (branchfw | branchbw) nextnest <= addsubout;
    else nextnest <= nestreg;

    if (branchbw & nrZero) ixaddr = lastpc - 1;
    else begin
      if (branchfw & nrOne) ixaddr = lastpc + 1;
      else ixaddr = pc;
    end
  end

  wire [7:0] inbyte;

  assign debug = io & ~mode;
  mux_2_1_8bit writemux (
      addsubout[7:0],
      inbyte,
      io & mode,
      dtWrite
  );

  inputbus inbus (
      io & mode,
      inbyte
  );
  outputbus outbus (
      io & ~mode & nrZero,
      dtFetch
  );

  assign currIX = {8'h0, ixFetch};

  initial begin
    lastpc = 16'h0;
    pc = 16'h0;
    nextdc = 0;
    dc = 16'h100;
    dt = 16'h100;
    mDCFlag = 1'b0;
    nestreg = 8'h0;
    nextnest = 8'h0;
    branchfw = 0;
    branchbw = 0;
  end

endmodule

module tb_bfx ();

  reg clk;
  wire [7:0] currInstruction;
  wire [15:0] dataPointer;
  wire [15:0] data;
  wire [15:0] pc;
  wire [7:0] nr;
  wire [7:0] debug;

  bfX bfx (
      clk,
      currInstruction,
      dataPointer,
      data,
      pc,
      nr,
      debug
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
  end

endmodule
