// Copyright (c) 2021 Sungkyunkwan University
//
// Authors:
// - Jungrae Kim <dale40@skku.edu>

module DMAC_CFG
(
    input   wire                clk,
    input   wire                rst_n,  // _n means active low

    input   wire                wren_i, // write enable
    input   wire                rden_i, // read enable

    input   wire    [31:0]      wdata_i,
    output  reg     [31:0]      rdata_o
);

// Configuration register to read/write
reg [31:0]                        cfg_reg;

always @(posedge clk) begin
	if (!rst_n) begin
		cfg_reg					<= 32'd0;
	end
	else if (wren_i) begin
		cfg_reg					<= wdata_i;
	end

	if (rden_i) begin
		rdata_o					<= cfg_reg;
	end
	else begin
		rdata_o					<= 32'd0;
	end
end

endmodule
