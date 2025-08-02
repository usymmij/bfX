module mux_2_1_16bit (
    input [15:0] a,
    input [15:0] b,
    input sel,
    output reg [15:0] o
);

  always @(*) begin
    case (sel)
      1'h0: o = a;
      1'h1: o = b;
    endcase
  end

endmodule

module mux_4_1_16bit (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [1:0] sel,
    output reg [15:0] o
);

  always @(*) begin
    case (sel)
      2'h0: o = a;
      2'h1: o = b;
      2'h2: o = c;
      2'h3: o = d;
    endcase
  end

endmodule

module mux_2_1_8bit (
    input [7:0] a,
    input [7:0] b,
    input sel,
    output reg [7:0] o
);

  always @(*) begin
    case (sel)
      1'h0: o = a;
      1'h1: o = b;
    endcase
  end

endmodule


