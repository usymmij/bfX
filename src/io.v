// the modules in this file represent fake I/O devices

module inputbus (
    input setready,
    output dataready,
    output [7:0] in
);
  reg dataR;
  assign dataready = dataR;

  // the inputqueue register represents a sequence of inputs
  reg [7:0] inputqueue[127:0];
  assign in = inputqueue[0];

  integer i;
  always @(posedge setready) begin

    // shift the inputqueue
    for (i = 0; i < 128; i = i + 1) begin
      inputqueue[i] <= inputqueue[i+1];
    end

    // extra slow to "simulate" real IO
    #25 dataR = 1;
  end

  always @(posedge setready) dataR = 0;

  initial begin
    $readmemh("input.txt", inputqueue);
    dataR = 1;
  end

endmodule

module outputbus (
    input ready,
    input [7:0] out,
    output received
);

  reg processedinput;
  integer file;

  assign received = processedinput;

  always @(posedge ready) begin
    processedinput = 0;
    file = $fopen("output.txt", "a");
    $fdisplayh(file, out);
    $fclose(file);
    // extra slow to "simulate" real IO
    #25 processedinput = 1;
  end

  initial begin
    processedinput = 0;
  end

endmodule

module tb_input ();
  reg r;
  wire dr;
  wire [7:0] i;
  inputbus in (
      r,
      dr,
      i
  );
  always @(posedge dr) begin
    #3 r = ~r;
    #3 r = ~r;
  end

  initial begin
    r = 0;
  end

endmodule

module tb_output ();
  reg r;
  reg [7:0] o;
  wire received;

  outputbus in (
      r,
      o,
      received
  );

  integer i;

  always @(posedge received) begin
    #2 r = 0;
    #15 o = i;
    r = 1;
    i = i + 1;
  end

  initial begin
    r = 0;
    o = 0;
    i = 1;
    #5 r = 1;
  end

endmodule
