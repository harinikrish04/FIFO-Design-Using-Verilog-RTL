

#  **src/fifo.v**


module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4
)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [ADDR_WIDTH:0] w_ptr;
reg [ADDR_WIDTH:0] r_ptr;

assign empty = (w_ptr == r_ptr);
assign full  = ((w_ptr + 1'b1) == r_ptr);

always @(posedge clk) begin
    if (rst) begin
        w_ptr <= 0;
    end else if (wr_en && !full) begin
        mem[w_ptr[ADDR_WIDTH-1:0]] <= data_in;
        w_ptr <= w_ptr + 1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        r_ptr <= 0;
        data_out <= 0;
    end else if (rd_en && !empty) begin
        data_out <= mem[r_ptr[ADDR_WIDTH-1:0]];
        r_ptr <= r_ptr + 1;
    end
end

endmodule
