package ALSU_main_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;
    class ALSU_main_sequence extends uvm_sequence#(ALSU_seq_item);
        `uvm_object_utils(ALSU_main_sequence);
        ALSU_seq_item seq_item;
    
        function new (string name = "ALSU_main_sequence");
            super.new(name);
        endfunction
    
        task body;
            repeat(1000) begin
                seq_item = ALSU_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize());
                seq_item.rst=0;
                finish_item(seq_item);
            end
        endtask
    endclass
    

endpackage