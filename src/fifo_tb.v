`timescale 1ns/1ps

module fifo_tb;

parameter WIDTH = 8;
parameter DEPTH = 16;
parameter ADDR_WIDTH = 4;

reg clk, rst, wr_en, rd_en;
reg [WIDTH-1:0] data_in;
wire [WIDTH-1:0] data_out;
wire full, empty;

fifo #(WIDTH, DEPTH, ADDR_WIDTH) DUT (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $display("Starting FIFO Testbench...");

    rst = 1; wr_en = 0; rd_en = 0; data_in = 0;
    #20 rst = 0;

    // WRITE 5 values
    repeat (5) begin
        @(posedge clk);
        wr_en = 1;
        data_in = $random;
    end
    wr_en = 0;

    // READ 5 values
    repeat (5) begin
        @(posedge clk);
        rd_en = 1;
    end
    rd_en = 0;

    // Write until full
    while (!full) begin
        @(posedge clk);
        wr_en = 1;
        data_in = $random;
    end
    wr_en = 0;

    // Read until empty
    while (!empty) begin
        @(posedge clk);
        rd_en = 1;
    end

    rd_en = 0;
    $display("FIFO Test Completed!");
    $finish;
end

endmodule
