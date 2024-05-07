package ALSU_seq_item_valid_invalid_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;
    typedef enum bit [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;

    class ALSU_seq_item_valid_invalid extends ALSU_seq_item;
        `uvm_object_utils(ALSU_seq_item_valid_invalid);

        constraint valid_cases_only {
            opcode inside {[OR:ROTATE]};  
            if (opcode == OR || opcode == XOR) {
                red_op_A == 0;
                red_op_B == 0;
            }
        }

        function new(string name = "ALSU_seq_item_valid_invalid");
            super.new(name);
        endfunction
    endclass: ALSU_seq_item_valid_invalid
endpackage  

    
    