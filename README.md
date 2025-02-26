# Electronic Battleship Game on FPGA

Digital implementation of the classic Battleship game for two players, designed and deployed on an FPGA using Verilog

## Project Overview
This project is a digital implementation of the classic Battleship game for two players, designed and deployed on an FPGA using Verilog. The game utilizes LEDs and seven-segment displays (SSDs) to visualize inputs, turns, scores, and ship sinking events.

## Features
- **Two-player gameplay** using dedicated buttons for each player.
- **4x4 grid per player** for placing and attacking ships.
- **LED indicators** for tracking turns, ship placements, and hits.
- **Seven-segment displays** for showing coordinates, scores, and game states.
- **Button-based controls** to reset, start, and play the game.
- **Real-time updates** for input validation and turn-based actions.
- **Game-winning condition** when a player sinks four opponent ships.

## Hardware and Implementation
- Implemented on an FPGA board.
- Uses **Verilog** for digital logic design.
- Includes additional modules:
  - **Clock Divider**: Generates a 50 Hz clock signal.
  - **Debouncer**: Detects stable button presses.
  - **Seven Segment Driver**: Manages SSD outputs.
- The **battleship.v** module contains the core game logic.
- The **battleship_tb.v** module provides a testbench for verification.

## Game Controls
- **Player A** uses `BTN3` for actions.
- **Player B** uses `BTN0` for actions.
- **Reset** (`BTN2`): Resets the game to "IDLE" state.
- **Start** (`BTN1`): Begins ship placement.
- **Switches (3-0)**: Used for X and Y coordinate input.

