# FPGA Reaction Time Game

A Verilog HDL implementation of a reaction-time LED chaser game for the **Terasic DE10-Standard FPGA board**.

## Overview

The game moves a single active LED across a 10-LED array at approximately **4 Hz**.  
The player selects a target LED using the 10 slide switches and presses the reaction button when the moving LED reaches the selected position.

The game then evaluates the result:

- **WIN** → `BOSS`
- **LOSE** → `LOSE`
- The LED movement stops after the result until the next reset.

The project follows the main functional requirements defined in the supplied Hardware Requirements & Specifications (HRS) document.

## Features

- Verilog HDL RTL design
- 50 MHz system clock
- 10-LED circular chaser
- 10-bit target selection using slide switches
- Push-button debouncing
- FSM-based game controller
- WIN/LOSE evaluation
- Four 7-segment displays
- Asynchronous active-low reset
- Quartus Tcl pin-assignment script
- Basic RTL simulation testbench for the debouncer

## Hardware

**Target Board:** Terasic DE10-Standard  
**FPGA:** Intel Cyclone V SoC 5CSXFC6D6F31C6

### I/O

| Signal | Direction | Width | Function |
|---|---|---:|---|
| `CLK_50MHz` | Input | 1 | 50 MHz system clock |
| `RST_N` | Input | 1 | Active-low reset |
| `BTN_PRESS` | Input | 1 | Player reaction button |
| `SW_TARGET` | Input | 10 | Target LED selection |
| `LEDS` | Output | 10 | Moving LED pattern |
| `HEX3:HEX0` | Output | 4 × 7 | Result display |

## Architecture

```text
                    +----------------+
CLK_50MHz --------->|   Clock Divider|------> clk_4hz
                    +----------------+
                            |
                            v
                    +----------------+
                    |  LED Chaser    |------> LEDS[9:0]
                    +----------------+
                            |
                            v
                    +----------------+
BTN_PRESS --------->|   Debouncer    |------> debounced_btn
                    +----------------+
                            |
                            v
SW_TARGET ---------->+----------------+
LEDS --------------->| Game Controller|------> game_over
                     |   FSM          |------> win_flag
                     +----------------+
                              |
                              v
                     +----------------+
                     | 7-Segment      |
                     | Display Driver |
                     +----------------+
                         | | | |
                       HEX3 HEX2 HEX1 HEX0
```

## RTL Modules

### `top_reaction_game.v`

Top-level integration module. It connects the clock divider, debouncer, LED chaser, game controller, and 7-segment display.

### `clk_div.v`

Generates the approximately **4 Hz** LED movement clock from the 50 MHz input clock.

### `Button Debouncer.v`

Filters mechanical button transitions using a slower sampling tick generated from the 50 MHz reference clock.

### `leds.v`

Implements the 10-bit circular LED chaser.

Initial state:

```text
1000000000
```

The active LED shifts toward the least-significant bit and wraps back to the first LED.

### `game_controller.v`

Implements the game FSM:

```text
INITIAL -> ACTIVE -> RESULT
```

While active, the controller compares the current LED pattern with `SW_TARGET` when a button event is detected.

```text
LEDS == SW_TARGET  -> WIN
LEDS != SW_TARGET  -> LOSE
```

### `game_seg.v`

Displays the game result on four independent 7-segment outputs:

```text
WIN  -> B O S S
LOSE -> L O S E
PLAY -> Blank
```

## Game Flow

1. Set exactly one target switch to `1`.
2. Press and release reset.
3. The first LED turns on.
4. The active LED moves across the 10 LEDs.
5. Press the reaction button when the active LED matches the selected target.
6. The controller evaluates the result.
7. The LEDs stop moving and the result remains displayed until reset.

## Simulation

The repository includes:

```text
dep_tb.v
```

The testbench generates a 50 MHz clock using a 20 ns period and applies different button input sequences to exercise the debouncer.

For a full hardware-time debounce simulation, the testbench would need to run through the complete debounce counter interval. The current testbench is intended as a basic RTL stimulus.

## Pin Assignment

The project includes:

```text
pin_assignment_game.tcl
```

The script assigns the top-level ports to the DE10-Standard board resources:

- 50 MHz clock
- KEY0 reset
- KEY1 reaction button
- 10 slide switches
- 10 LEDs
- HEX0–HEX3

Run the script from Quartus Tcl/command-line after creating the Quartus project with the matching top-level entity.

## Project Structure

```text
Reaction-Time-FPGA-Game/
│
├── RTL/
│   ├── top_reaction_game.v
│   ├── game_controller.v
│   ├── leds.v
│   ├── clk_div.v
│   ├── Button Debouncer.v
│   └── game_seg.v
│
├── TB/
│   └── dep_tb.v
│
├── Constraints/
│   └── pin_assignment_game.tcl
│
├── Docs/
│   └── HRS_Reaction_Time_Game.pdf
│
└── README.md
```

## Tools

- Verilog HDL
- Intel Quartus Prime
- ModelSim / QuestaSim
- Terasic DE10-Standard

## Specification Reference

The supplied HRS defines the main game behavior, including a 50 MHz input clock, active-low reset, 10-bit target switches, 10 LEDs, approximately 4 Hz LED shifting, WIN/LOSE evaluation, and result display on four 7-segment digits.

## Author

**Abdelrahman (Boda)**

FPGA / Digital Design Project
