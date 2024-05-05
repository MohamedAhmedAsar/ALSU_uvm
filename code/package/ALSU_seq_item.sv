package ALSU_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    //!no import here
    //  Class: ALSU_seq_item
    //
    parameter VALID_OP = 6;
    typedef enum bit [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    typedef enum {MAXPOS=3, ZERO = 0, MAXNEG=-4} reg_e;

    class ALSU_seq_item extends uvm_sequence_item;
        typedef ALSU_seq_item this_type_t;
        `uvm_object_utils(ALSU_seq_item);
    
        //  Group: Variables
        rand logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in; 
        rand logic [2:0] A, B; 
        rand opcode_e opcode;
        rand opcode_e opcode_valid [VALID_OP];
        rand reg_e enum_ext_A, enum_ext_B;
        rand logic [3:0] A_rem_values, B_rem_values;
        bit [2:0] walking_ones[]='{3'b001, 3'b010, 3'b100};
        rand bit [2:0] walking_ones_t, walking_ones_f;
        logic [5:0]out;
        logic [15:0]leds;
        
    
        //  Group: Constraints
    
        constraint A_B_con {
            A_rem_values != MAXPOS || 0 || MAXNEG;
            B_rem_values != MAXPOS || 0  || MAXNEG;
            walking_ones_t inside {walking_ones};
            !(walking_ones_f inside {walking_ones});
        
            if (opcode == OR || opcode == XOR) {
                if (red_op_A == 1) {
                    A dist {walking_ones_t:= 88, walking_ones_f:= 20};
                } else if (red_op_B == 1) {
                    B dist {walking_ones_t:= 88, walking_ones_f:= 20};
                }
            } else {
                red_op_A dist {1:= 20, 0:= 80};
                red_op_B dist {1:= 20, 0:= 80};
                if (opcode == ADD || opcode == MULT) {
                    A dist {enum_ext_A:= 80, A_rem_values:= 20};
                    B dist {enum_ext_B:= 80, B_rem_values:= 20};
                }
            }
        }
        constraint opcode_con {
            opcode dist {[OR:ROTATE]:= 80, [INVALID_6:INVALID_7]:= 20};
        }
        
        constraint opcode_seq_con {
            foreach (opcode_valid[i])
            foreach (opcode_valid[j]) {
                if (i!=j) {
                    opcode_valid[i] != opcode_valid[j];
                    opcode_valid[i] inside {[OR:ROTATE]};
                }
            }
        }
        constraint bypass_con {
            bypass_A dist {1:=2, 0:=98};
            bypass_B dist {1:=2, 0:=98};
        }
        //  Group: Functions
    
        //  Constructor: new
        function new(string name = "ALSU_seq_item");
            super.new(name);
        endfunction: new
    
        function string convert2string();
            return $sformatf("%s rst=%0d, cin=%0d, red_op_A=%0d, red_op_B=%0d, bypass_A=%0d, bypass_B=%0d, direction=%0s, serial_in =%0d,A=%0d, B=%0d,opcode=%0d,out=%0d,leds=%0d"
                ,super.convert2string(),rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in ,A, B,opcode,out,leds
                );
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst=%0d, cin=%0d, red_op_A=%0d, red_op_B=%0d, bypass_A=%0d, bypass_B=%0d, direction=%0s, serial_in =%0d,A=%0d, B=%0d,opcode=%0d",
                rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in ,A, B,opcode
                );
        endfunction

        //  Function: do_copy
        // extern function void do_copy(uvm_object rhs);
        //  Function: do_compare
        // extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        //  Function: convert2string
        // extern function string convert2string();
        //  Function: do_print
        // extern function void do_print(uvm_printer printer);
        //  Function: do_record
        // extern function void do_record(uvm_recorder recorder);
        //  Function: do_pack
        // extern function void do_pack();
        //  Function: do_unpack
        // extern function void do_unpack();
        
    endclass: ALSU_seq_item
    
    /*----------------------------------------------------------------------------*/
    /*  Constraints                                                               */
    /*----------------------------------------------------------------------------*/
    
    
    
    
    /*----------------------------------------------------------------------------*/
    /*  Functions                                                                 */
    /*----------------------------------------------------------------------------*/
    
    