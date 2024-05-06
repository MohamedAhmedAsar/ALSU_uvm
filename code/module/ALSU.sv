// ////////////////////////////////////////////////////////////////////////////////
// // Author: Kareem Waseem
// // Course: Digital Verification using SV & UVM
// //
// // Description: ALSU Design 
// //
// ////////////////////////////////////////////////////////////////////////////////
module ALSU(ALSU_if alsu_if);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
logic [2:0] opcode;
logic signed [2:0] A, B;
logic  [15:0] leds;
logic  signed [5:0] out;

//!input
assign clk=alsu_if.clk;
assign rst=alsu_if.rst;
assign cin=alsu_if.cin;
assign red_op_A=alsu_if.red_op_A;
assign red_op_B=alsu_if.red_op_B;
assign bypass_A=alsu_if.bypass_A;
assign bypass_B=alsu_if.bypass_B;
assign direction=alsu_if.direction;
assign serial_in=alsu_if.serial_in;
assign opcode=alsu_if.opcode;
assign A=alsu_if.A;
assign B=alsu_if.B;

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
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// module ALSU_dut(ALSU_if alsu_if);
//   parameter input_Priority ="A" ;
//   parameter FULL_ADDER ="ON" ;
//   logic [2:0]A,B,OPCODE;
//   logic  cin,serial_in,direction,red_op_A,red_op_B,by_pass_A,by_pass_B,clk,rst;
//   //wires
//   wire [2:0]A_out,B_out,OPCODE_out;
//   wire cin_out,serial_in_out,direction_out,red_op_A_out,red_op_B_out,by_pass_A_out,by_pass_B_out;
//   //reg
//   reg [5:0]out_temp;
//   reg [15:0]leds_temp;
//   reg flag;
//   //output
//   logic  [5:0]out;
//   logic  [15:0]leds;
  
  
//   //!input
//   assign clk=alsu_if.clk;
//   assign rst=alsu_if.rst;
//   assign cin=alsu_if.cin;
//   assign red_op_A=alsu_if.red_op_A;
//   assign red_op_B=alsu_if.red_op_B;
//   assign bypass_A=alsu_if.bypass_A;
//   assign bypass_B=alsu_if.bypass_B;
//   assign direction=alsu_if.direction;
//   assign serial_in=alsu_if.serial_in;
//   assign opcode=alsu_if.opcode;
//   assign A=alsu_if.A;
//   assign B=alsu_if.B;
  
//   //!output
//   assign alsu_if.out=out;
//   assign alsu_if.leds=leds;
  
//   //___________________________________________________
//   D_FF #(3) _A(A,clk,rst,A_out);
//   D_FF #(3) _B(B,clk,rst,B_out);
//   D_FF #(3) _OPCODE(OPCODE,clk,rst,OPCODE_out);
//   D_FF #(1) _cin(cin,clk,rst,cin_out);
//   D_FF #(1) _serial_in(serial_in,clk,rst,serial_in_out);
//   D_FF #(1) _direction(direction,clk,rst,direction_out);
//   D_FF #(1) _red_op_A(red_op_A,clk,rst,red_op_A_out);
//   D_FF #(1) _red_op_B(red_op_B,clk,rst,red_op_B_out);
//   D_FF #(1) _by_pass_A(by_pass_A,clk,rst,by_pass_A_out);
//   D_FF #(1) _by_pass_B(by_pass_B,clk,rst,by_pass_B_out);
//   D_FF #(6) _out(out_temp,clk,rst,out);
  
//   always @(*) begin
//       flag=0;
//       if(by_pass_A_out && by_pass_B_out) begin
//           if (input_Priority=="A") begin
//               out_temp={3'b0,A_out};
//           end
//           else if (input_Priority=="B")begin
//               out_temp={3'b0,B_out};
//           end
//       end
//       else if (by_pass_A_out) begin
//           out_temp={3'b0,A_out};
//       end
//       else if(by_pass_B_out)begin
//           out_temp={3'b0,B_out};
//       end
//       else if(OPCODE_out==6 || OPCODE_out==7 ||((OPCODE_out!=0  || OPCODE_out!=1)&& (red_op_A_out || red_op_B_out)))begin
//       flag=1;
//       out_temp=0;
//       end
//       else begin
//           case (OPCODE_out)
//               0:
//                   if (red_op_A_out &&red_op_B_out) begin
//                       if (input_Priority=="A") begin
//                           out_temp={5'b0,|A_out};
//                       end
//                       else if (input_Priority=="B")begin
//                           out_temp={5'b0,|B_out};
//                       end
//                   end
//                   else if (red_op_A_out)out_temp={5'b0,|A_out};
//                   else if (red_op_B_out)out_temp={5'b0,|B_out};
//                   else out_temp={3'b0,A|B};
//               1:
//                   if (red_op_A_out &&red_op_B_out) begin
//                       if (input_Priority=="A") begin
//                           out_temp={5'b0,^A_out};
//                       end
//                       else if (input_Priority=="B")begin
//                           out_temp={5'b0,^B_out};
//                       end
//                   end
//                   else if (red_op_A_out)out_temp={5'b0,^A_out};
//                   else if (red_op_B_out)out_temp={5'b0,^B_out};
//                   else out_temp={3'b0,A^B};
//               2:
//                   if (FULL_ADDER=="ON") begin
//                       out_temp={2'b0,A_out+B_out+cin_out};
//                   end 
//                   else begin
//                       out_temp={2'b0,A_out+B_out};
//                   end
//               3: out_temp=A_out*B_out;
//               4: //123   9 --->239
//                   if(direction_out) out_temp={out[4:0],serial_in_out};
//                   else out_temp={serial_in_out,out[5:1]};
//               5: //123 -->231
//                   if(direction_out)out_temp={out[4:0],out[5]};
//                   else out_temp={out[0],out[5:1]};
//           endcase
//       end
//   end
//   always @(posedge clk or posedge rst)begin
//   if(rst)leds_temp<=0;
//   else if(flag)leds_temp<=~leds_temp;
//   else leds_temp<=0;
//   end
//   assign leds=leds_temp;
//   endmodule