package ALSU_config_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

//  Class: ALSU_config
//
class ALSU_config extends uvm_object;
    `uvm_object_utils(ALSU_config);

    //  Group: Variables


    //  Group: Constraints
    virtual alsu_if alsu_vif;

    //  Group: Functions

    //  Constructor: new
    function new(string name = "ALSU_config");
        super.new(name);
    endfunction: new
    
endclass: ALSU_config

endpackage