package ALSU_driver_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;
    import ALSU_seq_item_valid_invalid_pkg::*;

    class ALSU_driver extends uvm_driver #(ALSU_seq_item);
        `uvm_component_utils(ALSU_driver)

        virtual ALSU_if alsu_vif;
        ALSU_seq_item stim_seq_item;

        function new(string name = "ALSU_driver" , uvm_component parent = null);
            super.new(name,parent);
        endfunction

        // function void ALSU_driver::build_phase(uvm_phase phase);
        //     /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
        //     /*  For more information see UVM Cookbook v1800.2 p.503  */
        //     super.build_phase(phase);
        //     set_type_override_by_type(ALSU_seq_item::get_type(), ALSU_seq_item_valid_invalid::get_type());
            
        // endfunction: build_phase
        

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = ALSU_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);
                alsu_vif.cin=stim_seq_item.cin;
                alsu_vif.red_op_A=stim_seq_item.red_op_A;
                alsu_vif.red_op_B=stim_seq_item.red_op_B;
                alsu_vif.bypass_A=stim_seq_item.bypass_A;
                alsu_vif.bypass_B=stim_seq_item.bypass_B;
                alsu_vif.direction=stim_seq_item.direction;
                alsu_vif.serial_in=stim_seq_item.serial_in;
                alsu_vif.A=stim_seq_item.A;
                alsu_vif.B=stim_seq_item.B;
                alsu_vif.opcode=stim_seq_item.opcode;
                alsu_vif.rst=stim_seq_item.rst;
                @(negedge alsu_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
    
endpackage