module D_FF(D,clk,rst,Q);
parameter size=4;
input [size-1:0]D;
input clk,rst;
output reg [size-1:0]Q;
always @(posedge clk or posedge rst) begin
    if(rst)Q<=0;
    else Q<=D;
end
endmodule