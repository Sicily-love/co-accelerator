module row_sum#(
    parameter WORDWIDTH = 32,
    parameter NUM1 = 14,
    parameter NUM2 = 5,
    parameter CHANNEL = 6
)
(
    input clk,
    input rstn,
    input [$clog2(CHANNEL*NUM2)-1:0]count1,
    input [$clog2(NUM1+1-NUM2)-1:0]count2,
    input [1:0]count3,
    input [WORDWIDTH-1:0] reg_data,
    output reg [(NUM1+1-NUM2)*WORDWIDTH-1:0] reg_out,
    output sum_enable

);
    reg [WORDWIDTH-1:0] reg_array [NUM1-NUM2:0];
    integer i;  
    
    assign sum_enable = (count2 == 'd0)?1'b1:1'b0;




    always @(count1)begin
        if (count1 == CHANNEL*NUM2)begin
            for (i=0;i<(NUM1+1-NUM2);i=i+1)begin
                reg_array[i] <= 32'd0;
            end
        end
        else if (count1 == 'd0)begin
            for (i = 0; i < (NUM1-NUM2);i = i+1)begin
                reg_array[i] <= reg_array[i+1];
            end
            reg_array[NUM1-NUM2] <= reg_data;
        end
        else begin
            for (i = 0; i < (NUM1+1-NUM2);i = i+1)begin
                reg_array[i] <= reg_array[i];
            end
        end
    end
    always @(*) begin
        // Concatenate the register array to the output
        for (i = 0; i < (NUM1+1-NUM2); i = i + 1) begin
            reg_out[i*WORDWIDTH +: WORDWIDTH] = reg_array[i];
        end
    end
endmodule