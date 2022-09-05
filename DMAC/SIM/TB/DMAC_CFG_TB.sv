module DMAC_CFG_TB ();

    reg                     clk;
    reg                     rst_n;

    reg                     rden;
    wire    [31:0]          rdata;
    reg                     wren;
    reg     [31:0]          wdata;

    // clock generation
    initial begin
        clk                     = 1'b0;

        forever #10 clk         = !clk;
    end

    // reset generation
    initial begin
        rst_n                   = 1'b0;     // active at time 0

        repeat (3) @(posedge clk);          // after 3 cycles,
        rst_n                   = 1'b1;     // release the reset
    end

    // enable waveform dump
    initial begin
        $dumpvars(0, u_DUT);
        $dumpfile("dump.vcd");
    end

    // test stimulus
    // clk          : __--__--__--__--__--__--__
    // rst_n        : __------------------------
    // wren         : ___________----___________
    // wdata        :           | D |
    // rden         : _______________----_______
    // rdata        : __________________| D |
    initial begin
        wren                    = 1'b0;
        rden                    = 1'b0;
        wdata                   = 32'd0;

        @(posedge rst_n);                   // wait for a release of the reset
        repeat (10) @(posedge clk);         // wait another 10 cycles

	#1
        // drive write signals
        wren                    = 1'b1;
        wdata                   = 32'h0123_4567;
        @(posedge clk);

	#1
        wren                    = 1'b0;
        rden                    = 1'b1;
        @(posedge clk);

	#1
        rden                    = 1'b0;

        if (rdata!== 32'h0123_4567) begin   // use !== to compare 4-state logic
            $display("*****************************************************");
            $display("********** Mismatch between write and read **********");
            $display("*****************************************************");
        end
        else begin
            $display("*****************************************************");
            $display("**********  Match between write and read   **********");
            $display("*****************************************************");
        end

        @(posedge clk);
        $finish;
    end


    DMAC_CFG  u_DUT (
        .clk                    (clk),
        .rst_n                  (rst_n),

        .wren_i                 (wren),
        .rden_i                 (rden),

        .wdata_i                (wdata),
        .rdata_o                (rdata)
    );
endmodule
