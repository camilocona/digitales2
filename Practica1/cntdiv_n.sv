module cntdiv_n #(TOPVALUE = 50_000_000) (clk, rst, Time, clkdiv);
    input logic clk, rst, Time;
    output logic clkdiv;
    
    // Bits for the counter
    localparam BITS = $clog2(TOPVALUE);
    
    // counter register
    logic [BITS - 1 : 0] rCounter,rCounter2;

    // increment or reset the counter
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            rCounter <= 0;
            rCounter2 <=0;
            clkdiv <= 0;
        end else begin
            if (rCounter == (TOPVALUE/2 - 1) | rCounter2 == (TOPVALUE - 1) ) begin
                rCounter <= 0;
                rCounter2 <= 0;
            end
            else begin
                if(Time) begin
                    
						  rCounter2 <= 0;
                    rCounter <= rCounter + 1;
                    clkdiv <= (rCounter >= (TOPVALUE/4)) ? 1'b1 : 1'b0;
						  
                end    
                else begin
          
						  rCounter <= 0;
                    rCounter2 <= rCounter2 + 1;
                    clkdiv <= (rCounter2 >= (TOPVALUE/2)) ? 1'b1 : 1'b0;
						  
                end    
            end    
        end
    end
endmodule   
