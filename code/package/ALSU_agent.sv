package ALSU_agent_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import ALSU_sequencer_pkg::*;
    import ALSU_driver_pkg::*;
    import ALSU_monitor_pkg::*;
    import ALSU_config_pkg::*;
    import ALSU_seq_item_pkg::*;

    class ALSU_agent extends uvm_agent;

        `uvm_component_utils(ALSU_agent)

        ALSU_sequencer squr;
        ALSU_driver drv;
        ALSU_monitor mon;
        ALSU_config alsu_cfg;
        
        uvm_analysis_port #(ALSU_seq_item) agt_ap;

        function new(string name = "ALSU_agent", uvm_component parent=null);
            super.new(name, parent);
        endfunction: new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(ALSU_config)::get(this,"","CFG",alsu_cfg))begin
                `uvm_fatal("build_phase", "ERROR");
            end

            squr=ALSU_sequencer::type_id::create("squr",this);
            drv=ALSU_driver::type_id::create("drv",this);
            mon=ALSU_monitor::type_id::create("mon",this);
            //agt_ap=ALSU_config::type_id::create("agt_ap",this);
            agt_ap=new("agt_ap",this);

        endfunction: build_phase
        

        function void connect_phase(uvm_phase phase);
        
            drv.alsu_vif=alsu_cfg.alsu_vif;
            mon.alsu_vif=alsu_cfg.alsu_vif;
            drv.seq_item_port.connect(squr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
        
        endfunction: connect_phase
        

    endclass

endpackage