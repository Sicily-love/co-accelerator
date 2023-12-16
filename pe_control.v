module pe_control#(
    parameter WORDWIDTH = 32,
    parameter NUM1 = 14,
    parameter NUM2 = 5,
    parameter CHANNEL = 6
)
(

    input clk,
    input en,
    output reg [$clog2(CHANNEL*NUM2)-1:0]count1,
    output reg [$clog2(NUM1+1-NUM2)-1:0]count2,
    output reg [1:0]count3
);


    always @(posedge clk)begin
        if (~en)begin
            count1 <= CHANNEL*NUM2;
            count2 <= (NUM1-NUM2);
            count3 <= 'd2;
        end
        else begin
            if (en == 1'b1)begin
                count3 = count3 + 1;
            end
            else begin
                count3 = count3;
            end

            if (count3 == 2'd3)begin
                count1 = count1 +1;
                count3 = 2'd0;
            end
            else 
                count1 = count1;
            
            if (count1 == CHANNEL*NUM2)begin
                count2 = count2 + 1;
                count1 = 0;
            end
            else if (count1 == CHANNEL*NUM2+1)begin
                count2 = count2 + 1;
                count1 = 0;
            end
            else
                count2 = count2;

            if (count2 == (NUM1+1-NUM2))begin
                count2 = 0;
            end
            else
                count2 = count2;
           
        end
    end



endmodule