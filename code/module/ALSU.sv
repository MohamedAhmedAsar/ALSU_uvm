////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: ALSU Design 
//
////////////////////////////////////////////////////////////////////////////////
module ALSU(ALSU_if alsu_if);
localparam  INPUT_PRIORITY = alsu_if.INPUT_PRIORITY;
localparam FULL_ADDER = alsu_if.FULL_ADDER;

logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
logic [2:0] opcode;
logic signed [2:0] A, B;
logic [15:0] leds;
logic signed [5:0] out;

/* //!
input clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B;
output reg [15:0] leds;
output reg [5:0] out;
*/

//!input
assign clk=alsu_if.clk
assign rst=alsu_if.rst
assign cin=alsu_if.cin
assign red_op_A=alsu_if.red_op_A
assign red_op_B=alsu_if.red_op_B
assign bypass_A=alsu_if.bypass_A
assign bypass_B=alsu_if.bypass_B
assign direction=alsu_if.direction
assign serial_in=alsu_if.serial_in
assign opcode=alsu_if.opcode
assign A=alsu_if.A
assign B=alsu_if.B

//!output
assign alsu_if.out=out;
assign alsu_if.leds=leds;


reg cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg [2:0] opcode_reg, A_reg, B_reg;

wire invalid_red_op, invalid_opcode, invalid;

assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[2] & opcode_reg[3];
assign invalid = invalid_red_op | invalid_opcode;

always @(posedge clk or posedge rst) begin
  if(rst) begin
    leds <= 0;
    out <= 0;
    cin_reg <= 0;
    red_op_B_reg <= 0;
    red_op_A_reg <= 0;
    bypass_B_reg <= 0;
    bypass_A_reg <= 0;
    direction_reg <= 0;
    serial_in_reg <= 0;
    opcode_reg <= 0;
    A_reg <= 0;
    B_reg <= 0;
  end
  else begin
    if (invalid)
      leds <= ~leds;
    else
      leds <= 0;
    cin_reg <= cin;
    red_op_B_reg <= red_op_B;
    red_op_A_reg <= red_op_A;
    bypass_B_reg <= bypass_B;
    bypass_A_reg <= bypass_A;
    direction_reg <= direction;
    serial_in_reg <= serial_in;
    opcode_reg <= opcode;
    A_reg <= A;
    B_reg <= B;
    if (invalid) 
        out <= 0;
    else if (bypass_A_reg && bypass_B_reg)
      out <= (INPUT_PRIORITY == "A")? A_reg: B_reg;
    else if (bypass_A_reg)
      out <= A_reg;
    else if (bypass_B_reg)
      out <= B_reg;
    else begin
        case (opcode)
          3'h0: begin 
            if (red_op_A_reg && red_op_B_reg)
              out = (INPUT_PRIORITY == "A")? &A_reg: &B_reg;
            else if (red_op_A_reg) 
              out <= &A_reg;
            else if (red_op_B_reg)
              out <= &B_reg;
            else 
              out <= A_reg & B_reg;
          end
          3'h1: begin
            if (red_op_A_reg && red_op_B_reg)
              out <= (INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              out <= |A_reg;
            else if (red_op_B_reg)
              out <= |B_reg;
            else 
              out <= A_reg | B_reg;
          end
          3'h2: begin
            if (FULL_ADDER == "ON")
              out <= A_reg + B_reg + cin_reg;
            else
              out <= A_reg + B_reg;
          end
          3'h3: out <= A_reg * B_reg;
          3'h4: begin
            if (direction_reg)
              out <= {out[4:0], serial_in_reg};
            else
              out <= {serial_in_reg, out[5:1]};
          end
          3'h5: begin
            if (direction_reg)
              out <= {out[4:0], out[5]};
            else
              out <= {out[0], out[5:1]};
          end
        endcase
    end 
  end
end

endmodule