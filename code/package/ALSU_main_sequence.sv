package ALSU_main_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;
    // int x=0;
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
                //x++;
                assert(seq_item.randomize());
                // `uvm_info("run_phase", $sformatf("sample num %0d",x), UVM_LOW)
                // `uvm_info("run_phase", $sformatf("\n A=%0d",seq_item.A), UVM_LOW)
                // `uvm_info("run_phase", $sformatf("\n B=%0d",seq_item.B), UVM_LOW)
                seq_item.rst=0;
                finish_item(seq_item);
            end
        endtask
    endclass
    

endpackage