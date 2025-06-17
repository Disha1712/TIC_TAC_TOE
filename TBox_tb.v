`include "TBox.v"

`define PRINTCELL(index) \
    if (valid[index] == 0) $write ("_ ");                               \
    else if (valid[index] == 1 && symbol[index] == 1) $write ("X ");    \
    else if (valid[index] == 1 && symbol[index] == 0) $write ("O ");    \

`define PRINTBOARD                                                      \
    $write("Board State: ");                                            \
    if (game_state == 2'b00) $display("Game on");                       \
    else if (game_state == 2'b01) $display ("X won");                   \
    else if (game_state == 2'b10) $display ("O won");                   \
    else if (game_state == 2'b11) $display ("Draw");                    \
    else $display("Incorrect game state");                              \
    `PRINTCELL(0) `PRINTCELL(1) `PRINTCELL(2) $display("");             \
    `PRINTCELL(3) `PRINTCELL(4) `PRINTCELL(5) $display("");             \
    `PRINTCELL(6) `PRINTCELL(7) `PRINTCELL(8) $display("");             \
    $display("-------------");

`define PLAYMOVE(r,c)                                                   \
    reset <= 0; set <= 1; row <= r; col <= c; #20; set <= 0;            \
    `PRINTBOARD

`define RESETBOARD                                                      \
    reset <= 1; set <= 0; #40; reset <= 0;                              \
    `PRINTBOARD

module TBox_tb;
    wire [8:0] valid;
    wire [8:0] symbol;
    wire [1:0] game_state;
    reg [1:0] row, col;
    reg clk, set, reset;
    TBox tbox(clk,set,reset,row,col,valid,symbol,game_state);

    initial begin
        clk <= 0;
        #2

        if (|valid) $display("Testcase failed: Board is not empty initially");
        else if (game_state != 2'b00) $display("Testcase failed: Incorrect initial game state");
        else $display("Testcase 0 passed");

        // Game where O wins
        `PLAYMOVE(01,01)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(10,10)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(01,11)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(01,10)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(11,11)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(11,10)
        if (game_state != 2'b10) $display("Testcase failed: Incorrect game state change");
        else $display("Testcase 1 passed");

        // Game where X wins
        `RESETBOARD
        `PLAYMOVE(01,01)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(10,10)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(01,11)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(11,10)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(01,10)
        if (game_state != 2'b01) $display("Testcase failed: Incorrect game state change");
        else $display("Testcase 2 passed");

        // Additional Test Cases

        // Draw case
        `RESETBOARD
        `PLAYMOVE(01,01)
        `PLAYMOVE(01,10)
        `PLAYMOVE(01,11)
        `PLAYMOVE(10,01)
        `PLAYMOVE(10,11)
        `PLAYMOVE(10,10)
        `PLAYMOVE(11,01)
        `PLAYMOVE(11,11)
        `PLAYMOVE(11,10)
        if (game_state != 2'b11) $display("Testcase failed: Game did not end in a draw");
        else $display("Testcase 3 passed");

        // Invalid move attempt (same cell)
        `RESETBOARD
        `PLAYMOVE(01,01)
        `PLAYMOVE(01,01) 
        if (valid[0] == 1 && symbol[0] == 1 && game_state == 2'b00)
            $display("Testcase 4 passed");
        else
            $display("Testcase failed: Allowed invalid move on occupied cell");

        // X wins by filling diagonal
        `RESETBOARD
        `PLAYMOVE(01,01)
        `PLAYMOVE(01,10)
        `PLAYMOVE(10,10)
        `PLAYMOVE(01,11)
        `PLAYMOVE(11,11)
        if (game_state != 2'b01) $display("Testcase failed: X did not win (diagonal)");
        else $display("Testcase 5 passed");

        // Testcase for board not updating after game end
        `RESETBOARD
        `PLAYMOVE(01,01)  
        `PLAYMOVE(01,10)  
        `PLAYMOVE(01,11)  
        `PLAYMOVE(11,10) 
        `PLAYMOVE(10,10)  
        `PLAYMOVE(11,11)  
        `PLAYMOVE(10,11)
        `PLAYMOVE(11,01)
        if (game_state != 2'b10) $display("Testcase failed: O did not win correctly");
        else $display("Testcase 6 passed");

        // Attempting to make additional moves after O wins
        `PLAYMOVE(01,01)  // already occupied cell
        if (valid[0] == 1 && symbol[0] == 1 && game_state == 2'b10)
            $display("Testcase 7 passed");
        else
            $display("Testcase failed: Allowed move on occupied cell after game ended");

        // Testing invalid row/column values
        `RESETBOARD
        `PLAYMOVE(00,01)  // Invalid row
        if (game_state != 2'b00) $display("Testcase 8 failed: Game state changed on invalid move");
        `PLAYMOVE(01,00)  // Invalid column
        if (game_state != 2'b00) $display("Testcase 8 failed: Game state changed on invalid move");
        `PLAYMOVE(11,11)  // Valid move 
        if (!valid[8]) $display("Testcase 8 failed: Valid move not registered after invalid moves");
        else $display("Testcase 8 passed");

        // Reset during ongoing game
        `RESETBOARD
        `PLAYMOVE(01,01)
        `PLAYMOVE(10,10)
        `RESETBOARD
        if (|valid) $display("Testcase 9 failed: Board not cleared after reset");
        else if (game_state != 2'b00) $display("Testcase 9 failed: Game state not reset");
        else $display("Testcase 9 passed");
       
        //testing win on last move
        `RESETBOARD
        `PLAYMOVE(01,01)  
        `PLAYMOVE(01,10)  
        `PLAYMOVE(01,11)  
        `PLAYMOVE(10,01)  
        `PLAYMOVE(10,11)  
        `PLAYMOVE(10,10)  
        `PLAYMOVE(11,10)  
        `PLAYMOVE(11,01) 
        `PLAYMOVE(11,11)  
        if (game_state != 2'b01) $display("Testcase 10 failed: Win not detected on final move");
        else $display("Testcase 10 passed");

        // Testing simultaneous set and reset
        `RESETBOARD
        `PLAYMOVE(01,01)
        set <= 1;
        reset <= 1;
        row <= 2'b10;
        col <= 2'b10;
        #20;
        set <= 0;
        reset <= 0;
        if (|valid) $display("Testcase 11 failed: Reset should take precedence over set");
        else $display("Testcase 11 passed");

        $finish;
    end

    always begin
        #5 clk <= ~clk;
    end
endmodule
