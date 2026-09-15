module leds(clk,rst_n,leds_out);
input wire clk,rst_n;
output wire[9:0] leds_out;
reg[9:0] leds_out_reg;


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        leds_out_reg<=10'b10_0000_0000;

    
    end 
    else  begin  

             leds_out_reg<=leds_out_reg>>1;
             if(leds_out_reg==10'b00_0000_0001)        leds_out_reg<=10'b10_0000_0000;

    end

end
assign leds_out = leds_out_reg;





endmodule