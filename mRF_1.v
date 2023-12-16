module mRF_1#(
    parameter WORDWIDTH = 32,
    parameter NUM1 = 5,
    parameter CHANNEL = 6
    )
(
    input clk,
    input [$clog2(CHANNEL*NUM1)-1:0]count,
    input [WORDWIDTH-1:0] reg_data,
    output [WORDWIDTH-1:0] reg_out
);

reg [WORDWIDTH-1:0] reg_0;
assign reg_out = reg_0;

always @(count)begin
    if(count== 'd0)begin
        reg_0 <= 'd0;
    end
    else begin
        reg_0 <= reg_data;
    end

end



endmodule
