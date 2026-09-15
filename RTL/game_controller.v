module controller(clk,rst_n,btn,sw,leds,gg,win_flag);
input  wire clk,rst_n,btn;
input  wire [9:0] sw,leds;
output wire gg;
output reg win_flag;
localparam initialy=2'b00,active=2'b01,result=2'b10;
 reg [1:0] ns,cs;


 always @(*) begin
    casez (cs)
        2'b00:  ns=2'b01;
        2'b01: if(~btn)ns=2'b10;
        else ns=2'b01;
        2'b10:   ns=cs;     

        default: ns=2'b00;
    endcase
    
 end

 always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      
    cs<=0;
     win_flag <= 0;
    end
    else begin cs<=ns;
        if (cs == active && btn == 1'b0) begin
                if (leds == sw) win_flag <= 1;
                else win_flag <= 0;
            end
        end
    end

    


assign gg = (cs == result) ? 1'b1 : 1'b0;

endmodule