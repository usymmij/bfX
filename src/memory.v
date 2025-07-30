/*
second channel is read only (for instruction fetching)
*/
module mem (
    input clk,
    input writeEnable,
    input [15:0] addr1,
    input [15:0] addr2,
    input [7:0] writeData,
    output reg [7:0] out1,
    output reg [7:0] out2
);
  reg [7:0] mem_bank[511:0];

  integer i;
  initial begin
    $readmemh("code.txt", mem_bank, 0, 256);
    for (i = 256; i < 512; i = i + 1) mem_bank[i] = 8'h0;
  end

  always @(posedge clk) begin
    out1 = mem_bank[addr1];
    out2 = mem_bank[addr2];
  end

  always @(negedge clk) if (writeEnable) mem_bank[addr1] = writeData;

endmodule

module tb_mem ();
  reg clk;
  reg wsel;
  reg [15:0] addr1;
  reg [15:0] addr2;
  reg [7:0] in;
  wire [7:0] out1;
  wire [7:0] out2;

  mem mem_dut (
      .clk(clk),
      .writeEnable(wsel),
      .addr1(addr1),
      .addr2(addr2),
      .writeData(in),
      .out1(out1),
      .out2(out2)
  );

  always #5 clk = ~clk;

  initial begin
    clk <= 0;
    wsel <= 0;
    addr1 <= 16'h0;
    addr2 <= 16'h1;
    in <= 8'h0;

    #10 addr1 = 15'h2;
    addr2 = 15'h3;
    #10 addr1 = 15'h4;
    addr2 = 15'h5;
    #10 addr1 = 15'h6;
    addr2 = 15'h7;
    #10 addr1 = 15'h8;
    addr2 = 15'h9;
    #10 addr1 = 15'ha;
    addr2 = 15'hb;
    #10 wsel = 1;
    in = 8'hff;
    addr1 = 15'hc;
    addr2 = 15'h2;
    #10 wsel = 1;
    addr1 = 15'hd;
    addr2 = 15'hc;

  end

endmodule

