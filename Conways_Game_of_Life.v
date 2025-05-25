module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
    integer count,row,col,prev_row,prev_col,next_col,next_row; 
    always@(posedge clk) begin
        if(load) begin
            q<=data;
        end
        else begin
            count = 0;
            for(int i=0;i<256;i=i+1) begin
                row = i / 16;
                col = i % 16;
                prev_row = (row == 0) ? 15 : row - 1;
                next_row = (row == 15) ? 0 : row + 1;
                prev_col = (col == 0) ? 15 : col - 1;
                next_col = (col == 15) ? 0 : col + 1;

                // Now compute neighbor count
                count = 
                    q[16*prev_row + prev_col] + q[16*prev_row + col] + q[16*prev_row + next_col] +
                    q[16*row      + prev_col] +                      + q[16*row      + next_col] +
                    q[16*next_row + prev_col] + q[16*next_row + col] + q[16*next_row + next_col];
                case(count) 
                    2:q[i]<=q[i];
                    3:q[i]<=1;
                    default:q[i]<=0;
                endcase                    
            end
        end
    end
endmodule
