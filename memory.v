module mem (
    input clk,
    input activeSel,
    input readSel,
    input reg [15:0] addr,
    input reg [7:0] data,
    output reg [7:0] out
);
    reg [7:0] mem_bank [511:0];

    initial begin 
        $readmemh("code.txt",mem_bank);
    end

    always @ (posedge clk) begin
        if (activeSel) begin
            if (readSel) 
                out = mem_bank[addr];
            else 
                mem_bank[addr] = data;
        end
    end

endmodule

// fetching from memory
/*
module ixFetch(
    input clk,
    input reg [7:0] programCounter,
    output [7:0] instruction
);

    mem memory (clk, 0'b1, 0'b1, programCounter, 8'h0, instruction);

endmodule
*/

module tb_mem ();
    reg clk;
    reg aSel, rSel;
    reg [15:0] addr;
    reg [7:0] in;
    wire [7:0] out;

    mem test (clk, aSel, rSel, addr, in, out);

    always #5 clk = ~clk;

    initial begin
        clk <= 0;
    	in <= 8'h0;
        aSel <= 0;
        rSel <= 0;
        #4
        in <= 8'h1;
        #10
        in <= 8'h2;
        aSel <= 1;
        addr <= 16'h12;
        #10
        rSel <= 1;
        in <= 8'h10;
        addr <= 16'h13;
        #10
        addr <= 16'h12;

    end

endmodule

/*
module tb_ixFetch ();
    reg clk;
    reg [7:0] pc;
    wire [7:0] ix;

    ixFetch test (clk, pc, ix);

    always #5 clk = ~clk;
    initial begin 
        clk <= 0;
        #4
        pc <= 0;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
        #9 
        pc <= pc + 1;
    end

endmodule
*/
