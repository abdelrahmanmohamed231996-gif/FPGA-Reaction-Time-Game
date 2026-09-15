module seven_segment_display (gg,win_flag,HEX3, HEX2,HEX1,HEX0 );
    input  wire gg;       
    input  wire win_flag;  
    output reg [6:0] HEX3; 
    output reg [6:0] HEX2;
    output reg [6:0] HEX1; 
    output reg [6:0] HEX0;

   
    localparam OFF = 7'b111_1111;
    localparam B   = 7'b000_0011; // b
    localparam O   = 7'b100_0000; // O
    localparam S   = 7'b001_0010; // S 
    localparam L   = 7'b100_0111; // L
    localparam E   = 7'b000_0110; // E

    always @(*) begin
        if (gg == 1'b0) begin
            HEX3 = OFF;
            HEX2 = OFF;
            HEX1 = OFF;
            HEX0 = OFF;
        end else begin
           if (win_flag == 1'b1) begin
                HEX3 = B;
                HEX2 = O;
                HEX1 = S;
                HEX0 = S;
            end else begin
                HEX3 = L;
                HEX2 = O;
                HEX1 = S;
                HEX0 = E;
            end
        end
    end

endmodule