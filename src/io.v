// the modules in this file represent fake I/O devices

module inputbus (
    input setready,
    output [7:0] in
);

  // the inputqueue register represents a sequence of inputs
  reg [7:0] inputqueue[127:0];
  assign in = inputqueue[0];

  integer i;
  always @(posedge setready) begin

    // shift the inputqueue
    for (i = 0; i < 128; i = i + 1) begin
      inputqueue[i] <= inputqueue[i+1];
    end

  end

  initial begin
    $readmemh("input.txt", inputqueue);
  end

endmodule

module outputbus (
    input ready,
    input [7:0] out
);

  integer file;

  always @(posedge ready) begin
    file = $fopen("output.txt", "a");
    $fdisplayh(file, out);
    $fclose(file);
    // extra slow to "simulate" real IO
  end

  initial begin
    file = $fopen("output.txt", "w");
    $fclose(file);
  end
endmodule

module tb_input ();
  reg r;
  wire [7:0] i;
  inputbus in (
      r,
      i
  );
  always #5 r = ~r;

  initial begin
    r = 0;
  end

endmodule

module tb_output ();
  reg r;
  reg [7:0] o;

  outputbus in (
      r,
      o
  );

  always #5 r = ~r;

  initial begin
    r = 0;
    o = 0;
    #15 o = 1;
    #10 o = 2;
    #10 o = 3;
    #10 o = 4;
    #10 o = 5;
    #10 o = 6;
    #10 o = 7;
  end

endmodule
