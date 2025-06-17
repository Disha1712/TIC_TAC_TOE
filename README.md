# Tic-Tac-Toe Game in Verilog

A complete digital implementation of Tic-Tac-Toe game using Verilog HDL with modular design and comprehensive game logic.

## Features

- **Complete Game Logic**: Full Tic-Tac-Toe implementation with win/draw detection
- **Modular Design**: Separated cell logic from game controller
- **Automatic Turn Management**: Players alternate automatically (X starts first)
- **Win Detection**: All 8 winning combinations (rows, columns, diagonals)
- **Input Validation**: Prevents invalid moves and overwrites
- **Game State Management**: Tracks game progress and end conditions
- **Reset Functionality**: Clean board reset at any time

## Project Structure

```
├── TCell.v          # Individual cell module
├── TBox.v           # Main game controller
└── TBox_tb.v        # Comprehensive testbench
```

## Module Overview

### TCell - Game Cell
Models a single cell in the 3×3 board with:
- **State Management**: Tracks if cell is filled or empty
- **Symbol Storage**: Stores X (1) or O (0)
- **Write Protection**: Prevents overwriting until reset
- **Synchronous Operation**: Updates on clock edge

```verilog
module TCell(
    input clk,          // Clock signal
    input set,          // Set signal to place symbol
    input reset,        // Reset cell to empty
    input set_symbol,   // Symbol to place (1=X, 0=O)
    output reg valid,   // 1 if cell is filled
    output reg symbol   // Current symbol in cell
);
```

### TBox - Game Controller
Main game module managing the entire 3×3 board:
- **9 TCell Instances**: Complete board representation
- **Move Validation**: Row/column input validation (1-3)
- **Win Logic**: Checks all winning combinations
- **Game States**: In-progress, X wins, O wins, Draw

```verilog
module TBox(
    input clk,              // Clock signal
    input set,              // Execute move
    input reset,            // Reset entire board
    input [1:0] row,        // Row selection (1-3)
    input [1:0] col,        // Column selection (1-3)
    output [8:0] valid,     // Status of all 9 cells
    output [8:0] symbol,    // Symbols in all 9 cells
    output [1:0] game_state // Current game state
);
```

## Game States

| State | Binary | Meaning |
|-------|--------|---------|
| Game On | `00` | Game in progress |
| X Wins | `01` | Player X won |
| O Wins | `10` | Player O won |
| Draw | `11` | Board full, no winner |

## Board Layout

```
Coordinate System (row, col):
(1,1) (1,2) (1,3)
(2,1) (2,2) (2,3)
(3,1) (3,2) (3,3)

Internal Array Mapping:
[0] [1] [2]
[3] [4] [5]
[6] [7] [8]
```

## How to Run

### Prerequisites
- Verilog simulator (Icarus Verilog, ModelSim, etc.)
- GTKWave (optional, for waveform viewing)

### Simulation Steps

1. **Compile the design**:
   ```bash
   iverilog -o tictactoe TBox_tb.v
   ```

2. **Run simulation**:
   ```bash
   vvp tictactoe
   ```

3. **View results**: The testbench will output game states and test results

### Sample Output
```
Board State: Game on
X _ _
_ _ _
_ _ _
-------------
Board State: Game on
X O _
_ _ _
_ _ _
-------------
```

## Testing

The testbench includes comprehensive test cases:

- Basic Gameplay: Move placement and turn alternation
- Win Conditions: All 8 possible winning combinations
- Draw Scenarios: Full board without winner
- Invalid Moves: Occupied cells, out-of-bounds coordinates
- Edge Cases: Game end handling, simultaneous operations
- Reset Functionality: Board clearing and state reset

### Key Test Scenarios
1. **O Wins**: Vertical line victory
2. **X Wins**: Horizontal line victory
3. **Draw Game**: All cells filled, no winner
4. **Invalid Moves**: Attempting to overwrite occupied cells
5. **Diagonal Wins**: Both diagonal victory conditions
6. **Post-Game Moves**: No moves allowed after game ends

## Design Highlights

### Architecture
- **Hierarchical Design**: TCell modules instantiated within TBox
- **Synchronous Logic**: All state changes on positive clock edge
- **Reset Priority**: Reset always overrides set operations
- **Modular Approach**: Separated concerns for maintainability

### Game Logic
- **Turn Management**: Automatic X/O alternation using toggle logic
- **Win Detection**: Combinational logic checking all win conditions
- **Move Validation**: Coordinates must be 1-3, cell must be empty
- **State Machine**: Clean transitions between game states

### Safety Features
- **Write Protection**: Occupied cells cannot be overwritten
- **Input Validation**: Invalid coordinates are ignored
- **Game Freeze**: No moves accepted after win/draw until reset

## Gameplay Rules

1. **Starting**: X always goes first
2. **Turns**: Players alternate automatically
3. **Winning**: First to get 3 in a row (horizontal, vertical, or diagonal)
4. **Draw**: All 9 cells filled with no winner
5. **Reset**: Can reset board at any time to start new game

## Technical Specifications

- **Clock Domain**: Single clock domain design
- **Reset Type**: Synchronous reset with priority
- **State Elements**: 9 TCell modules + game state register
- **Combinational Logic**: Win detection and move validation
- **I/O Interface**: Standard digital inputs/outputs

---

*A robust digital implementation demonstrating advanced Verilog design principles and complete game logic implementation.*
