package ALSU_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
        
    import ALSU_env_pkg::*;
    import ALSU_config_pkg::*;
    import ALSU_main_sequence_pkg::*;
    import ALSU_reset_sequence_pkg::*;

    
    
    class ALSU_test extends uvm_test;
        `uvm_component_utils(ALSU_test)

        ALSU_env env;
        ALSU_config alu_cgf;
        ALSU_main_sequence main_seq;
        ALSU_reset_sequence reset_seq;

        function new(string name = "ALSU_test",uvm_component parent =null);
            super.new(name,parent);
        endfunction: new

        function void ALSU_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
            env=ALSU_env::type_id::create("env",this);
            alu_cgf=ALSU_config::type_id::create("alu_cgf",this);
            main_seq=ALSU_main_sequence::type_id::create("main_seq",this);
            reset_seq=ALSU_reset_sequence::type_id::create("reset_seq",this);

            if(!uvm_config_db#(virtual alsu_if)::get(this, "", "CFG", alsu_cfg.alsu_vif))
            `uvm_fatal("build_phase", "error");
            
            uvm_config_db#(ALSU_config)::set(this, "*", "CGF", alsu_cfg);
            

        endfunction: build_phase
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase", "reset asserted", UVM_low)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "reset asserted", UVM_low)

            `uvm_info("run_phase", "stimulus Genration Started", UVM_low)
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "stimulus Genration ended", UVM_low)
            phase.drop_objection(this);
        endtask: run_phase
        

    endclass
endpackage
