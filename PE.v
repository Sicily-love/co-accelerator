module PE#(
    parameter WORDWIDTH = 32,
    parameter CHANNEL = 2,
    parameter NUM1 = 14,
    parameter NUM2 = 5
    
)
(
    input clk,
    input rstn,
    input [2:0] round_mode,
    input [CHANNEL*WORDWIDTH*NUM2-1:0] W_in,
    input [CHANNEL*WORDWIDTH*NUM1-1:0] ACT_in,
    input en,
    output [WORDWIDTH*(NUM1+1-NUM2)-1:0] result,
    output [CHANNEL*WORDWIDTH*NUM2-1:0] W_out,
    output [CHANNEL*WORDWIDTH*NUM1-1:0] ACT_out,
    output sum_enable,
    output oen
);


wire [WORDWIDTH-1:0]op_a,op_b,op_c,partial_sum;
wire [$clog2(CHANNEL*NUM2)-1:0]count1;
wire [$clog2(NUM1+1-NUM2)-1:0]count2;
wire [1:0]count3;
wire [CHANNEL*WORDWIDTH*5-1:0]act;




assign oen = (W_out != 0)?1'b1:1'b0;



mRF_14 #(.WORDWIDTH(WORDWIDTH),
.IN_NUM(NUM1),
.OUT_NUM(NUM2),
.CHANNEL(CHANNEL)

) act_RF1(
    .clk(clk),
    .rstn(rstn),
    .count(count2),
    .reg_data(ACT_in),
    .reg_out1(ACT_out),
    .reg_out2(act)
);


assign op_b = act[(count1+1)*WORDWIDTH-1 -:WORDWIDTH];

mRF_5 #(
.WORDWIDTH(WORDWIDTH),
.IN_NUM(NUM2),
.OUT_NUM(NUM2),
.CHANNEL(CHANNEL)
) weight_RF(
    .clk(clk),
    .rstn(rstn),
    .count(count1),
    .reg_data(W_in),
    .reg_out1(W_out),
    .op_a(op_a)
);


pe_control #(
.WORDWIDTH(WORDWIDTH),
.NUM1(NUM1),
.NUM2(NUM2),
.CHANNEL(CHANNEL)
)
pe_control(

    .clk(clk),
    .en(en),
    .count1(count1),
    .count2(count2),
    .count3(count3)
);

mRF_1 #(
.WORDWIDTH(WORDWIDTH),
.NUM1(NUM2),
.CHANNEL(CHANNEL)
) result_RF(
    .clk(clk),
    .count(count1),
    .reg_data(partial_sum),
    .reg_out(op_c)
);


//fma  m_fma(
//         .clk_I(clk),
//         .rst_n_I(rstn),
//         .operand_a_I(op_a),
//         .operand_b_I(op_b),
//         .operand_c_I(op_c),
//         .rnd_mode(round_mode),//0:round to nearest, 1:round to zero, 2:round to +inf, 3:round to -inf
//         .gate(gate),
//         .result_O(partial_sum),
//         .flag_overflow_O(flag_overflow_O),//0:overflow, 1:no overflow
//         .flag_underflow_O(flag_underflow_O),//0:underflow, 1:no underflow
//         .done_valid_O(done_valid_O)
//       );

floating_point_0 fp(
    .aclk(clk),
    .s_axis_a_tdata(op_a),
    .s_axis_b_tdata(op_b),
    .s_axis_c_tdata(op_c),
    .s_axis_a_tvalid(en),
    .s_axis_b_tvalid(en),
    .s_axis_c_tvalid(en),
    .m_axis_result_tdata(partial_sum),
    .m_axis_result_tvalid(done_valid_O)
    
);

row_sum #(
.WORDWIDTH(WORDWIDTH),
.NUM1(NUM1),
.NUM2(NUM2),
.CHANNEL(CHANNEL)
) row_sum(
    .clk(clk),
    .rstn(rstn),
    .count1(count1),
    .count2(count2),
    .count3(count3),
    .reg_data(partial_sum),
    .reg_out(result),
    .sum_enable(sum_enable)
);


endmodule
