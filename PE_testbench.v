module PE_testbench();
    parameter WORDWIDTH = 32;
    parameter NUM1 = 14;
    parameter NUM2 = 5;
    parameter CHANNEL = 2;
    reg clk;
    reg rstn;
    reg [2:0]round_mode;

    //reg [5*WORDWIDTH-1:0] W_in = {32'd3196749929,32'd3211979765,32'd1059679514,32'd1049567065,32'd3211979765};
    //reg [14*WORDWIDTH-1:0] ACT_in = {2{32'd3196749929,32'd1059679514,32'd3211979765,32'd1049567065,32'd3196749929,32'd1059679514,32'd3211979765}}; 
    //reg [5*WORDWIDTH-1:0] W_in ={32'hBE8A8869,32'hBF72EBF5,32'h3F296D1A,32'h3E8F1F59,32'hBF7A4DC1};
    //reg [14*WORDWIDTH-1:0] ACT_in ={32'h3F4FFF58,32'hBF429CBE,32'hBF48EF52,32'h3F3240CF,32'h3F2824AC,32'hBDAD8B99,32'h3E502A5B,32'hBF28595E,32'h3DAE3E09,32'h3F3D382A,32'hBE035C07,32'h3F5B41D2,32'hBF749F58,32'h3EC15F40};
    reg [CHANNEL*NUM2*WORDWIDTH-1:0] W_in = {10{32'd0}};
    reg [CHANNEL*NUM1*WORDWIDTH-1:0] ACT_in = {28{32'd0}};
    
    reg en = 1'b0;


    wire [(NUM1+1-NUM2)*WORDWIDTH-1:0] result;
    wire [CHANNEL*NUM2*WORDWIDTH-1:0] W_out;
    wire [CHANNEL*NUM1*WORDWIDTH-1:0] ACT_out;
    wire sum_enable;


    
    initial begin
        clk = 1;
        forever #2.5 clk = ~clk;
    end
    
    initial begin
        #20 W_in ={{32'hBE8A8869,32'hBF7A4DC1},{32'hBF72EBF5,32'hBF7A4DC1},{32'h3F296D1A,32'hBF7A4DC1},{32'h3E8F1F59,32'hBF7A4DC1},{32'h3F4FFF58,32'h3EC15F40}};
           ACT_in ={{32'h3F4FFF58,32'hBF429CBE,32'hBF48EF52,32'h3F3240CF,32'h3F2824AC,32'hBDAD8B99,32'h3E502A5B,32'hBF28595E,32'h3DAE3E09,32'h3F3D382A,32'hBE035C07,32'h3F5B41D2,32'hBF749F58,32'h3EC15F40},{32'h3F4FFF58,32'hBF429CBE,32'hBF48EF52,32'h3F3240CF,32'h3F2824AC,32'hBDAD8B99,32'h3E502A5B,32'hBF28595E,32'h3DAE3E09,32'h3F3D382A,32'hBE035C07,32'h3F5B41D2,32'hBF749F58,32'h3F3240CF}};
           
//          #20 W_in ={32'hBE8A8869,32'hBF72EBF5,32'h3F296D1A,32'h3E8F1F59,32'h3F4FFF58};
//            ACT_in ={32'h3F4FFF58,32'hBF429CBE,32'hBF48EF52,32'h3F3240CF,32'h3F2824AC,32'hBDAD8B99,32'h3E502A5B,32'hBF28595E,32'h3DAE3E09,32'h3F3D382A,32'hBE035C07,32'h3F5B41D2,32'hBF749F58,32'h3EC15F40};
            
            en = 1'b1;
    end

    initial begin
            rstn = 1;
            round_mode = 3'b000;
        #4  rstn = 0;
        #6 rstn = 1;
    end
    
    initial begin
        #3020 W_in = {10{32'hBF7A4DC1}};
             ACT_in = {28{32'h3EC15F40}};
    end

    PE #(.WORDWIDTH(WORDWIDTH),
    .CHANNEL(CHANNEL),
    .NUM1(NUM1),
    .NUM2(NUM2)
    ) PE(
        .clk(clk),
        .rstn(rstn),
        .round_mode(round_mode),
        .W_in(W_in),
        .ACT_in(ACT_in),
        .result(result),
        .W_out(W_out),
        .ACT_out(ACT_out),
        .sum_enable(sum_enable),
        .oen(oen),
        .en(en)
    );

endmodule