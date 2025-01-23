`timescale 1ns / 1ps

module RAM(input clk,input rst,input req,input rw,input logic [5:0] addr,input logic [15:0] Qi,output logic [15:0] Q,
            output logic [1:0] op,output logic [15:0] Qa,output logic [15:0] memory [31:0][31:0]);
            

logic [2:0] r,c;
initial begin
        for (int i = 0; i < 32; i = i + 1) begin
            for (int j = 0; j < 32; j = j + 1) begin
                memory[i][j] = 0;
            end
        end
end

//always_comb
always @(posedge clk)
 begin
    r = addr[2:0];
    c = addr[5:3]; 
end

//always_comb
always @(posedge clk)
 begin
    if(rst) begin
        Qa <= 0;
        op <= 0;
    end
    else begin
        if (rw == 1 && req == 1) begin 
            Qa <= memory[c][r];
            op <= 1; 
        end
        else if (rw == 0 && req == 1) begin
            memory[c][r] <= Qi;
            Q <= Qi;
            op <= 2;
            Qa = 16'b0;
        end
        else begin
            Q <= 16'bx;
            Qa <= 16'bx;
       end
    end
end 
endmodule

`timescale 1ns / 1ps

module RAM_tb;


    reg clk;
    reg rst;
    reg req;
    reg rw;
    reg [5:0] addr;
    reg [15:0] Qi; 
    wire [15:0] Qa,Q;
    wire [1:0] op;
    wire [15:0] mem [31:0][31:0];

    RAM dut (
        .clk(clk),
        .rst(rst),
        .req(req),
        .rw(rw),
        .addr(addr),
        .Qi(Qi),
        .Qa(Qa),
        .op(op),.Q(Q),.memory(mem)
    );


    initial begin
        clk = 1;
        forever #5 clk = ~clk; // 10ns clock period which is 100MHz
    end


    initial begin

        rst = 1;
        req = 0;
        rw = 0;
        addr = 0;
        Qi = 0;
        

        #10 rst = 0;req = 1;


        #10 rw = 0; addr = 6'b000010; Qi = 16'b1010101010101010;
        #10 rw = 0; addr = 6'b100100; Qi = 16'h5A55;
        #10 req = 0;Qi = 16'hx;
        #10 req = 1; rw = 1;addr = 6'b000000;
        #10 req = 1;rw = 1;addr = 6'b000010;
        #10 addr = 6'b100100;

        #20 $finish;
    end

endmodule


