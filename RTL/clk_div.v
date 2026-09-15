module div(ref_clk,out_clk,rst_n);
input wire ref_clk,rst_n;
output reg out_clk;
reg [22:0]c_reg;
always @(posedge ref_clk or negedge rst_n) begin
        if (~rst_n) begin
            c_reg<=0;
            out_clk<=0;

        end else if (c_reg==6250000) begin
            out_clk<=~out_clk;
              c_reg<=0;

            
        end else c_reg<=c_reg+1;

    end
    

endmodule