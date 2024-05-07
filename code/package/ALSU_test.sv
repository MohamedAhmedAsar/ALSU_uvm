package ALSU_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
        
    import ALSU_env_pkg::*;
    import ALSU_config_pkg::*;
    import ALSU_main_sequence_pkg::*;
    import ALSU_reset_sequence_pkg::*;
    import ALSU_seq_item_valid_invalid_pkg::*;
    import ALSU_seq_item_pkg::*;


    
    
    class ALSU_test extends uvm_test;
        `uvm_component_utils(ALSU_test)

        ALSU_env env;
        ALSU_config alsu_cgf;
        ALSU_main_sequence main_seq;
        ALSU_reset_sequence reset_seq;

        function new(string name = "ALSU_test",uvm_component parent =null);
            super.new(name,parent);
        endfunction: new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            set_type_override_by_type(ALSU_seq_item::get_type(), ALSU_seq_item_valid_invalid::get_type());
            env=ALSU_env::type_id::create("env",this);
            alsu_cgf=ALSU_config::type_id::create("alsu_cgf",this);
            main_seq=ALSU_main_sequence::type_id::create("main_seq",this);
            reset_seq=ALSU_reset_sequence::type_id::create("reset_seq",this);

            if(!uvm_config_db#(virtual ALSU_if)::get(this, "", "INTF", alsu_cgf.alsu_vif))
            `uvm_fatal("build_phase", "error");
            
            uvm_config_db#(ALSU_config)::set(this, "*", "CFG", alsu_cgf);
            
        endfunction: build_phase
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            set_type_override_by_type(ALSU_seq_item::get_type(), ALSU_seq_item_valid_invalid::get_type());
            phase.raise_objection(this);
            `uvm_info("run_phase", "reset asserted", UVM_LOW)
            reset_seq.start(env.agt.squr);
            `uvm_info("run_phase", "reset deasserted", UVM_LOW)

            `uvm_info("run_phase", "stimulus Genration Started", UVM_LOW)
            main_seq.start(env.agt.squr);
            `uvm_info("run_phase", "stimulus Genration ended", UVM_LOW)
            phase.drop_objection(this);
        endtask: run_phase
        

    endclass
endpackage
