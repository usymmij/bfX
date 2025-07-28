module full_adder (
    input  a,
    b,
    cin,
    output c,
    o
);
  wire i = a ^ b;
  assign o = cin ^ i;
  assign c = cin & i | a & b;
endmodule

module adder_4 (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output c,
    output [3:0] o
);

  wire [2:0] carry;

  full_adder adder1 (
      a[0],
      b[0],
      cin,
      carry[0],
      o[0]
  );
  full_adder adder2 (
      a[1],
      b[1],
      carry[0],
      carry[1],
      o[1]
  );
  full_adder adder3 (
      a[2],
      b[2],
      carry[1],
      carry[2],
      o[2]
  );
  full_adder adder4 (
      a[3],
      b[3],
      carry[2],
      c,
      o[3]
  );

endmodule

module accumulator (
    input clk,
    input [15:0] val,
    input sub,
    output [15:0] out
);
  reg [15:0] rx;
  assign out = val;

endmodule

module tb_adder ();
  reg [3:0] a, b;
  reg cin;
  wire c;
  wire [3:0] o;

  adder_4 f (
      a,
      b,
      cin,
      c,
      o
  );

  initial begin
    a   = 4'h0;
    b   = 4'h0;
    cin = 0;

    #10 a = 4'h1;
    #10 cin = 1;
    #10 cin = 0;
    b = 4'h2;
    #10 b = 4'h3;
    #10 a = 4'h2;
    #10 a = 4'h4;
    b = 4'h2;
    #10 a = 4'h7;
    b = 4'h0;
    #10 a = 4'h0;
    b = 4'h8;
  end


endmodule
