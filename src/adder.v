module addersub_16 (
    input [15:0] a,
    input [15:0] b,
    input sub,
    output [15:0] out
);

  wire [15:0] bsub;

  assign bsub = {16{sub}} ^ b;

  adder_16 adder (
      .a  (a),
      .b  (bsub),
      .cin(sub),
      .o  (out)
  );

endmodule

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

module adder_16 (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output c,
    output [15:0] o
);

  wire [2:0] carry;

  adder_4 adder1 (
      a[3:0],
      b[3:0],
      cin,
      carry[0],
      o[3:0]
  );
  adder_4 adder2 (
      a[7:4],
      b[7:4],
      carry[0],
      carry[1],
      o[7:4]
  );
  adder_4 adder3 (
      a[11:8],
      b[11:8],
      carry[1],
      carry[2],
      o[11:8]
  );
  adder_4 adder4 (
      a[15:12],
      b[15:12],
      carry[2],
      c,
      o[15:12]
  );

endmodule
module tb_adder ();
  reg [15:0] a, b;
  reg cin;
  wire c;
  wire [15:0] o;

  adder_16 f (
      a,
      b,
      cin,
      c,
      o
  );
  initial begin
    a   = 16'h0;
    b   = 16'h0;
    cin = 0;

    #10 a = 16'h2;
    b = 16'h2;
    #10 cin = 1;
    b = 16'h5;
    #10 cin = 0;
    b = 16'h8;
    a = 16'h8;
    #10 b = 16'hc;
    #10 a = 16'hc;
    b = 16'h10;
    #10 a = 16'h10;
    #10 b = 16'h14;
    #10 a = 16'hff00;
    b = 16'h0100;
  end

endmodule

module tb_addersub ();
  reg [15:0] a, b;
  reg sub;
  wire [15:0] o;

  addersub_16 test (
      a,
      b,
      sub,
      o
  );

  initial begin
    a   = 16'h0;
    b   = 16'h0;
    sub = 0;

    #10 a = 16'h2;
    b = 16'h2;
    #10 b = 16'hc;
    #10 b = 16'h8;
    a = 16'h8;
    #10 b = 16'hc;
    #10 a = 16'hc;
    b = 16'h12;
    #10 sub = 1;
    a = 16'h10;
    b = 16'h8;
    #10 b = 16'ha;
    #10 a = 16'h1000;
    b = 16'h100;
  end

endmodule
