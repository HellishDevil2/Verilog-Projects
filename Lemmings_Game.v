module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    reg falling,underground,walk,walk_direction,dead;
    integer count;
    parameter LEFT = 1'b0,RIGHT = 1'b1;
    initial begin
        count = 0;
    end
    always@(posedge clk,posedge areset) begin
        if(areset) begin
            falling <= 0;
            underground <= 0;
            walk <= 1;
            walk_direction <= LEFT;
            dead <= 0;
            count <= 0;
        end
        else begin
            if(dead) begin
                falling <= 0;
                underground <= 0;
                walk <= 0;
                walk_direction <= walk_direction;
                dead <= 1;
                count <= count;
            end
            else begin
                if(!ground) begin
                    falling <= 1;
                    underground <= 0;
                    walk <= 0;
                    walk_direction <=walk_direction;
                    dead <= 0;
                    count <= count+1;
                end
                else begin
                    if(count > 20) begin
                        falling <= 0;
                        underground <= 0;
                        walk <= 0;
                        walk_direction <= walk_direction;
                        dead <= 1;
                        count <= count;
                    end
                    else if(falling) begin
                        falling <= 0;
                        underground <= 0;
                        walk <= 1;
                        walk_direction <= walk_direction;
                        dead <= 0;
                        count <= 0;
                    end
                    else begin
                        if(dig) begin
                            falling <= 0;
                            underground <= 1;
                            walk <= 0;
                            walk_direction <= walk_direction;
                            dead <= 0;
                            count <= 0;
                        end
                        else begin
                            if(underground) begin
                                falling <= 0;
                                underground <= 1;
                                walk <= 0;
                                walk_direction <= walk_direction;
                                dead <= 0;
                                count <= 0;
                            end
                            else begin
                                falling <= 0;
                                underground <= 0;
                                walk <= 1;
                                case({bump_left,bump_right})
                                    2'b11 : walk_direction <= ~walk_direction;
                                    2'b10 : walk_direction <= RIGHT;
                                    2'b01 : walk_direction <= LEFT;
                                    default : walk_direction <= walk_direction;
                                endcase
                                dead <= 0;
                                count <= 0;
                            end
                        end
                    end
                end
            end
        end
    end
    assign walk_left = walk ? walk_direction==LEFT : 0;
    assign walk_right = walk ? walk_direction==RIGHT : 0;
    assign aaah = falling==1;
    assign digging = underground==1;
        

endmodule
