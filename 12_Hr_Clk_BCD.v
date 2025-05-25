module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    wire[7:0] hh_24;
    mod_60 second_hand(clk,reset,ena,ss);
    wire minute = ena&(ss==8'd89);
    mod_60 minute_hand(clk,reset,minute,mm);
    wire hour = ena&(mm==8'd89)&(ss==8'd89);
    mod_24 hour_hand(clk,reset,hour,hh_24);
    reg [8:0] result;
    always@(*) begin
        if(hh_24==0) begin
            hh = 8'b00010010;
            pm = 0;
        end
        else if(hh_24[7:4]==4'd1&(hh_24[3:0]>4'd2)) begin
            hh[7:4] = 0;
            hh[3:0] = hh_24[3:0] - 4'd2;
            pm = 1;
        end
        else if(hh_24[7:4]==4'd2) begin
            hh[7:4] = (hh_24[3:0] + 4'd8)/4'd10;
            hh[3:0] = (hh_24[3:0] + 4'd8)%4'd10;
            pm = 1;
        end
            
        else if(hh_24==8'd18) begin
            hh = hh_24;
            pm = 1;
        end
        else begin
            hh = hh_24;
            pm = 0;
        end
    end
endmodule



module mod_60(input clk,input reset,input ena,output[7:0] ss);
    always@(posedge clk) begin
        if(reset) begin
           ss<=0;
        end
        else if(!ena) begin
            ss<=ss;
        end
        else if(ss==8'd89) begin
            ss<=0;
        end
        else if(ss[3:0]==4'd9) begin
            ss[7:4] <= ss[7:4] + 4'd1;
            ss[3:0] <= 0;
        end
        else begin
            ss[3:0] <= ss[3:0]+4'd1;
        end
    end
endmodule

module mod_24(input clk,input reset,input ena,output[7:0] hh);
    always@(posedge clk) begin
        if(reset) begin
            hh <= 0;
        end
        else if(!ena) begin
            hh <= hh;
        end
        else if(hh==8'd35) begin
            hh <= 0;
        end
        else if(hh[3:0]==4'd9) begin
            hh[7:4] <= hh[7:4] + 4'd1;
            hh[3:0] <= 0;
        end
        else begin
            hh[3:0] <= hh[3:0]+4'd1;
        end
    end
endmodule
        
            
            
            
    
        