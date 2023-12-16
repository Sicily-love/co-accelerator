module mRF_5#(
  parameter WORDWIDTH = 32,
  parameter IN_NUM = 5,
  parameter OUT_NUM = 5,
  parameter CHANNEL = 6
)
(
    input clk,
    input rstn,
    input [$clog2(CHANNEL*IN_NUM)-1:0]count,
    input [CHANNEL*IN_NUM*WORDWIDTH-1:0] reg_data,
    output reg [CHANNEL*OUT_NUM*WORDWIDTH-1:0] reg_out1,
    output [WORDWIDTH-1:0]op_a
);
  reg [CHANNEL*OUT_NUM*WORDWIDTH-1:0] reg0;
  always@(posedge clk or negedge rstn)
  begin
    if(~rstn)
    begin
      reg0 <= 'd0;
    end
    else
    begin
      reg0<=reg_data;
      reg_out1 <= reg0;
    end

  end

  assign op_a=reg0[(count+1)*WORDWIDTH-1 -:WORDWIDTH];
  



endmodule