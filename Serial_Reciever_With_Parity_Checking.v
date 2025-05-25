module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Modify FSM and datapath from Fsm_serialdata

    // New: Add parity checking.
    integer count;
    reg[7:0] data;
    reg success;
    reg parity;
    initial begin
        count = 0;
        data = 0;
        success = 0;
    end
    always@(posedge clk) begin
        if(reset) begin
            count <= 0;
            data <= 0;
            success <= 0;
            parity <= 0;                           
        end
        else begin
            if(in==0&&count==0) begin
                count <= count + 1;
                data <= data;
                success <= 0;
                parity <= 0;
            end
            else if(in==1&count==10) begin
                count <= 0;
                data <= data;
                success <= 1;
                parity <= parity;
            end
            else if(in==1&&count>=11) begin
                count <= 0;
                data <= 0;
                success <= 0;
                parity <= 0;
            end
            else if(count > 0) begin
                if(count<=8) begin
                    data[count-1] <= in;
                    parity <= 0;
                end
                else if(count==9) begin
                    if(in!=^data) begin
                        parity <= 1;
                    end
                    else begin
                        parity <= 0;
                    end   
                end
                else begin
                    data <= data;
                    parity <= 0;
                end
                count <= count+1;
                success <= 0;                  
            end
            else begin
                data <= data;
                count <= count;
                success <= 0;
                parity <= 0;
            end
        end
    end
    assign done = success&parity;
    assign out_byte = done ? data : 0;
endmodule
