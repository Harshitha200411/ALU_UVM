module alu_assertion (
    input bit clk,
    input logic rst,
    input logic err,
    input logic mode,
    input logic [3:0] cmd,
    input logic [1:0] inp_valid
);

     assert property (
        @(posedge clk) disable iff (rst)
        (inp_valid == 2'b01 &&
         mode &&
         (cmd inside {4'd0,4'd1,4'd2,4'd3,4'd8,4'd9,4'd10}))
        ##1
        (!(inp_valid inside {2'b10,2'b11}))[*16]
        |=> err
    );


    assert property (
        @(posedge clk) disable iff (rst)
        (inp_valid == 2'b10 &&
         mode &&
         (cmd inside {4'd0,4'd1,4'd2,4'd3,4'd8,4'd9,4'd10}))
        ##1
        (!(inp_valid inside {2'b01,2'b11}))[*16]
        |=> err
    );


    assert property (
        @(posedge clk) disable iff (rst)
        (inp_valid == 2'b01 &&
         !mode &&
         (cmd inside {4'd0,4'd1,4'd2,4'd3,4'd4,4'd5,4'd12,4'd13}))
        ##1
        (!(inp_valid inside {2'b10,2'b11}))[*16]
        |=> err
    );


    assert property (
        @(posedge clk) disable iff (rst)
        (inp_valid == 2'b10 &&
         !mode &&
         (cmd inside {4'd0,4'd1,4'd2,4'd3,4'd4,4'd5,4'd12,4'd13}))
        ##1
        (!(inp_valid inside {2'b01,2'b11}))[*16]
        |=> err
    );

    assert property (
    @(posedge clk) disable iff (rst)
    (!mode && (cmd inside {14,15}))
    |=> err
    );
    
    assert property (
    @(posedge clk) disable iff (rst)
    (mode && (cmd inside {11,12,13,14,15}))
    |=> err
    );
    
    assert property (
    @(posedge clk)
    rst |=> ( !err && inp_valid == 2'b00 && cmd == 4'b0000 && !mode)
    );

endmodule
