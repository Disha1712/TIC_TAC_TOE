`include "TCell.v"

module TBox(input clk,input set,input reset,input [1:0] row,input [1:0] col,output [8:0] valid,output[8:0] symbol,output[1:0] game_state);

    parameter gstart=2'b00;
    parameter X_won=2'b01;
    parameter O_won=2'b10;
    parameter draw=2'b11;
    reg [1:0] state,next_state;
    reg set_symbol;

    initial begin
        set_symbol=1'b0;
        state=gstart;
    end

    always @(posedge set,posedge reset)
    begin
        set_symbol <= ~set_symbol;
    end

    TCell cell_00 (clk,set & (row == 2'b01) & (col ==2'b01),reset,set_symbol,valid[0],symbol[0]);
    TCell cell_01 (clk,set & (row == 2'b01) & (col ==2'b10),reset,set_symbol,valid[1],symbol[1]);
    TCell cell_02 (clk,set & (row == 2'b01) & (col == 2'b11),reset,set_symbol,valid[2],symbol[2]);
    TCell cell_10 (clk,set & (row == 2'b10) & (col == 2'b01),reset,set_symbol,valid[3],symbol[3]);
    TCell cell_11 (clk,set & (row == 2'b10) & (col == 2'b10),reset,set_symbol,valid[4],symbol[4]);
    TCell cell_12 (clk,set & (row == 2'b10) & (col == 2'b11),reset,set_symbol,valid[5],symbol[5]);
    TCell cell_20 (clk,set & (row == 2'b11) & (col == 2'b01),reset,set_symbol,valid[6],symbol[6]);
    TCell cell_21 (clk,set & (row == 2'b11) & (col == 2'b10),reset,set_symbol,valid[7],symbol[7]);
    TCell cell_22 (clk,set & (row == 2'b11) & (col == 2'b11),reset,set_symbol,valid[8],symbol[8]);

    always @(posedge clk,posedge reset)
        begin
            if (reset)
            begin
                state<= gstart;
                next_state=gstart;
                set_symbol=1'b0;
            end    
            else 
            begin
                case (state)
                    gstart:
                    begin
                        if (valid[2:0]==3'b111 && symbol[0] == symbol[1] && symbol[1] == symbol[2]) 
                            next_state=symbol[0] ? X_won:O_won; 
                        
                        else if (valid[5:3]==3'b111 && symbol[3] == symbol[4] && symbol[4] == symbol[5])
                            next_state = symbol[3] ? X_won:O_won;
                        
                        else if (valid[8:6]==3'b111 && symbol[6] == symbol[7] && symbol[7] == symbol[8]) 
                            next_state= symbol[6] ? X_won:O_won;
                        
                        else if (valid[0] && valid[3] && valid[6] && symbol[0] == symbol[3] && symbol[3] == symbol[6]) 
                            next_state=symbol[0] ? X_won:O_won;
                        
                        else if (valid[1] && valid[4] && valid[7] && symbol[1] == symbol[4] && symbol[4] == symbol[7]) 
                            next_state=symbol[1] ? X_won:O_won;
                        
                        else if (valid[2] && valid[5] && valid[8] && symbol[2] == symbol[5] && symbol[5] == symbol[8]) 
                            next_state=symbol[2] ? X_won:O_won; 
                        
                        else if (valid[0] && valid[4] && valid[8] && symbol[0] == symbol[4] && symbol[4] == symbol[8]) 
                            next_state=symbol[0] ? X_won:O_won; 
                        
                        else if (valid[2] && valid[4] && valid[6] && symbol[2] == symbol[4] && symbol[4] == symbol[6]) 
                            next_state=symbol[2] ? X_won:O_won; 
                        
                        else if (valid[8:0]==9'b111111111) 
                            next_state=draw;
                    end
                    X_won:  next_state=state;
                    O_won:  next_state=state;
                    draw:   next_state=state;
                    default:  next_state=gstart;
                
                endcase
            end
            state=next_state;
        end
    assign game_state = state;


endmodule