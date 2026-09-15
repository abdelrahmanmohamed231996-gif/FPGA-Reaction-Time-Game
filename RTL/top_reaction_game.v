// =============================================================
// Top-Level Module: Reaction Time (LED Chaser) Game
// Wires together: div, Debouncer, leds, controller, seven_segment_display
// Port names follow the HRS document where possible.
// =============================================================
module top_reaction_game(
    input  wire        CLK_50MHz,   // 50 MHz main clock
    input  wire        RST_N,       // active-low async reset
    input  wire        BTN_PRESS,   // raw push button (undebounced)
    input  wire [9:0]  SW_TARGET,   // target switches

    output wire [9:0]  LEDS,        // 10-LED chaser output

    // NOTE: game_seg.v drives 4 independent 7-bit HEX buses
    // (one per digit) instead of a multiplexed SEG_DATA/SEG_SEL pair.
    // Kept as HEX3..HEX0 here to match the RTL as written; see chat
    // note below if you want it renamed/adapted to SEG_DATA/SEG_SEL.
    output wire [6:0]  HEX3,
    output wire [6:0]  HEX2,
    output wire [6:0]  HEX1,
    output wire [6:0]  HEX0
);

    // ---------------- Internal wires ----------------
    wire        clk_4hz;        // 4 Hz tick from clock divider
    wire        debounced_btn;  // clean single-cycle-qualified button
    wire [9:0]  leds_out;       // current shift-register / LED pattern
    wire        gg;             // game-over flag (1 = round finished)
    wire        win_flag;       // 1 = win, 0 = lose (valid when gg = 1)

    // ---------------- Clock Divider (50 MHz -> 4 Hz) ----------------
    div u_clk_div (
        .ref_clk (CLK_50MHz),
        .rst_n   (RST_N),
        .out_clk (clk_4hz)
    );

    // ---------------- Button Debouncer (runs on 50 MHz) --------------
    Debouncer u_debouncer (
        .ref_clk (CLK_50MHz),
        .rst_n   (RST_N),
        .btn_in  (BTN_PRESS),
        .btn_out (debounced_btn)
    );

    // ---------------- LED Shift Register (shifts at 4 Hz) ------------
    leds u_leds (
        .clk      (clk_4hz),
        .rst_n    (RST_N),
        .leds_out (leds_out)
    );

    // ---------------- Game FSM / Controller (runs on 50 MHz) ---------
    // Evaluates debounced_btn asynchronously against the live LED
    // pattern coming from u_leds.
    controller u_controller (
        .clk      (CLK_50MHz),
        .rst_n    (RST_N),
        .btn      (debounced_btn),
        .sw       (SW_TARGET),
        .leds     (leds_out),
        .gg       (gg),
        .win_flag (win_flag)
    );

    // ---------------- 7-Segment Result Display ------------------------
    seven_segment_display u_seg (
        .gg       (gg),
        .win_flag (win_flag),
        .HEX3     (HEX3),
        .HEX2     (HEX2),
        .HEX1     (HEX1),
        .HEX0     (HEX0)
    );

    // ---------------- LED output ----------------
    assign LEDS = leds_out;

endmodule
