package ALSU_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class ALSU_env extends uvm_env;
        `uvm_component_utils(ALSU_env)

        ALSU_agent agt;
        ALSU_scoreboard sb;
        ALSU_coverage cov;

        

    endclass
