package ALSU_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;//!idk  ?  ?  FIXME:
    class ALSU_monitor extends uvm_monitor;
        `uvm_component_utils(ALSU_monitor)
        virtual ALSU_if alsu_vif;
        ALSU_seq_item rsp_seq_item;
        uvm_analysis_port #(ALSU_seq_item) mon_ap;
    
        function new(string name = "ALSU_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction
    
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = ALSU_seq_item::type_id::create("rsp_seq_item");
                @(negedge alsu_vif.clk);
                rsp_seq_item.opcode = opcode_e'(alsu_vif.opcode);//!what is this ?
                // rsp_seq_item.mode = mode('alsu_vif.mode);
                rsp_seq_item.cin = alsu_vif.cin;
                rsp_seq_item.red_op_A = alsu_vif.red_op_A;
                rsp_seq_item.red_op_B = alsu_vif.red_op_B;
                rsp_seq_item.bypass_A = alsu_vif.bypass_A;
                rsp_seq_item.bypass_B = alsu_vif.bypass_B;
                rsp_seq_item.direction = alsu_vif.direction;
                rsp_seq_item.serial_in = alsu_vif.serial_in;
                rsp_seq_item.leds = alsu_vif.leds;
                rsp_seq_item.out = alsu_vif.out;
                mon_ap.write(rsp_seq_item);
                uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
    

endpackage