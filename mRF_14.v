module mRF_14#(
  parameter WORDWIDTH = 32,
  parameter IN_NUM = 14,
  parameter OUT_NUM = 5,
  parameter CHANNEL = 6
)
(
    input clk,
    input rstn,
    input [$clog2(IN_NUM+1-OUT_NUM)-1:0]count,
    input [CHANNEL*IN_NUM*WORDWIDTH-1:0] reg_data,
    output reg [CHANNEL*IN_NUM*WORDWIDTH-1:0] reg_out1,
    output [CHANNEL*OUT_NUM*WORDWIDTH-1:0] reg_out2
);
  reg [CHANNEL*IN_NUM*WORDWIDTH-1:0] reg0;
  always @(posedge clk or negedge rstn)
  begin
    if(~rstn)
    begin
      reg0<='d0;
    end
    else
    begin
      reg0<=reg_data;
      reg_out1 <= reg0;
    end
    
  end

  assign reg_out2 = reg0[(count+OUT_NUM)*CHANNEL*WORDWIDTH-1 -:CHANNEL*OUT_NUM*WORDWIDTH];
  



endmodule