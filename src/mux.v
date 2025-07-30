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


