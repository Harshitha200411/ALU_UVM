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
        (inp_valid == 2'b01 && mode &&
         (cmd inside {0,1,2,3,8,9,10}))
        |-> ##[1:$](!(inp_valid inside {2'b10,2'b11})[*16] |=> err)
    );

    assert property (
        @(posedge clk) disable iff (rst)
        (inp_valid == 2'b10 && mode &&
         (cmd inside {0,1,2,3,8,9,10}))
        |-> (!(inp_valid inside {2'b01,2'b11})[*16] |=> err)
    );

    assert property (
        @(posedge clk) disable iff (rst)
        (inp_valid == 2'b01 && !mode &&
         (cmd inside {0,1,2,3,4,5,12,13}))
        |-> (!(inp_valid inside {2'b10,2'b11})[*16] |=> err)
    );

    assert property (
        @(posedge clk) disable iff (rst)
        (inp_valid == 2'b10 && !mode &&
         (cmd inside {0,1,2,3,4,5,12,13}))
        |-> (!(inp_valid inside {2'b01,2'b11})[*16] |=> err)
    );
    
    assert property (
    @(posedge clk) disable iff (rst)
    (!mode && !(cmd inside {14,15}))
    |-> err
    );
    
    assert property (
    @(posedge clk) disable iff (rst)
    (mode && !(cmd inside {11,12,13,14,15}))
    |-> err
    );
    
    assert property (
    @(posedge clk)
    rst |-> ( !err && inp_valid == 2'b00 && cmd == 4'b0000 && !mode)
    );

endmodule
